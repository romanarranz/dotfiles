#!/usr/bin/env zsh

if [[ "x$SYSTEM" = "xLinux" ]]; then
    sudo apt update && sudo apt upgrade \
    && brew update; brew upgrade; brew cu -ay; brew cleanup \
    && pip install --upgrade pip setuptools wheel \
    && rustup update

    SNAP=$(which snap)
    if [[ "$SNAP" =~ "not found" ]]; then
        snap refresh
    fi
else
    brew update; brew upgrade; brew cu -ay; brew cleanup \
    && pip install --upgrade pip setuptools wheel
fi