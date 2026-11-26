# The official postgres Alpine image with the distribution's fixed packages applied at build time, and gosu (used by the
# entrypoint to drop root) rebuilt with a current Go toolchain: upstream ships gosu 1.19 built with Go 1.24.6.
ARG GOSU_VERSION=1.20

# cross-compiled on the build platform (no emulation)
FROM --platform=$BUILDPLATFORM golang:1.27.4-alpine@sha256:0a5f7fe796599ff487605987432e7619ae45beeb2fba4c2ce0b907879932aebf AS gosu
ARG GOSU_VERSION TARGETOS TARGETARCH
WORKDIR /src
RUN go mod init build && go get github.com/tianon/gosu@$GOSU_VERSION \
 && CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -trimpath -ldflags=-s -o /out/gosu github.com/tianon/gosu

FROM postgres:18.7-alpine@sha256:0115267ab5a509022df9319c77be365cef335adb71556c75f60f5360ee247e71
RUN apk upgrade --no-cache
COPY --from=gosu /out/gosu /usr/local/bin/gosu
