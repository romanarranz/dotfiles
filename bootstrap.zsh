#!/usr/bin/env zsh

export ZSHCONFIG="${HOME}/.zsh-config"

function zsh_bootstrap(){
    # need zplugin
    echo "Cloning zinit"
    mkdir -p ~/.zinit && git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
    git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin

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