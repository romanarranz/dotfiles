#!/bin/bash

# APT
sudo add-apt-repository ppa:umang/indicator-stickynotes -y
sudo apt update && apt upgrade -y
sudo apt install -y build-essential \
        g++ \
        gcc \
        make \
        net-tools \
        arping \
        openssl \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        wget \
        curl \
        llvm \
        libncurses5-dev \
        xz-utils \
        tk-dev \
        libxml2-dev \
        libxmlsec1-dev \
        libffi-dev \
        liblzma-dev \
        whois \
        zlib1g-dev \
        git \
        ssh \
        ffmpeg \
        vlc \
        jq \
        zsh \
        ripgrep \
        pandoc \
        tree \
        poppler-utils \
        xclip \        
        obs-studio \
        fonts-powerline \
        indicator-stickynotes
        apt-transport-https \
        gnupg

# Terminal
#
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# bullet-train.zsh-theme
wget https://raw.githubusercontent.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme -O $ZSH_CUSTOM/themes/bullet-train.zsh-theme
# fonts
git clone https://github.com/powerline/fonts.git --depth=1 /tmp/fonts && pushd /tmp/fonts && ./install.sh && popd && rm -rf /tmp/fonts

# YoutubeDL
#
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl

# Node
#
# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
. ~/.bashrc 
nvm install 10
nvm install 12
nvm use 12

# Python
#
# pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
. ~/.bashrc
pyenv install 3.6.2
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
# poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

# Java
#
# sdkman!
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java

# Rust
#
sudo apt install -y cargo

# Openfaas
# 
# arkade
curl -sLS https://dl.get-arkade.dev | sudo sh
echo 'export PATH="$PATH:$HOME/.arkade/bin/"' >> ~/.bashrc
# faas
arkade get faas-cli
# k3sup
pushd /tmp 
curl -sLS https://get.k3sup.dev | sh
sudo install k3sup /usr/local/bin/
popd

# Kubernetes (K8S)
#
# kubectl
arkade get kubectl
echo 'export KUBECONFIG=$HOME/kubeconfig' >> ~/.bashrc
sudo wget https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail -O /usr/bin/kubetail
sudo chmod 755 /usr/bin/kubetail
# helm package manager for k8s
arkade get helm

# Docker
#
# docker - https://docs.docker.com/engine/install/debian/
sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) test"
sudo apt install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
sudo docker run hello-world
echo "`docker` can be used without sudo on next restart"
# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
# docker-compose command completion
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.27.4/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

# HTTP clients
#
sudo snap install insomnia

# Cloud
#
pip3 install awscli

# Browsers
# 
# chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb && sudo dpkg -i /tmp/chrome.deb
# brave
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# Alias
#
# kubernetes
echo "alias k=\"kubectl\"" >> ~/.zshrc

# Browsers (plugins)
# 
# bypass-paywalls-chrome
mkdir -p ~/ChromeExtensions \
&& pushd ~/ChromeExtensions \
&& wget https://github.com/iamadamdev/bypass-paywalls-chrome/archive/master.zip \
&& unzip master.zip \
&& rm master.zip \
&& echo -e "\n[Chrome Plugin] bypass-paywalls-chrome: requires manual setup -> chrome://extensions -> Enable Develper mode -> Drag this folder there" \
&& popd


# Utils
#
# rga - https://github.com/phiresky/ripgrep-all
pushd /tmp \
&& wget https://github.com/phiresky/ripgrep-all/releases/download/v0.9.6/ripgrep_all-v0.9.6-x86_64-unknown-linux-musl.tar.gz -O ripgrep_all.tar.gz \
&& mkdir -p ripgrep_all \
&& tar xvzf /tmp/ripgrep_all.tar.gz -C ripgrep_all \
&& rm ripgrep_all.tar.gz \
&& sudo mv ripgrep_all/**/rga /usr/bin \
&& sudo mv ripgrep_all/**/rga-preproc /usr/bin \
&& rm -r ripgrep_all \
&& popd
#
# ncu
npm i -g npm-check-updates
# Wireshark
sudo apt install Wireshark
sudo usermod -aG wireshark $(whoami)
# vegeta
pushd /tmp
wget -c https://github.com/tsenart/vegeta/releases/download/v12.8.4/vegeta_12.8.4_linux_amd64.tar.gz -O - | tar -xz
sudo mv vegeta /usr/local/bin
popd
# nordvpn
pushd /tmp
wget https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb
sudo apt install nordvpn-release_1.0.0_all.deb
sudo apt update
sudo apt install nordvpn