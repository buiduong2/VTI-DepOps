
#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"
cd "$ROOT_DIR"

log "Deploying PostgreSQL"

helm upgrade --install postgres ./charts/postgresql \
  --namespace "$NAMESPACE" \
  -f values/postgres.yaml \
  --wait \
  --timeout 5m

log "PostgreSQL ready"
