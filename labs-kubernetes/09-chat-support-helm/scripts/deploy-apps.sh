
#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"
cd "$ROOT_DIR"

for app in auth chat chat-ui; do
  log "Deploying $app"

  helm upgrade --install "$app" ./charts/web-app \
    --namespace "$NAMESPACE" \
    -f "values/${app}.yaml" \
    --wait \
    --timeout 5m
done

log "Application releases deployed"
