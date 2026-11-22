
#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"
cd "$ROOT_DIR"

NETWORK_NAME="chat-ingress-net"
NETWORK_ALIAS="chat-ingress"
INGRESS_NAME="chat"

log "Finding Kind Ingress address"

INGRESS_IPS=$(kubectl -n "$NAMESPACE" get ingress "$INGRESS_NAME" \
  -o jsonpath='{.status.loadBalancer.ingress[*].ip}')

INGRESS_IP=$(printf '%s\n' "$INGRESS_IPS" |
  tr ' ' '\n' |
  grep -m1 -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' || true)

[[ -n "$INGRESS_IP" ]] ||
  fail "Ingress has no IPv4 address"

log "Ingress IP: $INGRESS_IP"

ENVOY_CONTAINER=""

while IFS= read -r container; do
  [[ -z "$container" ]] && continue

  container_ip=$(docker inspect "$container" \
    --format '{{with index .NetworkSettings.Networks "kind"}}{{.IPAddress}}{{end}}')

  if [[ "$container_ip" == "$INGRESS_IP" ]]; then
    ENVOY_CONTAINER="$container"
    break
  fi
done < <(
  docker ps --filter "name=kindccm-gw-" --format '{{.Names}}'
)

[[ -n "$ENVOY_CONTAINER" ]] ||
  fail "Cannot find Envoy container for $INGRESS_IP"

log "Using Envoy: $ENVOY_CONTAINER"

if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  docker network create "$NETWORK_NAME"
fi

CONNECTED=$(docker inspect "$ENVOY_CONTAINER" \
  --format "{{if index .NetworkSettings.Networks \"$NETWORK_NAME\"}}yes{{end}}")

if [[ "$CONNECTED" != "yes" ]]; then
  docker network connect \
    --alias "$NETWORK_ALIAS" \
    "$NETWORK_NAME" \
    "$ENVOY_CONTAINER"
fi

ALIASES=$(docker inspect "$ENVOY_CONTAINER" \
  --format "{{with index .NetworkSettings.Networks \"$NETWORK_NAME\"}}{{range .Aliases}}{{println .}}{{end}}{{end}}")

grep -Fxq "$NETWORK_ALIAS" <<< "$ALIASES" ||
  fail "Envoy network alias is missing"

log "Starting Nginx"

docker compose -f proxy/docker-compose.yaml up -d

log "Nginx started"
