#!/usr/bin/env bash
# upgrade-upstream.sh — Fetch upstream NanoClaw changes and create a merge branch.
# Stops on conflict — never auto-merges to main.
# Idempotent: branch name includes date, so re-running on the same day is a no-op.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BRANCH="upstream-sync/$(date +%Y-%m-%d)"

cd "$REPO_DIR"

echo "==> [upgrade-upstream] Fetching upstream..."
git fetch upstream

echo "==> [upgrade-upstream] Current branch: $(git branch --show-current)"

# Create or reuse the sync branch from current main
if git show-ref --quiet "refs/heads/$BRANCH"; then
  echo "==> [upgrade-upstream] Branch '$BRANCH' already exists, checking it out..."
  git checkout "$BRANCH"
else
  echo "==> [upgrade-upstream] Creating branch '$BRANCH' from main..."
  git checkout main
  git checkout -b "$BRANCH"
fi

echo "==> [upgrade-upstream] Attempting merge with upstream/main..."
if git merge upstream/main --no-edit; then
  echo ""
  echo "✅ Merge succeeded on branch: $BRANCH"
  echo "   Review changes, then merge to main:"
  echo "     git checkout main && git merge $BRANCH && git push origin main"
else
  echo ""
  echo "⚠️  Merge conflict detected. Stopping."
  echo "   Resolve conflicts in: $REPO_DIR"
  echo "   Then run:"
  echo "     git add . && git commit"
  echo "     git checkout main && git merge $BRANCH && git push origin main"
  exit 1
fi
