# gosec-docker

[![Build Status](https://drone.cryptic.systems/api/badges/volker.raschek/gosec-docker/status.svg)](https://drone.cryptic.systems/volker.raschek/gosec-docker)
[![Docker Pulls](https://img.shields.io/docker/pulls/volkerraschek/gosec)](https://hub.docker.com/r/volkerraschek/gosec)

This project contains all sources to build the container image
`docker.io/volkerraschek/gosec`. The primary goal of this project is to package
the binary `gosec` as container image to provide the functionally for CI/CD
workflows. The source code of the binary can be found in the upstream project of
[gosec](github.com/securego/gosec).

## drone

Here is an example how to use `docker.io/volkerraschek/gosec` to scan for
vulerabilities.

```yaml
kind: pipeline
type: kubernetes
name: vulnerability-scan

platform:
  os: linux
  arch: amd64

steps:
- name: gosec
  commands:
  - gosec -v ./...
  image: docker.io/volkerraschek/gosec:latest
  resources:
    limits:
      cpu: 250
      memory: 500M
```
