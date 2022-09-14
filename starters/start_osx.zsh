#!/usr/bin/env zsh

ARCH=$(uname -p)
APPLE_CHIP="intel"
if [ "x$SYSTEM" = "xDarwin" ] && [ "$ARCH" = "arm" ]; then
    APPLE_CHIP="silicon"
fi

mkdir -p $HOME/bin
mkdir -p $HOME/.local

# Brew System Package manager
#
# Install brew
# https://laict.medium.com/install-homebrew-on-macos-11-apple-silicon-630f37a74490
BREW=$(which brew)
if [ "x$BREW" = "x" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "# Brew env vars" >> $HOME/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
fi

if [ "$APPLE_CHIP" = "silicon" ]; then
    # Install brew intel dedicated to run programs that are not yet natively compiled for ARM
    IBREW=$(which ibrew)
    if [ "x$IBREW" = "x" ]; then
        pushd /usr/local
        mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
        popd
    fi

    IBREW_ALIAS=$(grep ibrew $ZSHCONFIG/aliases/.macos)
    if [ "x$IBREW_ALIAS" = "x" ]; then
        echo "# Rosetta Intel based brew" >> $ZSHCONFIG/aliases/.macos
        echo "alias ibrew='arch -x86_64 /usr/local/homebrew/bin/brew'" >> $ZSHCONFIG/aliases/.macos
    fi
fi

source $HOME/.zprofile
source $HOME/.zshrc

# Build deps
#
# XCode Command Line tools
XCODE=$(xcode-select -p)
if [ "$XCODE" != "/Library/Developer/CommandLineTools" ]; then
    xcode-select --install
fi

# Brew packages
TAPS=()
LIBS=()
CASKS=()
BREW_PKGS=$(brew list)
AWSCURL=$(echo $BREW_PKGS|grep awscurl)
if [ "x$AWSCURL" = "x" ]; then LIBS+=("awscurl") fi
FD=$(echo $BREW_PKGS|grep fd)
if [ "x$FD" = "x" ]; then LIBS+=("fd") fi
FFMPEG=$(echo $BREW_PKGS|grep ffmpeg)
if [ "x$FFMPEG" = "x" ]; then LIBS+=("ffmpeg") fi
JQ=$(echo $BREW_PKGS|grep jq)
if [ "x$JQ" = "x" ]; then LIBS+=("jq") fi
HELM=$(echo $BREW_PKGS|grep helm)
if [ "x$HELM" = "x" ]; then LIBS+=("helm") fi
HEROKU=$(echo $BREW_PKGS|grep heroku)
if [ "x$HEROKU" = "x" ]; then
    TAPS+=("heroku/brew")
    LIBS+=("heroku")
fi
OPENSSL=$(echo $BREW_PKGS|grep openssl)
if [ "x$OPENSSL" = "x" ]; then LIBS+=("openssl") fi
NCDU=$(echo $BREW_PKGS|grep ncdu)
if [ "x$NCDU" = "x" ]; then LIBS+=("ncdu") fi
PANDOC=$(echo $BREW_PKGS|grep pandoc)
if [ "x$PANDOC" = "x" ]; then LIBS+=("pandoc") fi
CMAKE=$(echo $BREW_PKGS|grep cmake)
if [ "x$CMAKE" = "x" ]; then LIBS+=("cmake") fi
POPPLER=$(echo $BREW_PKGS|grep poppler)
if [ "x$POPPLER" = "x" ]; then LIBS+=("poppler") fi
READLINE=$(echo $BREW_PKGS|grep readline)
if [ "x$READLINE" = "x" ]; then LIBS+=("readline") fi
RGA=$(echo $BREW_PKGS|grep ripgrep-all)
if [ "x$RGA" = "x" ]; then LIBS+=("rga") fi
SQLITE=$(echo $BREW_PKGS|grep sqlite)
if [ "x$SQLITE" = "x" ]; then LIBS+=("sqlite3") fi
TESSERACT=$(echo $BREW_PKGS|grep tesseract)
if [ "x$TESSERACT" = "x" ]; then LIBS+=("tesseract") fi
TREE=$(echo $BREW_PKGS|grep tree)
if [ "x$TREE" = "x" ]; then LIBS+=("tree") fi
HTOP=$(echo $BREW_PKGS|grep htop)
if [ "x$HTOP" = "x" ]; then LIBS+=("htop") fi
VIPS=$(echo $BREW_PKGS|grep vips)
if [ "x$VIPS" = "x" ]; then LIBS+=("vips") fi
WGET=$(echo $BREW_PKGS|grep wget)
if [ "x$WGET" = "x" ]; then LIBS+=("wget") fi
XZ=$(echo $BREW_PKGS|grep xz)
if [ "x$XZ" = "x" ]; then LIBS+=("xz") fi
ZLIB=$(echo $BREW_PKGS|grep zlib)
if [ "x$ZLIB" = "x" ]; then LIBS+=("zlib") fi
RECTANGLE=$(echo $BREW_PKGS|grep rectangle)
if [ "x$RECTANGLE" = "x" ]; then CASKS+=("rectangle") fi
KEYCASTR=$(echo $BREW_PKGS|grep keycastr)
if [ "x$KEYCASTR" = "x" ]; then CASKS+=("keycastr") fi
# https://github.com/ibraheemdev/modern-unix
DUST=$(echo $BREW_PKGS|grep dust)
if [ "x$DUST" = "x" ]; then LIBS+=("dust") fi
DOG=$(echo $BREW_PKGS|grep dog)
if [ "x$DOG" = "x" ]; then LIBS+=("dog") fi
GPING=$(echo $BREW_PKGS|grep gping)
if [ "x$GPING" = "x" ]; then LIBS+=("gping") fi
PROCS=$(echo $BREW_PKGS|grep procs)
if [ "x$PROCS" = "x" ]; then LIBS+=("procs") fi
DUF=$(echo $BREW_PKGS|grep duf)
if [ "x$DUF" = "x" ]; then LIBS+=("duf") fi
BAT=$(echo $BREW_PKGS|grep bat)
if [ "x$BAT" = "x" ]; then LIBS+=("bat") fi
# https://github.com/dandavison/delta
GIT_DELTA=$(echo $BREW_PKGS|grep git-delta)
if [ "x$GIT_DELTA" = "x" ]; then LIBS+=("git-delta") fi
# https://github.com/ajeetdsouza/zoxide
ZOXIDE=$(echo $BREW_PKGS|grep zoxide)
if [ "x$ZOXIDE" = "x" ]; then LIBS+=("zoxide") fi
GRAPHVIZ=$(echo $BREW_PKGS|grep graphviz)
if [ "x$GRAPHVIZ" = "x" ]; then LIBS+=("graphviz") fi
P7Z=$(echo $BREW_PKGS|grep p7zip)
if [ "x$P7Z" = "x" ]; then LIBS+=("p7zip") fi
NMAP=$(echo $BREW_PKGS|grep nmap)
if [ "x$NMAP" = "x" ]; then LIBS+=("nmap") fi
SCRUB=$(echo $BREW_PKGS|grep scrub)
if [ "x$SCRUB" = "x" ]; then LIBS+=("scrub") fi
MDCAT=$(echo $BREW_PKGS|grep mdcat)
if [ "x$MDCAT" = "x" ]; then LIBS+=("mdcat") fi
WATCH=$(echo $BREW_PKGS|grep watch)
if [ "x$WATCH" = "x" ]; then LIBS+=("watch") fi
COREUTILS=$(echo $BREW_PKGS|grep coreutils)
if [ "x$COREUTILS" = "x" ]; then LIBS+=("coreutils") fi
# Updated version of bash
BASH=$(echo $BREW_PKGS|grep bash)
if [ "x$BASH" = "x" ]; then LIBS+=("bash") fi
# Networking
MTR=$(echo $BREW_PKGS|grep mtr)
if [ "x$MTR" = "x" ]; then LIBS+=("mtr") fi
IPCALC=$(echo $BREW_PKGS|grep ipcalc)
if [ "x$IPCALC" = "x" ]; then LIBS+=("ipcalc") fi
GREPCIDR=$(echo $BREW_PKGS|grep grepcidr)
if [ "x$GREPCIDR" = "x" ]; then LIBS+=("grepcidr") fi
# https://github.com/theZiz/aha
AHA=$(echo $BREW_PKGS|grep aha)
if [ "x$AHA" = "x" ]; then LIBS+=("aha") fi
JUST=$(echo $BREW_PKGS|grep just)
if [ "x$JUST" = "x" ]; then LIBS+=("just") fi

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

FZF=$HOME/.fzf
if [ ! -d  "$FZF" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
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
if [ "x$NODE14" = "x" ]; then
    nvm install 14
fi
NODE16=$(echo $NODE_VERSIONS|grep v16)
if [ "x$NODE16" = "x" ]; then
    nvm install 16
    nvm use 16
fi
TLDR=$(which tldr)
if [ "x$TLDR" = "x" ]; then
    # https://github.com/tldr-pages/tldr
    npm i -g tldr
fi
NCU=$(which ncu)
if [ "x$NCU" = "x" ]; then
    npm i -g npm-check-updates
fi
CDK_DIA=$(which cdk-dia)
if [[ "x$CDK_DIA" = "x" ]]; then
    # https://github.com/pistazie/cdk-dia
    npm i -g cdk-dia
fi

# Ruby
#
# rbenv
RBENV_DIR=$HOME/.rbenv
if [ ! -d "$RBENV_DIR" ]; then
    git clone https://github.com/rbenv/rbenv.git $RBENV_DIR
    if [ "x$RBENV_ROOT" = "x" ]; then
        echo 'export RBENV_ROOT="$HOME/.rbenv"' >> ~/.zshrc
        echo 'export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"' >> ~/.zshrc
    fi
fi
source $HOME/.zshrc

# ruby versions
RUBY312=$(rbenv versions|grep 3.1.2)
if [ "x$RUBY312" = "x" ]; then
    rbenv install 3.1.2
fi

# Python
#
# pyenv
PYENV_DIR=$HOME/.pyenv
if [ ! -d "$PYENV_DIR" ]; then
    git clone https://github.com/pyenv/pyenv.git $PYENV_DIR
    if [ "x$PYENV_ROOT" = "x" ]; then
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
        echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    fi
fi
source $HOME/.zshrc

PYENV_PLUGINS_DIR=$HOME/.pyenv/plugins
if [ ! -d "$PYENV_PLUGINS_DIR" ]; then
    git clone https://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update
fi

# python versions
PYTHON27=$(pyenv versions|grep 2.7)
if [ "x$PYTHON27" = "x" ]; then
    pyenv install 2.7.18
fi
PYTHON37=$(pyenv versions|grep 3.7)
if [ "x$PYTHON37" = "x" ]; then
    pyenv install 3.7.10
fi
PYTHON38=$(pyenv versions|grep 3.8)
if [ "x$PYTHON38" = "x" ] && [ $APPLE_CHIP = "silicon" ]; then
	# https://github.com/pyenv/pyenv/issues/1768#issuecomment-753756051
    curl -sSL https://raw.githubusercontent.com/Homebrew/formula-patches/113aa84/python/3.8.3.patch\?full_index\=1|pyenv install --patch 3.8.6
fi
PYTHON39=$(pyenv versions|grep 3.9)
if [ "x$PYTHON39" = "x" ]; then
    pyenv install 3.9.4
fi

# Poetry
#
POETRY=$(which poetry)
if [ "x$POETRY" = "x" ]; then
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
    source $HOME/.zshrc
    poetry config virtualenvs.in-project true
fi

# Fonts
#
FIRACODE=$(echo $BREW_PKGS|grep font-fira-code)
if [ "x$FIRACODE" = "x" ]; then
    brew tap homebrew/cask-fonts
    brew install --cask font-fira-code
fi

# Rust
#
RUSTUP=$(which rustup)
if [ "x$RUSTUP" = "x" ]; then
    # https://doc.bccnsoft.com/docs/rust-1.36.0-docs-html/edition-guide/rust-2018/rustup-for-managing-rust-versions.html
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs|sh
fi

# Kubernetes
#
if [ ! -d /usr/local/bin ]; then
    sudo mkdir /usr/local/bin
fi

ARKADE=$(which arkade)
if [ "x$ARKADE" = "x" ]; then
    pushd /tmp
    curl -sLS https://dl.get-arkade.dev|sh
    sudo cp arkade-darwin /usr/local/bin/arkade
    sudo ln -sf /usr/local/bin/arkade /usr/local/bin/ark
    popd
fi

KUBECTL=$(which kubectl)
if [ "x$KUBECTL" = "x" ]; then
    arkade get kubectl
fi

FAAS=$(which faas-cli)
if [ "x$FAAS" = "x" ]; then
    arkade get faas-cli
fi

K3SUP=$(which k3sup)
if [ "x$K3SUP" = "x" ]; then
    pushd /tmp
    curl -sLS https://get.k3sup.dev|sh
    sudo install k3sup /usr/local/bin/
    popd
fi

KUBETAIL=$(which kubetail)
if [ "x$KUBETAIL" = "x" ]; then
    sudo wget https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail -O /usr/local/bin/kubetail
    sudo chmod 755 /usr/local/bin/kubetail
fi

# helm package manager for k8s
HELM=$(which helm)
if [ "x$HELM" = "x" ]; then
    arkade get helm
fi

# Cloud
#
AWS=$(which aws)
if [ "x$AWS" = "x" ]; then
    pip3 install awscli
fi

# Profilers
#
CGMEMTIME=$(which cgmemtime)
if [[ "$CGMEMTIME" =~ "not found" ]]; then
    pushd ~/.local
    git clone https://github.com/gsauthof/cgmemtime
    cd cgmemtime
    make
    sudo ./cgmemtime --setup -g $(groups $(whoami) | cut -d' ' -f1) --perm 775
    ln -s $PWD/cgmemtime ~/bin/cgmemtime
    popd
fi

# Scrapers
#
WHATWEB=$(which whatweb)
if [[ "$WHATWEB" =~ "not found" ]]; then
    pushd ~/.local
    wget https://github.com/urbanadventurer/WhatWeb/archive/refs/tags/v0.5.5.tar.gz -O whatweb.tar.gz
    tar -zxvf whatweb.tar.gz
    cd WhatWeb-0.5.5/
    gem install bundler
    bundle update
    bundle install
    ./whatweb --version
    ln -s $PWD/whatweb ~/bin/whatweb
    popd
fi

# Docker images
#
CURLIFIREFOX=$(docker images|grep lwthiker/curl-impersonate|grep 0.5-ff)
if [ "x$CURLIFIREFOX" = "x" ]; then
    docker pull lwthiker/curl-impersonate:0.5-ff
fi
CURLICHROME=$(docker images|grep lwthiker/curl-impersonate|grep 0.5-chrome)
if [ "x$CURLICHROME" = "x" ]; then
    docker pull lwthiker/curl-impersonate:0.5-chrome
fi
THEHARVESTER=$(docker images|grep theharvester)
if [ "x$THEHARVESTER" = "x" ]; then
    pushd ~/.local
    if [ ! -d theHarvester ]; then
        git clone https://github.com/laramies/theHarvester 
    fi
    cd theHarvester
    docker build -t theharvester .
    popd
fi