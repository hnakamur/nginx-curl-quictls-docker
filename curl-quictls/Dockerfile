FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y build-essential git autoconf libtool pkg-config \
                       zlib1g-dev libzstd-dev libbrotli-dev libidn2-dev libnghttp2-dev

# Build quictls
WORKDIR /src
RUN git clone -b OpenSSL_1_1_1n+quic --depth 1 \
        https://github.com/quictls/openssl \
        quictls-1.1.1n
WORKDIR /src/quictls-1.1.1n
RUN ./config enable-tls1_3 \
    --prefix=/usr --openssldir=/usr/lib/ssl --libdir=lib/$(uname -m)-linux-gnu \
    no-idea no-mdc2 no-rc5 no-zlib no-ssl3 enable-unit-test no-ssl3-method enable-rfc3779 enable-cms
RUN make
RUN make install

# Build nghttp3
WORKDIR /src
RUN git clone --depth 1 https://github.com/ngtcp2/nghttp3
WORKDIR /src/nghttp3
RUN autoreconf -fi
RUN ./configure --prefix=/usr --libdir=/usr/lib/$(uname -m)-linux-gnu --enable-lib-only
RUN make
RUN make install

# Build ngtcp2
WORKDIR /src
RUN git clone --depth 1 https://github.com/ngtcp2/ngtcp2
WORKDIR /src/ngtcp2
RUN autoreconf -fi
RUN ./configure --prefix=/usr --libdir=/usr/lib/$(uname -m)-linux-gnu --enable-lib-only
RUN make
RUN make install

# Build curl
WORKDIR /src
RUN git clone --depth 1 https://github.com/curl/curl
WORKDIR /src/curl
RUN autoreconf -fi
RUN ./configure --prefix=/usr --with-openssl=/usr
RUN make
RUN make install

ENTRYPOINT ["/usr/bin/curl"]
