#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
docker network inspect lab13 >/dev/null 2>&1 || docker network create --subnet=172.28.0.0/24 lab13
docker compose -f "$ROOT/lab/docker-compose.yml" up -d
echo "Waiting for services (~30s)..."
sleep 30
docker exec suricata-lab suricata-update 2>/dev/null || true
docker exec suricata-lab suricatasc -c reload-rules 2>/dev/null || true
echo "Target (Metasploitable): 172.28.0.10"
echo "SSH for Fail2Ban demo:     127.0.0.1:2222 (labuser / CorrectHorse)"
echo "Attacker (host gateway):   172.28.0.1"
