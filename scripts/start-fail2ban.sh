#!/usr/bin/env bash
# Fail2Ban (Docker) — jail sshd, logpath /var/log/auth.log на хосте
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
docker rm -f fail2ban-lab 2>/dev/null || true
docker run -d --name fail2ban-lab --net=host \
  -v /var/log:/var/log:ro \
  -v "$ROOT/config/fail2ban-data:/data" \
  crazymax/fail2ban:latest
sleep 5
docker exec fail2ban-lab fail2ban-client status sshd
