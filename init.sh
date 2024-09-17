#!/bin/bash

# export USER="$(id -un)"
export UID="$(id -u)"
export GID="$(id -g)"
export DOCKER_GID=$(getent group docker | cut -d: -f3)  # Gain access to docker.sock
export WHEEL_GID=$(getent group wheel | cut -d: -f3)    # Gain root privilages

# Change to the parent directory of /scripts
#cd "$(dirname "$0")/.."

docker compose up -d --build

