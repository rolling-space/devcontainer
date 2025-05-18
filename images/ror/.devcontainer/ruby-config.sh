#!/bin/zsh
set -e

# USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"
USERNAME="runner"
RUBY_VERSION="3.4.3"
if [ "${USERNAME}" != "root" ]; then
    mkdir -p /home/${USERNAME}/.rbenv/plugins
    ln -s /usr/local/share/ruby-build /home/${USERNAME}/.rbenv/plugins/ruby-build

    chown -R "${USERNAME}" "/home/${USERNAME}/.rbenv/"
    chmod -R g+r+w "/home/${USERNAME}/.rbenv"

    echo 'eval "$(rbenv init -)"' >> /home/${USERNAME}/.bashrc

    if [ -f /home/${USERNAME}/.zshrc ]; then
        echo 'eval "$(rbenv init -)"' >> /home/${USERNAME}/.zshrc
    fi

    rbenv install $RUBY_VERSION
    rbenv global $RUBY_VERSION
else
su ${USERNAME} -c "rbenv install $RUBY_VERSION"
su ${USERNAME} -c "rbenv global $RUBY_VERSION"
fi

# Exit gracefully if no files or directories are found
if [ -d /var/lib/apt/lists ] && [ "$(ls -A /var/lib/apt/lists)" ]; then
    rm -rf /var/lib/apt/lists/*
else
    echo "No files or directories found in /var/lib/apt/lists. Skipping removal."
fi