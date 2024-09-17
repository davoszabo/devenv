#!/bin/bash

if [ ! -d ~/.tmux ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Ubuntu bashrc
cp /etc/skel/.bashrc ~/.bashrc-devenv

# Uncomment the "force_color_prompt=yes" to show color in prompt
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' ~/.bashrc-devenv

# Check if the .bashrc-devenv is referenced, and if not, write it into .bashrc
if ! grep -wq ".bashrc-devenv" ~/.bashrc; then
    cat >> ~/.bashrc <<EOF

# Linking devenv bashrc
if [ -f ~/.bashrc-devenv ]; then
    source ~/.bashrc-devenv
fi

EOF
fi

# Keep container alive
exec tail -f /dev/null

