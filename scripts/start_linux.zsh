#!/usr/bin/env zsh

ARCH=$(uname -p)
DISTRO="ubuntu"

# System packages
#
sudo add-apt-repository -y universe ppa:obsproject/obs-studio
sudo add-apt-repository -y ppa:umang/indicator-stickynotes
sudo add-apt-repository -y ppa:apandada1/xournalpp-stable
sudo apt update -y \
&& sudo apt install -y \
autoconf \
apt-transport-https \
arping \
bc \
bison \
build-essential \
ca-certificates \
curl \
cmake \
copyq \
coreutils \
dnsutils \
ffmpeg \
gcc \
g++ \
git \
gnome-screensaver \
gnupg \
graphviz \
jq \
htop \
indicator-stickynotes \
libreadline-dev \
libncurses5-dev \
libbz2-dev \
libffi-dev \
libgdbm-dev \
liblzma-dev \
libpoppler-cpp-dev \
libreadline-dev \
libssl-dev \
libsqlite3-dev \
libxml2-dev \
libxmlsec1-dev \
libyaml-dev \
llvm \
lsb-release \
ledger \
make \
ncdu \
net-tools \
nfs-common \
nmap \
obs-studio \
openssl \
protobuf-compiler \
p7zip-full \
p7zip-rar \
pandoc \
poppler-utils \
python-is-python3 \
python3 \
python3-venv \
remind \
ripgrep \
scrub \
snapd \
shellcheck \
software-properties-common \
tk-dev \
vlc \
wget \
whois \
wireguard \
xclip \
xclip \
zlib1g-dev \
xournalpp \
xz-utils \
zsh

# Create user dirs
mkdir -p $HOME/bin
mkdir -p $HOME/.local
mkdir -p $HOME/.reminders
mkdir -p $HOME/.local/share/fonts

# Download fonts
FONT_URLS=(
  "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
  "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
  "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
  "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
)

for font in "${FONT_URLS[@]}"; do
  filename=$(basename "$font")
  rm ~/.local/share/fonts/$filename ~/.local/share/fonts/$filename.*
  wget $font -P ~/.local/share/fonts
done

sudo apt install fonts-firacode

# Regenerate fonts cache
fc-cache -vf ~/.local/share/fonts/

if [[ $SHELL != "/usr/bin/zsh" ]]; then
  sudo apt install -y zsh
  chsh -s $(which zsh)
  # desktop session logout -- required to reload zsh
  gnome-session-quit
fi

# Brew System Package manager
#
# Install brew
BREW=$(which brew)
if [[ "$BREW" =~ "not found" ]] && [ ! -d /home/linuxbrew/.linuxbrew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Just
JUST=$(which just)
if [[ "$JUST" =~ "not found" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | sudo bash -s -- --to /usr/local/bin
fi

# ohmyzsh
if [ ! -d ~/.oh-my-zsh ]; then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZOXIDE=$(which zoxide)
if [[ "$ZOXIDE" =~ "not found" ]]; then
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

source $HOME/.zprofile
source $HOME/.zshrc


# Brew packages
#
TAPS=()
LIBS=()
CASKS=()
BREW_PKGS=$(brew list)
AWSCURL=$(echo $BREW_PKGS|grep awscurl)
if [[ "x$AWSCURL" = "x" ]]; then LIBS+=("awscurl") fi
FD=$(echo $BREW_PKGS|grep fd)
if [[ "x$FD" = "x" ]]; then LIBS+=("fd") fi
# https://github.com/ibraheemdev/modern-unix
DUST=$(echo $BREW_PKGS|grep dust)
if [[ "x$DUST" = "x" ]]; then LIBS+=("dust") fi
DOG=$(echo $BREW_PKGS|grep dog)
if [[ "x$DOG" = "x" ]]; then LIBS+=("dog") fi
GPING=$(echo $BREW_PKGS|grep gping)
if [[ "x$GPING" = "x" ]]; then LIBS+=("gping") fi
PROCS=$(echo $BREW_PKGS|grep procs)
if [[ "x$PROCS" = "x" ]]; then LIBS+=("procs") fi
DUF=$(echo $BREW_PKGS|grep duf)
if [[ "x$DUF" = "x" ]]; then LIBS+=("duf") fi
BAT=$(echo $BREW_PKGS|grep bat)
if [[ "x$BAT" = "x" ]]; then LIBS+=("bat") fi
EZA=$(echo $BREW_PKGS|grep eza)
if [[ "x$EZA" = "x" ]]; then LIBS+=("eza") fi
# https://github.com/dandavison/delta
GIT_DELTA=$(echo $BREW_PKGS|grep git-delta)
if [[ "x$GIT_DELTA" = "x" ]]; then LIBS+=("git-delta") fi
FVM=$(echo $BREW_PKGS|grep fvm)
if [ "x$FVM" = "x" ]; then
  TAPS+=("leoafarias/fvm")
  LIBS+=("fvm")
fi

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
  sudo snap install libreoffice --channel=stable
  # Archived as it does not comes with DDB support at the community version
  # sudo snap install dbeaver-ce
fi

# DNS
if [ ! -f /usr/local/bin/dnstest ]; then
  pushd /tmp
  git clone --depth=1 https://github.com/cleanbrowsing/dnsperftest/ /tmp/dnsperftest/
  sudo mv /tmp/dnsperftest/dnstest.sh /usr/local/bin/dnstest
  popd
fi

# Go
#
# TODO: gvm https://github.com/moovweb/gvm

JIRA=$(which jira)
if [[ "$JIRA" =~ "not found" ]]; then
  # https://github.com/ankitpokhrel/jira-cli
  go install github.com/ankitpokhrel/jira-cli/cmd/jira@latest
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
if [[ "x$NODE14" = "x" ]]; then
  nvm install 14
fi
NODE16=$(echo $NODE_VERSIONS|grep v16)
if [[ "x$NODE16" = "x" ]]; then
  nvm install 16
fi
NODE18=$(echo $NODE_VERSIONS|grep v18)
if [[ "x$NODE18" = "x" ]]; then
  nvm install 18
fi
NODE20=$(echo $NODE_VERSIONS|grep v20)
if [[ "x$NODE20" = "x" ]]; then
  nvm install 20
fi
NODE=$(which npm)
if [[ "$NODE" =~ "not found" ]]; then
  nvm alias default 16
fi
PNPM=$(which pnpm)
if [[ "$PNPM" =~ "not found" ]]; then
  npm i -g pnpm
fi

TLDR=$(which tldr)
if [[ "$TLDR" =~ "not found" ]]; then
  # https://github.com/tldr-pages/tldr
  npm i -g tldr
fi
NCU=$(which ncu)
if [[ "$NCU" =~ "not found" ]]; then
  npm i -g npm-check-updates
fi
CDK_DIA=$(which cdk-dia)
if [[ "$CDK_DIA" =~ "not found" ]]; then
  # https://github.com/pistazie/cdk-dia
  npm i -g cdk-dia
fi

# Ruby
#
# rbenv
RBENV_DIR=$HOME/.rbenv
if [ ! -d "$RBENV_DIR" ]; then
  git clone https://github.com/rbenv/rbenv.git $RBENV_DIR
  pushd ~/.rbenv && src/configure && make -C src && popd
  
  # ruby-build install
  mkdir -p $RBENV_DIR/plugins
  git clone https://github.com/rbenv/ruby-build.git $RBENV_DIR/plugins/ruby-build
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
  rbenv global 3.1.2
  rbenv rehash
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
PYTHON39=$(pyenv versions|grep 3.9)
if [ "x$PYTHON39" = "x" ]; then
  pyenv install 3.9.18
fi
PYTHON310=$(pyenv versions|grep 3.10)
if [ "x$PYTHON310" = "x" ]; then
  pyenv install 3.10
fi
PYTHON311=$(pyenv versions|grep 3.11)
if [ "x$PYTHON311" = "x" ]; then
  pyenv install 3.11
fi
PYTHON=$(python --version)
if [[ "$PYTHON" =~ "not found" ]]; then
  pyenv global 3.11
fi

# Virtualenv
#
VIRTUALENV=$(which virtualenv)
if [[ "$VIRTUALENV" =~ "not found" ]]; then
  pip install virtualenv
fi

# Poetry
#
POETRY=$(which poetry)
if [[ "$POETRY" =~ "not found" ]]; then
  curl -sSL https://install.python-poetry.org | python3 -
  source $HOME/.zshrc
  poetry config virtualenvs.in-project true
  pip install poetry-plugin-export
fi

CSVKIT=$(which csvkit)
if [[ "$CSVKIT" =~ "not found" ]]; then
  pip install csvkit
fi

ANSIBLE=$(which ansible)
if [[ "$ANSIBLE" =~ "not found" ]]; then
  python3 -m pip install --user ansible
fi

# Rust
#
RUSTUP=$(which rustup)
if [[ "$RUSTUP" =~ "not found" ]]; then
  # https://doc.bccnsoft.com/docs/rust-1.36.0-docs-html/edition-guide/rust-2018/rustup-for-managing-rust-versions.html
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs|sh -s -- -y
fi

# rust binaries
CARGO_LIBS=()
ZELLIJ=$(which zellij)
if [ "x$ZELLIJ" = "x" ] || [[ "$ZELLIJ" =~ "not found" ]]; then CARGO_LIBS+="zellij"; fi
TRIPPY=$(which trippy)
# TODO: set permissions https://github.com/fujiapple852/trippy
if [ "x$TRIPPY" = "x" ] || [[ "$TRIPPY" =~ "not found" ]]; then CARGO_LIBS+="trippy"; fi

if [ ${#CARGO_LIBS[@]} -gt 0 ]; then
  cargo install --locked $CARGO_LIBS
fi

# WASM
#
WASM=$(which wasmtime)
if [ "x$WASM" = "x" ]; then
  # https://github.com/bytecodealliance/wasmtime
  curl https://wasmtime.dev/install.sh -sSf | bash
fi

# Java
#
# sdkman
SDKMAN_DIR=$HOME/.sdkman
if [ ! -d $SDKMAN_DIR ]; then
  curl -s "https://get.sdkman.io" | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

JAVA_VERSIONS=$(sdk ls java|grep 'installed\|local')
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

KUBESEAL=$(which kubeseal)
if [[ "$KUBESEAL" =~ "not found" ]]; then
  KUBESEAL_VERSION='0.23.0'
  pushd /tmp
  wget "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION:?}/kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz"
  tar -xvzf kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz kubeseal
  sudo install -m 755 kubeseal /usr/local/bin/kubeseal
  popd
fi

K8SLENS=$(which lens-desktop)
if [[ "$K8SLENS" =~ "not found" ]]; then
  curl -fsSL https://downloads.k8slens.dev/keys/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/lens-archive-keyring.gpg > /dev/null
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/lens-archive-keyring.gpg] https://downloads.k8slens.dev/apt/debian stable main" | sudo tee /etc/apt/sources.list.d/lens.list > /dev/null
  sudo apt update && sudo apt install -y lens
fi

# helm package manager for k8s
HELM=$(which helm)
if [[ "$HELM" =~ "not found" ]]; then
  arkade get helm
fi

# Cloud
#
# aws-cli
AWS=$(which aws)
if [[ "$AWS" =~ "not found" ]]; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
  pushd /tmp
  unzip awscliv2.zip
  sudo ./aws/install -i /usr/local/aws2 -b /usr/local/bin
  popd
fi
AWS1=$(which aws1)
if [[ "$AWS1" =~ "not found" ]]; then
  curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "/tmp/awscli-bundle.zip"
  pushd /tmp
  unzip awscli-bundle.zip
  sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws1
  popd
fi

SAW=$(which saw)
if [[ "$SAW" =~ "not found" ]]; then
  wget https://github.com/TylerBrock/saw/releases/download/v0.2.2/saw_0.2.2_linux_amd64.deb
  sudo dpkg -i saw_0.2.2_linux_amd64.deb
  rm saw_0.2.2_linux_amd64.deb
fi

AWS_SSO=$(which aws-sso)
if [[ "$AWS_SSO" =~ "not found" ]]; then
  wget https://github.com/synfinatic/aws-sso-cli/releases/download/v1.9.10/aws-sso-cli_1.9.10-1_amd64.deb
  sudo dpkg -i aws-sso-cli_1.9.10-1_amd64.deb
fi

# gcloud
GCLOUD=$(which gcloud)
if [[ "$GCLOUD" =~ "not found" ]]; then
  wget "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-458.0.0-darwin-arm.tar.gz" -O /tmp/gcloud.tar.gz
  pushd /tmp
  tar xvzf gcloud.tar.gz -C ~/.local
  chmod -R 754 ~/.local/google-cloud-sdk
  chown -R $USER ~/.local/google-cloud-sdk
  pushd ~/.local/google-cloud-sdk
  ./install.sh
  popd
  popd
fi

# azure
AZURE=$(which az)
if [[ "$AZURE" =~ "not found" ]]; then
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi

# tfenv
TFENV_DIR=$HOME/.tfenv
if [ ! -d "$TFENV_DIR" ]; then
  git clone --depth=1 https://github.com/tfutils/tfenv.git $TFENV_DIR
  if [ "x$TFENV_ROOT" = "x" ]; then
    echo 'export TFENV_ROOT="$HOME/.tfenv"' >> ~/.zshrc
    echo 'export PATH="$TFENV_ROOT/bin:$PATH"' >> ~/.zshrc
  fi
fi

# terraform versions
TERRAFORM_144=$(tfenv list|grep "1.4.4")
if [ "x$TERRAFORM_144" = "x" ]; then
  tfenv install 1.4.4
  tfenv use 1.4.4
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

# HTTP clients
#
# INSOMNIA=$(which insomnia)
# if [[ "$INSOMNIA" =~ "not found" ]]; then
#   wget https://github.com/Kong/insomnia/releases/download/core%402023.4.0/Insomnia.Core-2023.2.0.deb
#   sudo dpkg -i Insomnia.Core-2023.2.0.deb
# fi
BRUNO=$(which bruno)
if [[ "$BRUNO" =~ "not found" ]]; then
  sudo mkdir -p /etc/apt/keyrings
  sudo gpg --no-default-keyring --keyring /etc/apt/keyrings/bruno.gpg --keyserver keyserver.ubuntu.com --recv-keys 9FA6017ECABE0266

  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/bruno.gpg] http://debian.usebruno.com/ bruno stable" | sudo tee /etc/apt/sources.list.d/bruno.list 

  sudo apt update
  sudo apt install bruno
fi

# Remote Desktop
#
RUSTDESK=$(which rustdesk)
if [[ "$RUSTDESK" =~ "not found" ]]; then
  wget https://github.com/rustdesk/rustdesk/releases/download/1.2.3/rustdesk-1.2.3-x86_64.deb -O /tmp/rustdesk-1.2.3-x86_64.deb
  sudo apt install -fy /tmp/rustdesk-1.2.3-x86_64.deb
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

# Docker
DOCKER=$(which docker)
if [[ "$DOCKER" =~ "not found" ]]; then
  sudo apt remove docker-desktop
  rm -r $HOME/.docker/desktop
  sudo rm /usr/local/bin/com.docker.cli
  sudo apt purge docker-desktop
  rm ~/.config/systemd/user/docker-desktop.service ~/.local/share/systemd/user/docker-desktop.service
  # add docker's official GPG key
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  # setup apt repository
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  # download and install
  wget "https://desktop.docker.com/linux/main/amd64/docker-desktop-4.11.0-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64"
  sudo apt-get install ./docker-desktop-4.11.0-amd64.deb
  # launch
  systemctl --user start docker-desktop
fi

LAZYDOCKER=$(which lazydocker)
if [[ "$LAZYDOCKER" =~ "not found" ]]; then
  curl "https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh" | bash
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

# Scripts
#
wget -O $HOME/bin/nDorker.py https://raw.githubusercontent.com/nerrorsec/Google-Dorker/master/nDorker.py