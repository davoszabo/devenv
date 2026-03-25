#!/usr/bin/env bash
# Toolbox runtime hook (sourced by bashrc/profile; not executed directly).
# - Mirror DOCKER_HOST <-> CONTAINER_HOST when only one is set (Podman + podman-docker / devcontainer)
# - Auto-enter tmux session "devenv" on interactive bash (TPM bootstrap), opt-out via DEVENV_NO_TMUX=1
#
# Expect DOCKER_HOST to come from the host/session (Toolbox often passes it through). This file
# lives in the image so you do not need host ~/.bashrc.d for CONTAINER_HOST.

set +e

devenv__sync_container_docker_host() {
  if [[ -n "${DOCKER_HOST:-}" && -z "${CONTAINER_HOST:-}" ]]; then
    export CONTAINER_HOST="$DOCKER_HOST"
  elif [[ -n "${CONTAINER_HOST:-}" && -z "${DOCKER_HOST:-}" ]]; then
    export DOCKER_HOST="$CONTAINER_HOST"
  fi
}

devenv__tmux_auto_enter() {
  [[ -n "${BASH_VERSION:-}" ]] || return 0
  [[ $- == *i* ]] || return 0
  [[ -z "${TMUX:-}" ]] || return 0
  [[ -t 0 ]] || return 0
  [[ "${DEVENV_NO_TMUX:-}" == "1" ]] && return 0

  command -v tmux >/dev/null 2>&1 || return 0

  # TPM bootstrap
  if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
    mkdir -p "${HOME}/.tmux/plugins"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm" 2>/dev/null || true
  fi
  if [[ -x "${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh" ]]; then
    "${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh" >/dev/null 2>&1 || true
  fi

  exec tmux -u2 new -A -s devenv
}

devenv__sync_container_docker_host
devenv__tmux_auto_enter
