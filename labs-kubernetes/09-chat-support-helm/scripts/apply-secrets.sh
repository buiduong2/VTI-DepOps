
#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${1:-default}"

for app in auth chat chat-ui; do
  echo "Applying Secret: ${app}-secret"

  kubectl create secret generic "${app}-secret" \
    --namespace "$NAMESPACE" \
    --from-env-file="envs/${app}.env" \
    --dry-run=client -o yaml |
    kubectl apply --namespace "$NAMESPACE" -f -
done

echo "All application Secrets applied."
