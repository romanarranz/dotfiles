#!/bin/bash
# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu

if [[ "x$SYSTEM" = "xLinux" ]]; then
    # apt
    sudo apt autoremove
    sudo apt autoclean

    # snapd
    LANG=C snap list --all | awk '/disabled/{print $1, $3}' |
        while read snapname revision; do
            echo "Removing snap $snapname@$revision"
            sleep 1
            sudo snap remove "$snapname" --revision="$revision"
        done
    sudo sh -c 'rm -rf /var/lib/snapd/cache/*'

    # caches
    if [ -d "~/.cache/Cypress" ]; then
        rm -r ~/.cache/Cypress/*
    fi

    # rotate logs
    sudo logrotate -vf /etc/logrotate.conf
     # retain last 7 days of journal logs
    sudo journalctl --vacuum-time=7d
fi