FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y build-essential git cmake libpcre3-dev zlib1g-dev

WORKDIR /src
RUN git clone -b openssl-3.0.8-quic1 --depth 1 \
        https://github.com/quictls/openssl \
        openssl-3.0.8-quic1
RUN git clone --depth 1 -b release-1.25.0 https://github.com/nginx/nginx
WORKDIR /src/nginx
RUN ./auto/configure --prefix=/usr \
                     --with-debug \
                     --with-http_v2_module \
                     --with-http_v3_module \
                     --with-openssl=../openssl-3.0.8-quic1
RUN make -j
RUN make install

RUN mkdir -p /etc/nginx /var/log/nginx
RUN ln -s /dev/stdout /var/log/nginx/access.log
RUN ln -s /dev/stderr /var/log/nginx/error.log

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
