SERVICE               ?= demo
GOBUILD               := go build -mod=vendor
GOINSTALL             := go install -mod=vendor
GOMOD                 := go mod
VCS_REF               := $(strip $(shell [ -d .git ] && git rev-parse HEAD))
VERSION               := $(strip $(shell [ -d .git ] && git describe --abbrev=0))
BUILD_DATE            := $(shell date -u +"%Y-%m-%dT%H:%M:%S%Z")
LDFLAGS               := '-s -w -X main.version=$(VERSION) -X main.commit=$(VCS_REF) -X main.date=$(BUILD_DATE)'
TAGS                  := netgo
GOFILES               := $(shell find . -name "*.go" -type f)

all: build

build: $(SERVICE)

$(SERVICE): $(GOFILES)
	$(GOBUILD) -v -ldflags $(LDFLAGS) -tags $(TAGS) -o demo .

.PHONY: vendor
vendor:
	$(GOMOD) tidy
	$(GOMOD) vendor -v

docker:
	docker build --progress=plain -t appleboy/docker-demo -f Dockerfile .

buildkit:
	docker build --progress=plain -t appleboy/docker-buildkit -f Dockerfile.buildkit .
