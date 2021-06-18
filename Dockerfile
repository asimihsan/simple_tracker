# -----------------------------------------------------------------------------
#   Base image.
# -----------------------------------------------------------------------------
FROM amazonlinux:2018.03.0.20210521.1 as base

ENV VERSION_RUST=1.53.0
ENV VERSION_NVM=0.38.0
ENV VERSION_NODE=14.17.1
ENV VERSION_CDK=1.109.0
ENV VERSION_GO=1.16.5

# Install Curl, Git, OpenSSL (AWS Amplify requirements), OpenSSH (AWS Amplify requirements)
RUN touch $HOME/.bashrc
RUN yum -y update && \
    yum -y groupinstall "Development Tools" && \
    yum -y install \
    curl \
    git \
    golang \
    moreutils \
    openssh \
    openssl \
    python3 \
    tar \
    which \
    wget && \
    yum clean all && \
    rm -rf /var/cache/yum
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup install ${VERSION_RUST}

# Install Node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v${VERSION_NVM}/install.sh | bash
RUN /bin/bash -c ". ~/.nvm/nvm.sh && \
    nvm install $VERSION_NODE && nvm use $VERSION_NODE && \
    nvm alias default node && nvm cache clear"

# Install Node dependencies
RUN /bin/bash -c ". ~/.nvm/nvm.sh && npm install cdk@$VERSION_CDK -g --unsafe-perm=true"

# Install Go
RUN wget -O go.tgz https://dl.google.com/go/go$VERSION_GO.src.tar.gz
RUN tar -C /usr/local -xzf go.tgz
RUN cd /usr/local/go/src/ && ./make.bash
RUN rm -f go.tgz
RUN mkdir $HOME/.go
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
#   Copy over CDK directory to pre-install dependencies.
# -----------------------------------------------------------------------------
FROM base as web_dependencies

ENV VERSION_NODE=14.17.1
ENV PATH="/root/.cargo/bin:/root/.nvm/versions/node/v${VERSION_NODE}/bin:${PATH}"

COPY cdk /root/cdk
RUN rm -rf /root/cdk/node_modules
RUN /bin/bash -c '. ~/.nvm/nvm.sh && cd /root/cdk && npm install --unsafe-perm=true'
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
#   Builder image, that uses base and planner output.
# -----------------------------------------------------------------------------
FROM web_dependencies as builder

ENV VERSION_NODE=14.17.1
ENV PATH="/root/.cargo/bin:/root/.nvm/versions/node/${VERSION_NODE}/bin:${PATH}"
WORKDIR /root

# Pre-cache npm dependencies
COPY --from=web_dependencies /root/.npm /root/.npm
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
#   Misc packages.
# -----------------------------------------------------------------------------
FROM builder as final

ENV VERSION_AWS_CLI=2.2.13
ENV PROTOC_VERSION=3.17.3
ENV DART_VERSION=2.13.3
ENV GOPATH=/root/.go

WORKDIR /root

# AWS CLI
RUN curl "https://awscli.amazonaws.com/ awscli-exe-linux-x86_64-$VERSION_AWS_CLI.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Protobuf
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-x86_64.zip
RUN unzip protoc-$PROTOC_VERSION-linux-x86_64.zip -d $HOME/.protobuf
RUN echo export PATH="$PATH:$HOME/.protobuf/bin" >> $HOME/.bashrc

# Dart
RUN curl -LO https://storage.googleapis.com/dart-archive/channels/stable/release/$DART_VERSION/sdk/dartsdk-linux-x64-release.zip
RUN unzip dartsdk-linux-x64-release.zip -d $HOME/.dart
RUN $HOME/.dart/dart-sdk/bin/pub global activate protoc_plugin
RUN echo export PATH="/usr/local/go/bin:\$PATH:$HOME/.dart/dart-sdk/bin:$HOME/.pub-cache/bin:\$GOPATH/bin" >> $HOME/.bashrc
RUN echo export GOPATH="\$HOME/.go" >> $HOME/.bashrc

# Protobuf Go plugin
RUN /usr/local/go/bin/go get -u github.com/golang/protobuf/proto
RUN /usr/local/go/bin/go get -u github.com/golang/protobuf/protoc-gen-go

# Delete visible files from root home
RUN rm -rf $HOME/*

SHELL ["/bin/bash", "-c"]
# -----------------------------------------------------------------------------