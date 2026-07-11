# homelab-gitops

GitOps repository for my homelab Kubernetes cluster (2-node K3s on Proxmox VE).
ArgoCD watches this repo and keeps the cluster in sync with it.

## Structure

```
apps/
  url-shortener/   # Flask + MySQL app: deployment, service, ingress, HPA, mysql
argocd/
  url-shortener-app.yaml   # ArgoCD Application pointing at apps/url-shortener
  ingress.yaml             # ArgoCD web UI behind traefik
```

## How it works

1. Manifests describing the desired cluster state live in `apps/`.
2. ArgoCD (running inside the cluster) pulls this repo, compares desired state
   with live state and syncs the difference.
3. Deploy = git commit. Rollback = git revert. Manual changes in the cluster
   get reverted by selfHeal.

## Notes

- The `mysql-secret` Secret is created manually in the cluster and is not
  stored in git.
- App source code and CI live in a separate repo:
  [url-shortener](https://github.com/volodymyrlp/url-shortener)

## Related repos

- [ansible-homelab](https://github.com/volodymyrlp/ansible-homelab) — VM base
  config and K3s installation
