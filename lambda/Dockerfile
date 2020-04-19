FROM amazonlinux:2018.03

RUN yum -y update && \
    # Install various packages to get compile environment
    yum -y groupinstall 'Development Tools' && \
    # Need a pre-existing version of Golang to build from source
    yum -y install golang && \
    yum -y install wget && \
    yum clean all

RUN wget -O go.tgz https://dl.google.com/go/go1.14.2.src.tar.gz
RUN tar -C /usr/local -xzf go.tgz
RUN cd /usr/local/go/src/ && ./make.bash
RUN rm -f go.tgz

# This is a hack to cache some go dependencies so that we don't need to re-download them on every build
# Not sure if this helps...
RUN /usr/local/go/bin/go get github.com/aws/aws-lambda-go/...
RUN /usr/local/go/bin/go get github.com/aws/aws-sdk-go
RUN /usr/local/go/bin/go get github.com/aws/aws-sdk-go/aws
RUN /usr/local/go/bin/go get github.com/aws/aws-sdk-go/service/dynamodb
RUN /usr/local/go/bin/go get github.com/aws/aws-sdk-go/service/kms
RUN /usr/local/go/bin/go get github.com/aws/aws-xray-sdk-go/...
RUN /usr/local/go/bin/go get github.com/golang/protobuf/proto
RUN /usr/local/go/bin/go get github.com/google/uuid
RUN /usr/local/go/bin/go get github.com/jmespath/go-jmespath/...
RUN /usr/local/go/bin/go get github.com/oklog/ulid
RUN /usr/local/go/bin/go get github.com/patrickmn/go-cache
RUN /usr/local/go/bin/go get github.com/pkg/errors
RUN /usr/local/go/bin/go get github.com/valyala/gozstd
