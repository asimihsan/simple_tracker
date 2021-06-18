# -----------------------------------------------------------------------------
#   Base image.
# -----------------------------------------------------------------------------
FROM amazonlinux:2018.03.0.20210521.1 as base

ENV VERSION_AWS_CLI=2.2.13
ENV VERSION_CDK=1.109.0
ENV VERSION_DART=2.13.3
ENV VERSION_GO=1.16.5
ENV VERSION_NODE=14.17.1
ENV VERSION_NVM=0.38.0
ENV VERSION_PROTOC=3.17.3
ENV VERSION_RUST=1.53.0

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

# AWS CLI
WORKDIR /root
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-$VERSION_AWS_CLI.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm -f awscliv2.zip
RUN rm -rf aws
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
#   Protobuf
# ----------------------------------------------------------------------------
FROM base as protobuf

RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v$VERSION_PROTOC/protoc-$VERSION_PROTOC-linux-x86_64.zip
RUN unzip protoc-$VERSION_PROTOC-linux-x86_64.zip -d $HOME/.protobuf
# ----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
#   Go base
# -----------------------------------------------------------------------------
FROM base as go_base

# Install Go
RUN wget -O go.tgz https://dl.google.com/go/go$VERSION_GO.src.tar.gz
RUN tar -C /usr/local -xzf go.tgz
RUN cd /usr/local/go/src/ && ./make.bash
RUN rm -f go.tgz
RUN mkdir $HOME/.go

# Protobuf Go plugin
RUN bash -c 'GOPATH="/root/.go" /usr/local/go/bin/go get -u github.com/golang/protobuf/proto'
RUN bash -c 'GOPATH="/root/.go" /usr/local/go/bin/go get -u github.com/golang/protobuf/protoc-gen-go'
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
#   Dart
# -----------------------------------------------------------------------------
FROM base as dart_dependencies

RUN curl -LO https://storage.googleapis.com/dart-archive/channels/stable/release/$VERSION_DART/sdk/dartsdk-linux-x64-release.zip
RUN unzip dartsdk-linux-x64-release.zip -d $HOME/.dart
RUN $HOME/.dart/dart-sdk/bin/pub global activate protoc_plugin
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
#   Rust
# -----------------------------------------------------------------------------
FROM base as rust_dependencies

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup install ${VERSION_RUST}
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
#   Copy over CDK directory to pre-install dependencies.
# -----------------------------------------------------------------------------
FROM base as npm_dependencies

# Install Node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v${VERSION_NVM}/install.sh | bash
RUN /bin/bash -c ". ~/.nvm/nvm.sh && \
    nvm install $VERSION_NODE && nvm use $VERSION_NODE && \
    nvm alias default node && nvm cache clear"

# Install Node dependencies
RUN /bin/bash -c ". ~/.nvm/nvm.sh && npm install cdk@$VERSION_CDK -g --unsafe-perm=true"

COPY cdk /root/cdk
RUN rm -rf /root/cdk/node_modules
RUN /bin/bash -c '. ~/.nvm/nvm.sh && cd /root/cdk && npm install --unsafe-perm=true'
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
#   Go dependencies
# -----------------------------------------------------------------------------
FROM go_base as go_dependencies 

ENV PATH="/usr/local/go/bin:\$PATH"
ENV GOPATH="/root/.go"

WORKDIR /root

# Cache Go dependencies
COPY lambda/go.mod .
COPY lambda/go.sum .
RUN /usr/local/go/bin/go mod download

COPY ephemeral-key-lambda/go.mod .
COPY ephemeral-key-lambda/go.sum .
RUN /usr/local/go/bin/go mod download
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
#   Final
# -----------------------------------------------------------------------------
FROM base as final

COPY --from=dart_dependencies /root/.dart /root/.dart
COPY --from=dart_dependencies /root/.pub-cache /root/.pub-cache
COPY --from=go_base /usr/local/go /usr/local/go
COPY --from=go_dependencies /root/.go /root/.go
COPY --from=npm_dependencies /root/.npm /root/.npm
COPY --from=npm_dependencies /root/.nvm /root/.nvm
COPY --from=protobuf /root/.protobuf /root/.protobuf
COPY --from=rust_dependencies /root/.cargo /root/.cargo
COPY --from=rust_dependencies /root/.rustup /root/.rustup

RUN echo ". \"\$HOME/.cargo/env\"" >> $HOME/.bashrc
RUN echo ". \"\$HOME/.nvm/nvm.sh\"" >> $HOME/.bashrc
RUN echo export GOPATH="\$HOME/.go" >> $HOME/.bashrc
RUN echo export PATH="/usr/local/go/bin:\$PATH:$HOME/.dart/dart-sdk/bin:$HOME/.pub-cache/bin:\$GOPATH/bin" >> $HOME/.bashrc
RUN echo export PATH="\$PATH:\$HOME/.protobuf/bin" >> $HOME/.bashrc

# Delete visible files from root home
RUN rm -rf $HOME/*

SHELL ["/bin/bash", "-c"]
# -----------------------------------------------------------------------------