all: server.crt
	docker compose up --abort-on-container-exit

server.crt:
	openssl req -new -newkey rsa:2048 -sha1 -x509 -nodes \
		-set_serial 1 \
		-days 365 \
		-subj "/C=JP/ST=Osaka/L=Osaka City/CN=example.com" \
		-out server.crt \
		-keyout server.key


# targets using docker instead of docker-compose

run-nginx-quictls: build-nginx-quictls-image build-nginx-quic-network server.crt
	sudo docker run --rm --name nginx-quictls \
		--network=nginx-quic \
		-p 443:443/tcp -p 443:443/udp \
		-v ${PWD}/nginx-quictls/nginx.conf:/etc/nginx/nginx.conf:ro \
		-v ${PWD}/nginx-quictls/docroot:/var/www/html:ro \
		-v ${PWD}/server.crt:/etc/nginx/cert.crt:ro \
		-v ${PWD}/server.key:/etc/nginx/cert.key:ro \
		nginx-quictls

run-curl-quictls-http3: build-curl-quictls-image
	( \
	nginx_ip=$$(docker inspect --format '{{ $$network := index .NetworkSettings.Networks "nginx-quic" }}{{ $$network.IPAddress }}' nginx-quictls); \
	docker run --rm --network=nginx-quic curl-quictls -kv --http3 https://$${nginx_ip} \
	)

run-curl-quictls-http2: build-curl-quictls-image
	( \
	nginx_ip=$$(docker inspect --format '{{ $$network := index .NetworkSettings.Networks "nginx-quic" }}{{ $$network.IPAddress }}' nginx-quictls); \
	docker run --rm --network=nginx-quic curl-quictls -kv https://$${nginx_ip} \
	)

do-build-nginx-quictls-image:
	(cd nginx-quictls; docker build -t nginx-quictls .)

build-nginx-quictls-image:
	[ -n "$$(docker images -q nginx-quictls)" ] || \
	(cd nginx-quictls; docker build -t nginx-quictls .)

build-curl-quictls-image:
	[ -n "$$(docker images -q curl-quictls)" ] || \
	(cd curl-quictls; docker build -t curl-quictls .)

build-nginx-quic-network:
	[ -n "$$(docker network ls -q -f 'name=^nginx-quic$$')" ] || \
	docker network create --driver=bridge nginx-quic
