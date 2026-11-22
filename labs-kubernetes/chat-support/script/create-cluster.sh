#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="chat-support"

if kind get clusters | grep -Fxq "$CLUSTER_NAME"; then
    echo "Cluster '$CLUSTER_NAME' already exists."
    exit 0
fi

kind create cluster \
    --name "$CLUSTER_NAME" \
    --config cluster/kind-config.yaml

kubectl cluster-info --context "kind-$CLUSTER_NAME"
kubectl get nodes --context "kind-$CLUSTER_NAME"
