#!/usr/bin/env zsh

source $HOME/.zprofile
source $HOME/.zshrc

PYTHON_VERSIONS=("3.8.0" "3.8.6")
for v in "${PYTHON_VERSIONS[@]}"; do
    echo "Removing $v"
    python=$(pyenv versions|grep $v)
    if [ "x$python" != "x" ]; then
        pyenv shell $python
        pip freeze | xargs pip uninstall -y
        pyenv uninstall $python
    fi
done

NODE_VERSIONS=("v10.23.0")
for v in "${NODE_VERSIONS[@]}"; do
    node=$(nvm ls --no-colors --no-alias|grep $v)
    if [ "x$node" != "x" ]; then
        nvm uninstall $v
    fi
done