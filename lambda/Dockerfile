FROM amazonlinux:2018.03

RUN yum -y update && \
    # Install various packages to get compile environment
    yum -y groupinstall 'Development Tools' && \
    # Need a pre-existing version of Golang to build from source
    yum -y install golang && \
    yum -y install wget && \
    yum clean all

RUN wget -O go.tgz https://dl.google.com/go/go1.14.4.src.tar.gz
RUN tar -C /usr/local -xzf go.tgz
RUN cd /usr/local/go/src/ && ./make.bash
RUN rm -f go.tgz

COPY go.mod /root/go.mod
COPY go.sum /root/go.sum
RUN cd /root && /usr/local/go/bin/go mod download --json
RUN rm -f /root/go.mod
RUN rm -f /root/go.sum