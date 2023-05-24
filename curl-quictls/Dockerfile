FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y build-essential git autoconf libtool pkg-config \
                       zlib1g-dev libzstd-dev libbrotli-dev libidn2-dev libnghttp2-dev

# Build quictls
WORKDIR /src
RUN git clone -b openssl-3.0.8-quic1 --depth 1 \
        https://github.com/quictls/openssl \
        openssl-3.0.8-quic1
WORKDIR /src/openssl-3.0.8-quic1
RUN ./config enable-tls1_3 \
    --prefix=/usr --openssldir=/usr/lib/ssl --libdir=lib/$(uname -m)-linux-gnu \
    no-idea no-mdc2 no-rc5 no-zlib no-ssl3 enable-unit-test no-ssl3-method enable-rfc3779 enable-cms
RUN make -j
RUN make install

# Build nghttp3
WORKDIR /src
RUN git clone --depth 1 -b v0.11.0 https://github.com/ngtcp2/nghttp3
WORKDIR /src/nghttp3
RUN autoreconf -fi
RUN ./configure --prefix=/usr --libdir=/usr/lib/$(uname -m)-linux-gnu --enable-lib-only
RUN make -j
RUN make install

# Build ngtcp2
WORKDIR /src
RUN git clone --depth 1 -b v0.15.0 https://github.com/ngtcp2/ngtcp2
WORKDIR /src/ngtcp2
RUN autoreconf -fi
RUN ./configure --prefix=/usr --libdir=/usr/lib/$(uname -m)-linux-gnu --enable-lib-only
RUN make -j
RUN make install

# Build curl
WORKDIR /src
RUN git clone --depth 1 https://github.com/curl/curl
WORKDIR /src/curl
RUN autoreconf -fi
RUN LDFLAGS="-Wl,-rpath,/usr/lib/$(uname -m)-linux-gnu" PKG_CONFIG_PATH=/usr/lib/$(uname -m)-linux-gnu/pkgconfig ./configure --prefix=/usr --libdir=/usr/lib/$(uname -m)-linux-gnu --with-openssl=/usr --with-nghttp3=/usr --with-ngtcp2=/usr
RUN make -j
RUN make install

ENTRYPOINT ["/usr/bin/curl"]
