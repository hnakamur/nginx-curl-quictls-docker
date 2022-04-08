FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y build-essential git autoconf pkg-config \
                      zlib1g-dev libzstd-dev libbrotli-dev libidn2-dev

# Build quictls
WORKDIR /src
RUN git clone -b OpenSSL_1_1_1n+quic --depth 1 \
        https://github.com/quictls/openssl \
        quictls-1.1.1n
WORKDIR /src/quictls-1.1.1n
RUN ./config enable-tls1_3 --prefix=/usr
RUN make
RUN make install

# Build nghttp3
WORKDIR /src
RUN git clone --depth 1 https://github.com/ngtcp2/nghttp3
WORKDIR /src/nghttp3

RUN apt-get install -y libtool

RUN autoreconf -fi
RUN ./configure --prefix=/usr --enable-lib-only
RUN make
RUN make install

# Build ngtcp2
WORKDIR /src
RUN git clone --depth 1 https://github.com/ngtcp2/ngtcp2
WORKDIR /src/ngtcp2
RUN autoreconf -fi
RUN ./configure LDFLAGS="-Wl,-rpath,/usr/lib" PKG_CONFIG_PATH=/usr/lib64/pkgconfig \
                --prefix=/usr --enable-lib-only
RUN make
RUN make install

# Build curl
WORKDIR /src
RUN git clone --depth 1 https://github.com/curl/curl
WORKDIR /src/curl
RUN autoreconf -fi

RUN apt-get install -y libnghttp2-dev

RUN LDFLAGS="-Wl,-rpath,/usr/lib" ./configure --prefix=/usr --with-openssl=/usr
RUN make
RUN make install

RUN echo '/usr/lib64' > /etc/ld.so.conf.d/usr-lib64.conf
RUN ldconfig

ENTRYPOINT ["/usr/bin/curl"]
