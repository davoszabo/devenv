# Overview
Fedora [Toolbx](https://github.com/containers/toolbox) development environment using **Podman**.

This repo is intentionally minimal and only documents the files that exist here:

- `Containerfile.fedora`: builds the toolbox image (tools + devcontainer CLI)
- `scripts/devenv-toolbox.sh`: sourced on shell startup; mirrors `DOCKER_HOST`/`CONTAINER_HOST` when only one is set, then auto-attaches to tmux (TPM bootstrap)
- `toolbox-init.sh`: helper to `podman build` + `toolbox create`

The default managed image contains mainly the followings:

- neovim
- tmux
- lazygit
- devcontainer-cli
- kubernetes tools: kubectl, helm and k9s

## Prerequisites

- Toolbx
- Podman (or Docker)

# Getting started

Pull and use the base image:
```
toolbox create --image docker.io/dev2dy/devenv:latest devenv
toolbox enter devenv
```

## Build your own

Edit the `Containerfile.fedora` to your own taste and use the custom init script:
```
./scripts/toolbox-create-devenv.sh --recreate
toolbox enter devenv
```

or build and start it manually:
```
# Build a new one if necessary
podman build -f Containerfile.fedora -t <tag> <repo_root>

# Recreate if needed
toolbox rm -f devenv

# Start the container
toolbox create --image dev2dy/devenv:latest devenv
toolbox enter devenv
```

# Runtime behavior

- **tmux on startup**: entering the toolbox with an interactive bash will `exec tmux -u2 new -A -s devenv` unless `DEVENV_NO_TMUX=1` is set. TPM is cloned and `install_plugins.sh` is run if present.
- **Podman / devcontainer env**: ensure `DOCKER_HOST` is set for the toolbox (usually inherited from the host/session). The image hook copies it to `CONTAINER_HOST` (and the reverse if needed) so Podman and devcontainer-cli agree without extra host dotfiles.
- **devcontainer-cli**: `devcontainer` is installed in the image and uses the `docker` CLI (provided by `podman-docker`) to talk to Podman.

