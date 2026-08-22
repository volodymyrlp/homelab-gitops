#!/usr/bin/env bash
# Recompute checksum/config annotation in apps/ai/litellm.yaml so that a
# ConfigMap edit triggers a pod rollout. Run after changing the LiteLLM config.
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
import hashlib, re
p = 'apps/ai/litellm.yaml'
s = open(p).read()
body = s.split('---')[0].split('config.yaml: |', 1)[1]
h = hashlib.sha256(body.encode()).hexdigest()[:16]
s2 = re.sub(r'checksum/config: "[0-9a-f]*"', f'checksum/config: "{h}"', s)
open(p, 'w').write(s2)
print(h)
PY
