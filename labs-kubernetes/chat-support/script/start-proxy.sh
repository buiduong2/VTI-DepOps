
#!/usr/bin/env bash
set -euo pipefail

CLUSTER_CONTEXT="kind-chat-support"
INGRESS_NAME="chat-support-ingress"
NETWORK_NAME="chat-ingress-net"
NETWORK_ALIAS="chat-ingress"

echo "Checking Kubernetes context..."

CURRENT_CONTEXT=$(kubectl config current-context)

if [[ "$CURRENT_CONTEXT" != "$CLUSTER_CONTEXT" ]]; then
  echo "ERROR: Expected context $CLUSTER_CONTEXT, got $CURRENT_CONTEXT"
  exit 1
fi

echo "Finding Ingress IP..."

INGRESS_IPS=$(kubectl get ingress "$INGRESS_NAME" \
  -o jsonpath='{.status.loadBalancer.ingress[*].ip}')

INGRESS_IP=$(echo "$INGRESS_IPS" | tr ' ' '\n' |
  grep -m1 -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' || true)

if [[ -z "$INGRESS_IP" ]]; then
  echo "ERROR: Ingress has no IPv4 address."
  echo "Check whether cloud-provider-kind is running."
  exit 1
fi

echo "Ingress IP: $INGRESS_IP"

echo "Finding Envoy container..."

ENVOY_CONTAINER=""

while IFS= read -r container; do
  [[ -z "$container" ]] && continue

  container_ip=$(docker inspect "$container" \
    --format '{{with index .NetworkSettings.Networks "kind"}}{{.IPAddress}}{{end}}')

  if [[ "$container_ip" == "$INGRESS_IP" ]]; then
    ENVOY_CONTAINER="$container"
    break
  fi
done < <(docker ps \
  --filter "name=kindccm-gw-" \
  --format '{{.Names}}')

if [[ -z "$ENVOY_CONTAINER" ]]; then
  echo "ERROR: Cannot find Envoy for Ingress $INGRESS_IP"
  exit 1
fi

echo "Envoy: $ENVOY_CONTAINER"

echo "Checking Docker network..."

if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  docker network create "$NETWORK_NAME"
fi

CONNECTED=$(docker inspect "$ENVOY_CONTAINER" \
  --format '{{if index .NetworkSettings.Networks "chat-ingress-net"}}yes{{end}}')

if [[ "$CONNECTED" != "yes" ]]; then
  echo "Connecting Envoy to $NETWORK_NAME..."

  docker network connect \
    --alias "$NETWORK_ALIAS" \
    "$NETWORK_NAME" \
    "$ENVOY_CONTAINER"
fi

ALIASES=$(docker inspect "$ENVOY_CONTAINER" \
  --format '{{with index .NetworkSettings.Networks "chat-ingress-net"}}{{range .Aliases}}{{println .}}{{end}}{{end}}')

if ! grep -Fxq "$NETWORK_ALIAS" <<< "$ALIASES"; then
  echo "ERROR: Envoy is connected but alias is missing."
  exit 1
fi

echo "Proxy network preparation completed."
echo "You can now start Nginx with Docker Compose."

