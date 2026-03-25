#!/usr/bin/env bash
# Build the Fedora toolbox image and create the toolbox (no extra volumes).
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
image="${DEVENV_IMAGE:-dev2dy/devenv-fedora:latest}"
name="${DEVENV_TOOLBOX_NAME:-devenv}"

podman build -f "${repo_root}/Containerfile.fedora" -t "${image}" "${repo_root}"

if [[ "${1:-}" == "--recreate" ]]; then
  toolbox rm -f "${name}" 2>/dev/null || true
fi

exec toolbox create --image "${image}" "${name}"
