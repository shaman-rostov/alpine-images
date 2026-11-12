# alpine-images

Official Alpine images with `apk upgrade` applied, pinned by digest and rebuilt weekly. Upstream rebuilds lag behind
Alpine security updates (e.g. zlib 1.4, libxslt 1.1.43-r4), so these are drop-in replacements for the services on the
oracle host: same configuration, paths, user, entrypoint and volumes.

| Image | Base | Tags |
|---|---|---|
| `ghcr.io/shaman-rostov/postgres-alpine` | `postgres:<version>-alpine` (`postgres/18`, `postgres/16`) | `18`, `18.6`, `16`, `16.15`, `<version>-<commit>` |
| `ghcr.io/shaman-rostov/caddy-alpine` | `caddy:<version>-alpine` | `2`, `2.11.9`, `<version>-<commit>` |

Dependabot bumps the pinned base digests and minor versions; a major version is a deliberate change. CI starts each
image (postgres answers a query, caddy serves its default page) before publishing.

Switching a service: replace `postgres:18-alpine` with `ghcr.io/shaman-rostov/postgres-alpine:18` (or `caddy:2-alpine`
with `ghcr.io/shaman-rostov/caddy-alpine:2`). Postgres minor updates keep the data directory format; the container
restarts once.
