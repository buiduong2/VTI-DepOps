#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="chat-support"

echo "Loading PostgreSQL..."
docker image save \
  --platform linux/amd64 \
  -o /tmp/postgres-17.tar \
  postgres:17-alpine

kind load image-archive /tmp/postgres-17.tar \
  --name "$CLUSTER_NAME"

echo "Loading application images..."
kind load docker-image duongbd1997/lacdau-auth:latest --name "$CLUSTER_NAME"
kind load docker-image duongbd1997/lacdau-chat:latest --name "$CLUSTER_NAME"
kind load docker-image duongbd1997/lacdau-chat-ui:v2 --name "$CLUSTER_NAME"

echo "All images loaded."
