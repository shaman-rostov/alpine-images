#!/usr/bin/env bash
# Starts the image with its default entrypoint and checks that it serves.
# Usage: test.sh <postgres|caddy> <image>
set -euo pipefail
KIND=${1:?kind}; IMAGE=${2:?image}
name=$KIND-test-$$
trap 'docker rm -f "$name" >/dev/null 2>&1 || true' EXIT
wait_for() { for _ in $(seq 30); do "$@" >/dev/null 2>&1 && return 0; sleep 1; done; "$@"; }

case $KIND in
  postgres)
    docker run -d --name "$name" -e POSTGRES_PASSWORD=test "$IMAGE" >/dev/null
    wait_for docker exec "$name" pg_isready -U postgres
    wait_for docker exec "$name" psql -U postgres -tAc "select 1"
    echo "PASS $(docker exec "$name" postgres --version)" ;;
  caddy)
    docker run -d --name "$name" -p 127.0.0.1::80 "$IMAGE" >/dev/null
    port=$(docker port "$name" 80/tcp | head -1 | sed 's/.*://')
    wait_for curl -fsS -o /dev/null "http://127.0.0.1:$port/"
    echo "PASS $(docker exec "$name" caddy version | cut -d' ' -f1)" ;;
  *) echo "unknown kind $KIND"; exit 2 ;;
esac
