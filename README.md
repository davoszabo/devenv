# Overview
Containerized development environment, which contains: 
- tmux
- neovim
- lazygit
- devcontainer-cli 
- kubectl, helm and k9s for kubernetes

... and more.

## About
The base Dockerfile is responsible for creating the base that consists of the needed tools. On the other hand the user Dockerfile is dynamically creating a user specific environment based on the IDs of the user.

## Usage
Please use the `./init.sh` script that collects the required user and group IDs and initiate the container. The compose file will mount the user /home directory. This helps you utilize your configurations to keep it on the host, but also use it inside the container, so there is not need to COPY the configs each time to the container.

Exec into container:
```
docker exec -it dev-environment bash
```

You can also use another command to start an interactive shell on the container like `tmux`:
```
docker exec -it dev-environment tmux -u2 new -A
```

Stop container (won't remove)
```
docker stop dev-environment
```

Kill container (will remove)
```
docker compose down
```

