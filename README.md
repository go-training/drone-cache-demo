# drone-cache-demo

How to cache the third party file in [Golang](https://golang.org)? [Go 1.15](https://tip.golang.org/doc/go1.15) version the `GOMODCACHE` environment variable. The default value of `GOMODCACHE` is `GOPATH[0]/pkg/mod`, the location of the module cache before this change. How to cache the `GOMODCACHE` path using [Drone](https://cloud.drone.io/) with [meltwater/drone-cache](https://github.com/meltwater/drone-cache) plugin.

## Change default value of GOMODCACHE

Create new [Temporary Volumes](https://docs.drone.io/pipeline/docker/syntax/volumes/temporary/) in Drone.

```yaml
volumes:
- name: cache
  temp: {}
```

Add build step in Go.

```yaml
- name: build
  pull: always
  image: golang:1.15-rc
  commands:
  - make build
  environment:
    CGO_ENABLED: 0
    GOMODCACHE: '/drone/src/pkg.mod'
    GOCACHE: '/drone/src/pkg.build'
  when:
    event:
      exclude:
      - tag
  volumes:
  - name: cache
    path: /go
```

## Setup the build cache

Restore the build cache:

```yaml
- name: restore-cache
  image: meltwater/drone-cache
  environment:
    AWS_ACCESS_KEY_ID:
      from_secret: aws_access_key_id
    AWS_SECRET_ACCESS_KEY:
      from_secret: aws_secret_access_key
  pull: always
  settings:
    debug: true
    restore: true
    cache_key: '{{ .Repo.Name }}_{{ checksum "go.mod" }}_{{ checksum "go.sum" }}_{{ arch }}_{{ os }}'
    bucket: drone-cache-demo
    region: ap-northeast-1
    local_root: /
    archive_format: gzip
    mount:
      - pkg.mod
      - pkg.build
  volumes:
  - name: cache
    path: /go
```

Rebuild cache:

```yaml
- name: rebuild-cache
  image: meltwater/drone-cache
  pull: always
  environment:
    AWS_ACCESS_KEY_ID:
      from_secret: aws_access_key_id
    AWS_SECRET_ACCESS_KEY:
      from_secret: aws_secret_access_key
  settings:
    rebuild: true
    cache_key: '{{ .Repo.Name }}_{{ checksum "go.mod" }}_{{ checksum "go.sum" }}_{{ arch }}_{{ os }}'
    bucket: drone-cache-demo
    region: ap-northeast-1
    archive_format: gzip
    mount:
      - pkg.mod
      - pkg.build
  volumes:
  - name: cache
    path: /go
```
