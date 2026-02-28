#!/usr/bin/env bash
# status.sh — Health snapshot for NanoClaw on this host.
# Idempotent: read-only, safe to run any time.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="$REPO_DIR/docker/compose.yml"
LOG_DIR="/mnt/hdd/logs/agents/nanoclaw"

echo "════════════════════════════════════════"
echo " NanoClaw Status — $(date)"
echo "════════════════════════════════════════"

echo ""
echo "── Disk (SSD) ──────────────────────────"
df -h /

echo ""
echo "── Disk (HDD) ──────────────────────────"
df -h /mnt/hdd

echo ""
echo "── Docker containers ───────────────────"
docker compose -f "$COMPOSE_FILE" ps 2>/dev/null || echo "(compose not reachable)"

echo ""
echo "── Systemd service ─────────────────────"
systemctl status nanoclaw.service --no-pager -l 2>/dev/null || true

echo ""
echo "── Last 20 log lines ───────────────────"
if [ -d "$LOG_DIR" ] && [ -n "$(ls -A "$LOG_DIR" 2>/dev/null)" ]; then
  tail -n 20 "$LOG_DIR"/*.log 2>/dev/null || echo "(no .log files yet)"
else
  echo "(log dir empty or not found: $LOG_DIR)"
  echo "Docker logs fallback:"
  docker compose -f "$COMPOSE_FILE" logs --tail=20 2>/dev/null || echo "(container not running)"
fi

echo ""
echo "════════════════════════════════════════"
