#!/usr/bin/env python3
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "screenshots"
SCANS = ROOT / "scans"
LOGS = ROOT / "logs"


def font(size=13):
    for n in ("DejaVuSansMono.ttf", "LiberationMono-Regular.ttf"):
        try:
            return ImageFont.truetype(n, size)
        except OSError:
            pass
    return ImageFont.loaddefault()


def render(path, title, lines):
    f = font()
    lh = 17
    pad = 14
    w = min(max((f.getlength(l) for l in lines), default=400) + pad * 2, 1200)
    h = pad * 2 + lh * (len(lines) + 1)
    img = Image.new("RGB", (int(w), int(h)), (28, 28, 28))
    d = ImageDraw.Draw(img)
    d.text((pad, pad), title, fill=(120, 180, 255), font=f)
    y = pad + lh
    for line in lines:
        d.text((pad, y), line[:130], fill=(220, 220, 220), font=f)
        y += lh
    path.parent.mkdir(exist_ok=True)
    img.save(path)


def scan_lines(name, limit=20):
    p = SCANS / name
    out = []
    for ln in p.read_text().splitlines():
        if ln.startswith("#") or not ln.strip():
            continue
        out.append(ln)
        if len(out) >= limit:
            break
    return out or [f"(нет {name})"]


def log_lines(rel, limit=12):
    p = LOGS / rel
    if not p.exists():
        return [f"(нет {rel})"]
    lines = [ln.strip() for ln in p.read_text().splitlines() if ln.strip()]
    return lines[:limit] or ["(пусто)"]


def main():
    render(OUT / "task1-nmap-sS.png", "sudo nmap -sS -F 172.28.0.10", scan_lines("task1-sS.txt"))
    render(
        OUT / "task1-suricata.png",
        "/var/log/suricata/fast.log",
        log_lines("suricata/task1-alerts-fast.log", 10),
    )
    render(OUT / "task2-hydra.png", "hydra + sshpass → 172.28.0.10:22", log_lines("hydra-task2.log", 14))
    render(
        OUT / "task2-fail2ban.png",
        "fail2ban-client status sshd",
        log_lines("fail2ban/task2-status.txt", 12) + log_lines("fail2ban/task2-fail2ban.log", 6),
    )


if __name__ == "__main__":
    main()
