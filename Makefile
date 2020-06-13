SERVICE               ?= demo
GOBUILD               := go build
GOINSTALL             := go install
GOMOD                 := go mod
BUILD_DATE            := $(shell date -u +"%Y-%m-%dT%H:%M:%S%Z")
LDFLAGS               := '-s -w -X main.date=$(BUILD_DATE)'
TAGS                  := netgo
GOFILES               := $(shell find . -name "*.go" -type f)

all: build

build:
	$(GOBUILD) -v -ldflags $(LDFLAGS) -tags $(TAGS) -o $(SERVICE) .

docker:
	docker build --progress=plain -t appleboy/docker-demo -f Dockerfile .

buildkit:
	docker build --progress=plain -t appleboy/docker-buildkit -f Dockerfile.buildkit .
