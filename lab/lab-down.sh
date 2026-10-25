#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
docker compose -f "$ROOT/lab/docker-compose.yml" down
docker rm -f fail2ban-lab 2>/dev/null || true
