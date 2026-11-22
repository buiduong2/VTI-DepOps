#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="chat-support"

if ! kind get clusters | grep -Fxq "$CLUSTER_NAME"; then
    echo "Cluster '$CLUSTER_NAME' does not exist."
    exit 0
fi

read -r -p "Delete Kind cluster '$CLUSTER_NAME'? [y/N]: " answer

if [[ "$answer" != "y" ]]; then
    echo "Cancelled."
    exit 0
fi

kind delete cluster --name "$CLUSTER_NAME"
