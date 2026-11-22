
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

run_step() {
  local name="$1"
  local script="$2"

  echo
  echo "========================================"
  echo "  $name"
  echo "========================================"

  bash "$ROOT_DIR/scripts/$script"
}

run_step "1/5 Checking environment" \
  "check-prerequisites.sh"

run_step "2/5 Applying Kubernetes configuration" \
  "apply-secrets.sh"

run_step "3/5 Deploying PostgreSQL" \
  "deploy-postgres.sh"

run_step "4/5 Deploying applications" \
  "deploy-apps.sh"

# Application environment variables from Secrets
# are loaded when a Pod starts.
if [[ "${RESTART_APPS:-true}" == "true" ]]; then
  echo
  echo "Refreshing application Pods..."

  for app in auth chat chat-ui; do
    kubectl -n "${NAMESPACE:-default}" rollout restart "deployment/$app"
    kubectl -n "${NAMESPACE:-default}" rollout status \
      "deployment/$app" --timeout=180s
  done
fi

run_step "5/5 Starting reverse proxy" \
  "start-proxy.sh"

echo
echo "========================================"
echo "  Deployment completed"
echo "========================================"

helm list -n "${NAMESPACE:-default}"
kubectl -n "${NAMESPACE:-default}" get pods,svc,ingress
