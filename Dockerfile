FROM docker.io/library/golang:1.23.6-alpine AS build

ARG GOSEC_VERSION

RUN apk update && \
    apk upgrade && \
    apk add git make

RUN if [ ! -z "${GOSEC_VERSION}" ]; then set -ex; go install github.com/securego/gosec/v2/cmd/gosec@${GOSEC_VERSION}; fi
RUN if [ -z "${GOSEC_VERSION}" ]; then set -ex; go install github.com/securego/gosec/v2/cmd/gosec@latest; fi

RUN cp /go/bin/gosec /usr/bin/gosec && \
    rm -rf /go/*

ENTRYPOINT [ "/usr/bin/gosec" ]