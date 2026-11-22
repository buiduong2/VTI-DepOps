
#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"
cd "$ROOT_DIR"

log "Applying PostgreSQL ConfigMap"

kubectl -n "$NAMESPACE" create configmap postgres-init-scripts \
  --from-file=database/init/ \
  --dry-run=client -o yaml |
  kubectl -n "$NAMESPACE" apply -f -

log "Applying PostgreSQL Secret"

kubectl -n "$NAMESPACE" create secret generic postgres-secret \
  --from-env-file=envs/db.env \
  --dry-run=client -o yaml |
  kubectl -n "$NAMESPACE" apply -f -

log "Applying application Secrets"

for app in auth chat chat-ui; do
  kubectl -n "$NAMESPACE" create secret generic "${app}-secret" \
    --from-env-file="envs/${app}.env" \
    --dry-run=client -o yaml |
    kubectl -n "$NAMESPACE" apply -f -
done

log "Applying TLS Secret"

kubectl -n "$NAMESPACE" create secret tls chat-support-tls \
  --cert=certs/chat-support.pem \
  --key=certs/chat-support-key.pem \
  --dry-run=client -o yaml |
  kubectl -n "$NAMESPACE" apply -f -

log "Secrets and ConfigMap applied"
