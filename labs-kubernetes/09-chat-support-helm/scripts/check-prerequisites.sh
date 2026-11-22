
#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

log "Checking prerequisites"

for cmd in kubectl helm docker openssl; do
  require_command "$cmd"
done

docker compose version >/dev/null ||
  fail "Docker Compose plugin is required"

CURRENT_CONTEXT="$(kubectl config current-context)"

[[ "$CURRENT_CONTEXT" == "$EXPECTED_CONTEXT" ]] ||
  fail "Expected $EXPECTED_CONTEXT, got $CURRENT_CONTEXT"

kubectl cluster-info >/dev/null
kubectl get namespace "$NAMESPACE" >/dev/null

for app in db auth chat chat-ui common; do
  require_file "envs/${app}.env"
done

require_file "certs/chat-support.pem"
require_file "certs/chat-support-key.pem"
require_file "proxy/docker-compose.yaml"
require_file "proxy/nginx.conf"
require_file "values/postgres.yaml"

for app in auth chat chat-ui; do
  require_file "values/${app}.yaml"
done

openssl x509 -in "$ROOT_DIR/certs/chat-support.pem" \
  -noout >/dev/null ||
  fail "Invalid TLS certificate"

openssl pkey -in "$ROOT_DIR/certs/chat-support-key.pem" \
  -noout >/dev/null 2>&1 ||
  fail "Invalid TLS private key"

log "Prerequisites OK"
