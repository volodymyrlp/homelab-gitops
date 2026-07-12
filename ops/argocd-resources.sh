#!/usr/bin/env bash
# Set CPU/memory requests+limits on ArgoCD components.
# ArgoCD is installed from raw install.yaml (not yet GitOps-managed - see item #8),
# so we patch the live workloads directly. Idempotent: re-running is safe.
# Usage: bash ops/argocd-resources.sh [kube-context]
set -euo pipefail
CTX="${1:-homelab}"

set_res() { kubectl --context "$CTX" -n argocd set resources "$1" --requests="$2" --limits="$3"; }

set_res statefulset/argocd-application-controller      cpu=100m,memory=256Mi memory=512Mi
set_res deployment/argocd-repo-server                  cpu=50m,memory=128Mi  memory=256Mi
set_res deployment/argocd-server                       cpu=50m,memory=128Mi  memory=256Mi
set_res deployment/argocd-notifications-controller     cpu=25m,memory=64Mi   memory=128Mi
set_res deployment/argocd-applicationset-controller    cpu=25m,memory=64Mi   memory=128Mi
set_res deployment/argocd-dex-server                   cpu=10m,memory=32Mi   memory=64Mi
set_res deployment/argocd-redis                        cpu=25m,memory=64Mi   memory=128Mi

echo "done."
