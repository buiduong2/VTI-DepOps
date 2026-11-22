
#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

CLUSTER_NAME="chat-support"
NETWORK_NAME="chat-ingress-net"
COMPOSE_FILE="$ROOT_DIR/proxy/docker-compose.yaml"

require_command docker
require_command kind

echo "======================================"
echo " Chat Support - Environment Cleanup"
echo "======================================"
echo
echo "Resources to remove:"
echo "  - Nginx Compose stack"
echo "  - Docker network: $NETWORK_NAME"
echo "  - Kind cluster: $CLUSTER_NAME"
echo
echo "WARNING: Kubernetes resources and"
echo "PostgreSQL data inside this Kind"
echo "cluster will be permanently removed."
echo

read -r -p "Type DELETE to continue: " CONFIRM

if [[ "$CONFIRM" != "DELETE" ]]; then
  echo "Cleanup cancelled."
  exit 0
fi

# 1. Stop reverse proxy
log "Stopping Nginx"

docker compose \
  -f "$COMPOSE_FILE" \
  down --remove-orphans

# 2. Delete Kind cluster
log "Deleting Kind cluster"

if kind get clusters | grep -Fxq "$CLUSTER_NAME"; then
  kind delete cluster --name "$CLUSTER_NAME"
else
  echo "Cluster does not exist, skipping."
fi

# 3. Delete proxy network
log "Removing Docker network"

if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  docker network rm "$NETWORK_NAME"
else
  echo "Network does not exist, skipping."
fi

log "Cleanup completed"
