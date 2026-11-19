# The official postgres Alpine image with the distribution's fixed packages applied at build time, and gosu (used by the
# entrypoint to drop root) rebuilt with a current Go toolchain: upstream ships gosu 1.19 built with Go 1.24.6.
ARG GOSU_VERSION=1.20

# cross-compiled on the build platform (no emulation)
FROM --platform=$BUILDPLATFORM golang:1.27.4-alpine@sha256:70bd7ddea8b6cbe5d6943cde279d6b67feb10cc924fb9100d1d8757c1575b280 AS gosu
ARG GOSU_VERSION TARGETOS TARGETARCH
WORKDIR /src
RUN go mod init build && go get github.com/tianon/gosu@$GOSU_VERSION \
 && CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -trimpath -ldflags=-s -o /out/gosu github.com/tianon/gosu

FROM postgres:18.6-alpine@sha256:9ba53c7d41ea093baf5c1ba635ba5434c4f979880527d49bb7d9237d3193085b
RUN apk upgrade --no-cache
COPY --from=gosu /out/gosu /usr/local/bin/gosu
