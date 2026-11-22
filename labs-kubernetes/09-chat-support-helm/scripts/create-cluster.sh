
#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

CLUSTER_NAME="chat-support"

require_command kind
require_command kubectl
require_command docker

log "Checking Kind cluster"

if kind get clusters | grep -Fxq "$CLUSTER_NAME"; then
  log "Cluster already exists: $CLUSTER_NAME"
else
  log "Creating Kind cluster: $CLUSTER_NAME"

  kind create cluster \
    --name "$CLUSTER_NAME" \
    --config "$ROOT_DIR/cluster/kind-config.yaml" \
    --wait 5m
fi

log "Selecting Kubernetes context"

kubectl config use-context "kind-$CLUSTER_NAME"

log "Checking Kubernetes nodes"

kubectl get nodes -o wide
