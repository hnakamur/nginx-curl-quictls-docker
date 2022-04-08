FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y build-essential mercurial git cmake libpcre3-dev zlib1g-dev libssl-dev

WORKDIR /src
RUN git clone https://github.com/google/boringssl
RUN hg clone -b quic https://hg.nginx.org/nginx-quic
WORKDIR /src/nginx-quic
RUN ./auto/configure --with-debug --with-http_v3_module         \
                     --with-cc-opt="-I../boringssl/include"     \
                     --with-ld-opt="-L../boringssl/build/ssl    \
                                    -L../boringssl/build/crypto"
RUN make
