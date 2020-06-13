
all: build

build:
	go build -v -a -o demo .

docker:
	docker build --progress=plain -t appleboy/docker-demo -f Dockerfile .

buildkit:
	docker build --progress=plain -t appleboy/docker-buildkit -f Dockerfile.buildkit .
