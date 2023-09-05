#!/usr/bin/env zsh

if [[ "x$SYSTEM" = "xLinux" ]]; then
    sudo apt update && sudo apt upgrade \
    && brew update; brew upgrade; brew cleanup \
    && pip install --upgrade pip setuptools wheel \
    && rustup update

    SNAP=$(which snap)
    if [[ "$SNAP" =~ "not found" ]]; then
        snap refresh
    fi
else
    brew update; brew upgrade; brew cleanup \
    && pip install --upgrade pip setuptools wheel
fi

# Update pyenv
if [ -d $HOME/.pyenv ]; then
    pushd $(pyenv root)
    git pull
    popd
fi

# Update nvm
if [ -d $HOME/.nvm ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
fi