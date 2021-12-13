From ubuntu:16.04
MAINTAINER Praveen<pbeniwal2601@gmail.com>
ENV LITCOIN_VERSION=0.18.1
ARG USER_ID
ARG GROUP_ID
ENV HOME /litecoin
# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}
#Workdir /root
# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${GROUP_ID} litecoin \
        && useradd -u ${USER_ID} -g litecoin -s /bin/bash -m -d /litecoin litecoin

RUN apt-get update -y && apt-get install -y wget && \
    wget https://download.litecoin.org/litecoin-$LITCOIN_VERSION/linux/litecoin-$LITCOIN_VERSION-x86_64-linux-gnu.tar.gz && \
    wget https://download.litecoin.org/litecoin-$LITCOIN_VERSION/linux/litecoin-$LITCOIN_VERSION-x86_64-linux-gnu.tar.gz.asc && \
    wget https://download.litecoin.org/litecoin-$LITCOIN_VERSION/linux/litecoin-$LITCOIN_VERSION-linux-signatures.asc

RUN gpg --keyserver pgp.mit.edu --recv-key FE3348877809386C &&\
    gpg --verify  litecoin-$LITCOIN_VERSION-x86_64-linux-gnu.tar.gz.asc &&\
    grep $(sha256sum litecoin-$LITCOIN_VERSION-x86_64-linux-gnu.tar.gz | awk '{ print $1 }') litecoin-$LITCOIN_VERSION-linux-signatures.asc

RUN tar -zvxf litecoin-$LITCOIN_VERSION-x86_64-linux-gnu.tar.gz && \
    mv litecoin-$LITCOIN_VERSION/* /litecoin && \
    rm litecoin-$LITCOIN_VERSION-x86_64-linux-gnu.tar.gz && \
    rm -rf litecoin-$LITCOIN_VERSION && \
    cp /litecoin/bin/* /usr/local/bin

#gosu for easy step-down from root
RUN set -eux &&\
        apt-get update && \
        apt-get install -y gosu && \
        rm -rf /var/lib/apt/lists/* && \
# verify that the binary works
       gosu nobody true
#ADD ./bin /usr/local/bin
VOLUME ["/litecoin"]
#quick fix for peer.dat known issu
RUN rm -f /litecoin/.litecoin/peers.dat
EXPOSE 9332 
WORKDIR /litecoin
CMD ["litecoind", "--conf=/litecoin/litecoin.conf", "--printtoconsole"]
