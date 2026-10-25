#!/usr/bin/env bash
# Задание 1 — nmap разведка (sudo, как в методичке)
set -euo pipefail
TARGET="${1:-172.28.0.10}"
SCANS="$(cd "$(dirname "$0")/../scans" && pwd)"
mkdir -p "$SCANS"

echo "Target: $TARGET"
sudo nmap -sA -F -oN "$SCANS/task1-sA.txt" "$TARGET"
sudo nmap -sT -F -oN "$SCANS/task1-sT.txt" "$TARGET"
sudo nmap -sS -F -oN "$SCANS/task1-sS.txt" "$TARGET"
sudo nmap -sV -F -oN "$SCANS/task1-sV.txt" "$TARGET"
echo "Scans: $SCANS/task1-*.txt"
