nginx-curl-quictls-build-docker
===============================

A Dockerfile for nginx-quictls and curl-quictls using
https://github.com/quictls/openssl

## How to build and run nginx-quictls and curl-quictls using docker-compose

```
make
```

## How to build and run nginx-quictls and curl-quictls using docker

Build and nginx-quictls in a Docker container.

```
make run-nginx-quictls
```

In another terminal, build and run curl-quictls and send request to the nginx-quictls above.

```
make run-curl-quictls-http3
```
