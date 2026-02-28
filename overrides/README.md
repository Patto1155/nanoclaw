# NanoClaw Customization Layer

This directory is the **customization overlay** for this fork of NanoClaw.

## Principles

- Files here **override** upstream equivalents without modifying upstream files directly.
- Upstream changes are pulled via `scripts/upgrade-upstream.sh` and merged carefully.
- All custom work lives in `custom/*` branches; `main` tracks a clean, merge-ready state.

## Layout

```
overrides/
  config/       # Local config overrides (not committed if secret)
  patches/      # One-off patch files applied on top of upstream
  README.md     # This file
docker/
  compose.yml   # Production docker-compose for this host
scripts/
  deploy.sh           # Pull + build + restart
  upgrade-upstream.sh # Fetch upstream, create merge branch
  status.sh           # Health snapshot
```

## Branch Strategy

| Branch              | Purpose                                      |
|---------------------|----------------------------------------------|
| `main`              | Stable, deployable                           |
| `custom/*`          | Active customization branches                |
| `upstream-sync/*`   | Temporary branches for upstream merges       |

## Updating from Upstream

```bash
./scripts/upgrade-upstream.sh
```

This fetches `upstream/main`, creates an `upstream-sync/YYYY-MM-DD` branch, and attempts a merge. Conflicts must be resolved manually before merging to `main`.
