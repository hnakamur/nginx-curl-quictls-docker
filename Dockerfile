FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y build-essential mercurial git cmake libpcre3-dev zlib1g-dev

WORKDIR /src
RUN git clone -b OpenSSL_1_1_1n+quic --depth 1 \
        https://github.com/quictls/openssl \
        quictls-1.1.1n
RUN hg clone -b quic https://hg.nginx.org/nginx-quic
WORKDIR /src/nginx-quic
RUN ./auto/configure --prefix=/usr \
                     --with-debug \
                     --build=commit-$(hg id -i) \
                     --with-http_v2_module \
                     --with-http_v3_module \
                     --with-stream_quic_module \
                     --with-openssl=../quictls-1.1.1n
RUN make
RUN make install

RUN mkdir -p /etc/nginx /var/log/nginx
RUN ln -s /dev/stdout /var/log/nginx/access.log
RUN ln -s /dev/stderr /var/log/nginx/error.log

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
