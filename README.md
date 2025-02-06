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

## Prerequisites
There might be some manual steps to follow regarding your needs.

### Clipboard support
- xclip (X11)
- wl-clipboard (Wayland)

Edit the `docker-compose.yaml` file and uncomment the lines regarding the environment you want to use.

**wl-clipboard** will need the `messagbus` user and group, that you might need to set up manually:
```
sudo groupadd -g 101 messagebus
sudo useradd -r -K SYS_UID_MIN=100 -K SYS_UID_MAX=999 -d /nonexistent -g messagebus -s /usr/sbin/nologin -u 100 messagebus
```

## Usage
Please use the `./init.sh` script that collects the required user and group IDs and initiate the container creation. The compose file will mount the user /home directory. This helps you utilize your configurations to keep it on the host, but also use it inside the container, so there is not need to COPY the configs each time to the container. Users and groups are also mounted in read-only mode to ensure proper permissions.

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

