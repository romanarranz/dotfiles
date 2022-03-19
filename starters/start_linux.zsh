#!/usr/bin/env zsh

ARCH=$(uname -p)
DISTRO="ubuntu"

# Brew System Package manager
#
# Install brew
BREW=$(which brew)
if [[ "$BREW" =~ "not found" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "# Brew env vars" >> $HOME/.zprofile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

source $HOME/.zprofile
source $HOME/.zshrc

# System packages
#
sudo apt update -y \
&& sudo apt install -y \
    build-essential \
    cmake \
    gnome-screensaver \
    graphviz \
    ncdu \
    snapd \
    vlc \
    wget \
    whois \
    xclip

# Brew packages
#
TAPS=()
LIBS=()
CASKS=()
BREW_PKGS=$(brew list)
AWSCURL=$(echo $BREW_PKGS|grep awscurl)
if [[ "x$AWSCURL" =~ "not found" ]]; then LIBS+=("awscurl") fi
FD=$(echo $BREW_PKGS|grep fd)
if [[ "x$FD" =~ "not found" ]]; then LIBS+=("fd") fi
# https://github.com/ibraheemdev/modern-unix
DUST=$(echo $BREW_PKGS|grep dust)
if [[ "x$DUST" =~ "not found" ]]; then LIBS+=("dust") fi
DOG=$(echo $BREW_PKGS|grep dog)
if [[ "x$DOG" =~ "not found" ]]; then LIBS+=("dog") fi
GPING=$(echo $BREW_PKGS|grep gping)
if [[ "x$GPING" =~ "not found" ]]; then LIBS+=("orf/brew/gping") fi
PROCS=$(echo $BREW_PKGS|grep procs)
if [[ "x$PROCS" =~ "not found" ]]; then LIBS+=("procs") fi
DUF=$(echo $BREW_PKGS|grep duf)
if [[ "x$DUF" =~ "not found" ]]; then LIBS+=("duf") fi
BAT=$(echo $BREW_PKGS|grep bat)
if [[ "x$BAT" =~ "not found" ]]; then LIBS+=("bat") fi
# https://github.com/dandavison/delta
GIT_DELTA=$(echo $BREW_PKGS|grep git-delta)
if [[ "x$GIT_DELTA" =~ "not found" ]]; then LIBS+=("git-delta") fi
ZOXIDE=$(echo $BREW_PKGS|grep zoxide)
if [[ "x$ZOXIDE" =~ "not found" ]]; then LIBS+=("zoxide") fi

if [ ${#TAPS[@]} -gt 0 ]; then
    brew tap $TAPS
fi

if [ ${#LIBS[@]} -gt 0 ]; then
    brew install $LIBS
    brew cleanup
fi

if [ ${#CASKS[@]} -gt 0 ]; then
    brew install --cask $CASKS
    brew cleanup
fi

# Snap packages
#
PICK=$(which pick-colour-picker)
if [[ "$PICK" =~ "not found" ]]; then
    sudo snap install pick-colour-picker
fi

# Node
#
# nvm
NVM_DIR=$HOME/.nvm
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh|bash
fi

NODE_VERSIONS=$(nvm ls --no-colors --no-alias)
NODE14=$(echo $NODE_VERSIONS|grep v14)
if [[ "x$NODE14" =~ "not found" ]]; then
    nvm install 14
fi
NODE16=$(echo $NODE_VERSIONS|grep v16)
if [[ "x$NODE16" =~ "not found" ]]; then
    nvm install 16
    nvm use 16
fi
TLDR=$(which tldr)
if [[ "$TLDR" =~ "not found" ]]; then
    # https://github.com/tldr-pages/tldr
    npm i -g tldr
fi
CDK_DIA=$(which cdk-dia)
if [[ "$CDK_DIA" =~ "not found" ]]; then
    # https://github.com/pistazie/cdk-dia
    npm i -g cdk-dia
fi

# Python
#
# pyenv
PYENV_DIR=$HOME/.pyenv
if [ ! -d "$PYENV_DIR" ]; then
    git clone https://github.com/pyenv/pyenv.git $PYENV_DIR
    if [[ "x$PYENV_ROOT" =~ "not found" ]]; then
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
        echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    fi
fi
source $HOME/.zshrc

PYENV_PLUGINS_DIR=$HOME/.pyenv/plugins
if [ ! -d "$PYENV_PLUGINS_DIR" ]; then
    git clone https://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update
fi

# Poetry
#
POETRY=$(which poetry)
if [[ "$POETRY" =~ "not found" ]]; then
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
    source $HOME/.zshrc
    poetry config virtualenvs.in-project true
fi

# Rust
#
RUSTUP=$(which rustup)
if [[ "$RUSTUP" =~ "not found" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs|sh
fi

# Java
#
# sdkman
SDKMAN_DIR=$HOME/.sdkman
if [ ! -d $SDKMAN_DIR ]; then
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

JAVA_VERSIONS=$(sdk ls java|grep installed)
JAVA17=$(echo $JAVA_VERSIONS|grep 17)
if [[ "x$JAVA17" = "x" ]]; then
    sdk install java 17.0.2-tem
fi

# Kubernetes
#
ARKADE=$(which arkade)
if [[ "$ARKADE" =~ "not found" ]]; then
    pushd /tmp
    curl -sLS https://dl.get-arkade.dev|sh
    sudo cp arkade /usr/local/bin/arkade
    sudo ln -sf /usr/local/bin/arkade /usr/local/bin/ark
    popd
fi

KUBECTL=$(which kubectl)
if [[ "$KUBECTL" =~ "not found" ]]; then
    arkade get kubectl
fi

FAAS=$(which faas-cli)
if [[ "$FAAS" =~ "not found" ]]; then
    arkade get faas-cli
fi

KUBETAIL=$(which kubetail)
if [[ "$KUBETAIL" =~ "not found" ]]; then
    sudo wget https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail -O /usr/local/bin/kubetail
    sudo chmod 755 /usr/local/bin/kubetail
fi

# helm package manager for k8s
HELM=$(which helm)
if [[ "$HELM" =~ "not found" ]]; then
    arkade get helm
fi

# Cloud
#
AWS=$(which aws)
if [[ "$AWS" =~ "not found" ]]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
fi
