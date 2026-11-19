# The official caddy Alpine image with the distribution's fixed packages applied at build time, and the caddy binary
# rebuilt with a current Go toolchain (same version and build tags as upstream), so net/http fixes land without waiting
# for an upstream release.
ARG CADDY_VERSION=2.11.9
ARG XCADDY_VERSION=v0.4.7

# cross-compiled on the build platform (no emulation); xcaddy honours GOOS/GOARCH
FROM --platform=$BUILDPLATFORM golang:1.27.4-alpine@sha256:0a5f7fe796599ff487605987432e7619ae45beeb2fba4c2ce0b907879932aebf AS build
ARG CADDY_VERSION XCADDY_VERSION TARGETOS TARGETARCH
RUN apk add --no-cache git \
 && go install github.com/caddyserver/xcaddy/cmd/xcaddy@$XCADDY_VERSION \
 && GOOS=$TARGETOS GOARCH=$TARGETARCH XCADDY_GO_BUILD_FLAGS="-trimpath -tags=nobadger,nomysql,nopgx -ldflags=-s" \
    xcaddy build v$CADDY_VERSION --output /caddy

FROM caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0
RUN apk upgrade --no-cache
COPY --from=build /caddy /usr/bin/caddy
