#!/usr/bin/env zsh

export ZSHCONFIG="${HOME}/.zsh-config"

function zsh_bootstrap(){
    local ZINIT="${HOME}/.zinit"
    if [ ! -d "${ZINIT}" ] ; then
        echo "Cloning zinit"
        mkdir $ZINIT && git clone https://github.com/zdharma-continuum/zinit.git $ZINIT/bin
    fi

    if [[ "x$SYSTEM" = "xDarwin"  ]]; then
        echo "Loading MAC Os config"
        sh ${ZSHCONFIG}/config/.macos
    fi

    echo "Link resource files to ${HOME}"
    ln -sf ${ZSHCONFIG}/zlogin ${HOME}/.zlogin
    ln -sf ${ZSHCONFIG}/zprofile ${HOME}/.zprofile
    ln -sf ${ZSHCONFIG}/zshenv ${HOME}/.zshenv
    ln -sf ${ZSHCONFIG}/zshrc ${HOME}/.zshrc
    echo "Done!"
}

function zsh_cleanup(){
    echo "Clean up links to resource files at ${HOME}"
    rm -f ${HOME}/.zlogin ${HOME}/.zprofile ${HOME}/.zshenv ${HOME}/.zshrc
    echo "Done!"
}

zsh_bootstrap