#!/usr/bin/env bash
# deploy.sh — Pull latest, rebuild container, restart service.
# Idempotent: safe to run multiple times.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="$REPO_DIR/docker/compose.yml"

echo "==> [deploy] Repo: $REPO_DIR"

echo "==> [deploy] Pulling latest from origin/main..."
cd "$REPO_DIR"
git pull origin main

echo "==> [deploy] Building container image..."
docker compose -f "$COMPOSE_FILE" build

echo "==> [deploy] Restarting service..."
docker compose -f "$COMPOSE_FILE" up -d

echo "==> [deploy] Done. Current containers:"
docker compose -f "$COMPOSE_FILE" ps
