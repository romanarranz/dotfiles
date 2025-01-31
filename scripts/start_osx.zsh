#!/usr/bin/env zsh

ARCH=$(uname -p)
APPLE_CHIP="intel"
if [ "x$SYSTEM" = "xDarwin" ] && [ "$ARCH" = "arm" ]; then
  APPLE_CHIP="silicon"
fi

mkdir -p $HOME/bin
mkdir -p $HOME/.reminders
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
if [ "$XCODE" != "/Library/Developer/CommandLineTools" ] && [ "$XCODE" != "/Applications/Xcode.app/Contents/Developer" ]; then
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
BC=$(echo $BREW_PKGS|grep bc)
if [ "x$BC" = "x" ]; then LIBS+=("bc") fi
BIND=$(echo $BREW_PKGS|grep bind)
if [ "x$BIND" = "x" ]; then LIBS+=("bind") fi
REMIND=$(echo $BREW_PKGS|grep remind)
if [ "x$REMIND" = "x" ]; then LIBS+=("remind") fi
FFMPEG=$(echo $BREW_PKGS|grep ffmpeg)
if [ "x$FFMPEG" = "x" ]; then LIBS+=("ffmpeg") fi
JQ=$(echo $BREW_PKGS|grep jq)
if [ "x$JQ" = "x" ]; then LIBS+=("jq") fi
HELM=$(echo $BREW_PKGS|grep helm)
if [ "x$HELM" = "x" ]; then LIBS+=("helm") fi
GO=$(echo $BREW_PKGS|grep go)
if [ "x$GO" = "x" ]; then LIBS+=("go") fi
HEROKU=$(echo $BREW_PKGS|grep heroku)
if [ "x$HEROKU" = "x" ]; then
  TAPS+=("heroku/brew")
  LIBS+=("heroku")
fi
OPENSSL=$(echo $BREW_PKGS|grep openssl)
if [ "x$OPENSSL" = "x" ]; then LIBS+=("openssl") fi
EXIFTOOL=$(echo $BREW_PKGS|grep exiftool)
if [ "x$EXIFTOOL" = "x" ]; then LIBS+=("exiftool") fi
NCDU=$(echo $BREW_PKGS|grep ncdu)
if [ "x$NCDU" = "x" ]; then LIBS+=("ncdu") fi
PANDOC=$(echo $BREW_PKGS|grep pandoc)
if [ "x$PANDOC" = "x" ]; then LIBS+=("pandoc") fi
CMAKE=$(echo $BREW_PKGS|grep cmake)
if [ "x$CMAKE" = "x" ]; then LIBS+=("cmake") fi
POPPLER=$(echo $BREW_PKGS|grep poppler)
if [ "x$POPPLER" = "x" ]; then LIBS+=("poppler") fi
GNUSED=$(echo $BREW_PKGS|grep gnu-sed)
if [ "x$GNUSED" = "x" ]; then LIBS+=("gnu-sed") fi
READLINE=$(echo $BREW_PKGS|grep readline)
if [ "x$READLINE" = "x" ]; then LIBS+=("readline") fi
RGA=$(echo $BREW_PKGS|grep ripgrep-all)
if [ "x$RGA" = "x" ]; then LIBS+=("rga") fi
SQLITE=$(echo $BREW_PKGS|grep sqlite)
if [ "x$SQLITE" = "x" ]; then LIBS+=("sqlite3") fi
POSTGRES=$(echo $BREW_PKGS|grep postgres)
if [ "x$POSTGRES" = "x" ]; then LIBS+=("postgres") fi
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
BASICTEX=$(echo $BREW_PKGS|grep basictex)
if [ "x$BASICTEX" = "x" ]; then CASKS+=("basictex") fi
EZA=$(echo $BREW_PKGS|grep eza)
if [[ "x$EZA" = "x" ]]; then LIBS+=("eza") fi
KEYCASTR=$(echo $BREW_PKGS|grep keycastr)
if [ "x$KEYCASTR" = "x" ]; then CASKS+=("keycastr") fi
# Archived as it does not comes with DDB support at the community version
# DBEAVER_CE=$(echo $BREW_PKGS|grep dbeaver-community)
# if [ "x$DBEAVER_CE" = "x" ]; then CASKS+=("dbeaver-community") fi
COCOAPODS=$(echo $BREW_PKGS|grep cocoapods)
if [ "x$COCOAPODS" = "x" ]; then LIBS+=("cocoapods") fi
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
# https://github.com/awslabs/git-secrets
GIT_SECRETS=$(echo $BREW_PKGS|grep git-secrets)
if [ "x$GIT_SECRETS" = "x" ]; then LIBS+=("git-secrets") fi
# https://github.com/ajeetdsouza/zoxide
ZOXIDE=$(echo $BREW_PKGS|grep zoxide)
if [ "x$ZOXIDE" = "x" ]; then LIBS+=("zoxide") fi
GRAPHVIZ=$(echo $BREW_PKGS|grep graphviz)
if [ "x$GRAPHVIZ" = "x" ]; then LIBS+=("graphviz") fi
CHROME_EXPORT=$(echo $BREW_PKGS|grep chrome-export)
if [ "x$CHROME_EXPORT" = "x" ]; then LIBS+=("chrome-export") fi
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
AZURE=$(echo $BREW_PKGS|grep azure-cli)
if [ "x$AZURE" = "x" ]; then LIBS+=("azure-cli") fi
# Updated version of bash
BASH=$(echo $BREW_PKGS|grep bash)
if [ "x$BASH" = "x" ]; then LIBS+=("bash") fi
# Networking
MTR=$(echo $BREW_PKGS|grep mtr)
if [ "x$MTR" = "x" ]; then LIBS+=("mtr") fi
IPCALC=$(echo $BREW_PKGS|grep ipcalc)
if [ "x$IPCALC" = "x" ]; then LIBS+=("ipcalc") fi
WEBSOCAT=$(echo $BREW_PKGS|grep websocat)
if [ "x$WEBSOCAT" = "x" ]; then LIBS+=("websocat") fi
GREPCIDR=$(echo $BREW_PKGS|grep grepcidr)
if [ "x$GREPCIDR" = "x" ]; then LIBS+=("grepcidr") fi
# https://github.com/theZiz/aha
AHA=$(echo $BREW_PKGS|grep aha)
if [ "x$AHA" = "x" ]; then LIBS+=("aha") fi
JUST=$(echo $BREW_PKGS|grep just)
if [ "x$JUST" = "x" ]; then LIBS+=("just") fi
BRUNO=$(echo $BREW_PKGS|grep bruno)
if [ "x$BRUNO" = "x" ]; then LIBS+=("bruno") fi
PROTOC=$(echo $BREW_PKGS|grep protobuf)
if [ "x$PROTOC" = "x" ]; then LIBS+=("protobuf") fi
TELNET=$(echo $BREW_PKGS|grep telnet)
if [ "x$TELNET" = "x" ]; then LIBS+=("telnet") fi
FVM=$(echo $BREW_PKGS|grep fvm)
if [ "x$FVM" = "x" ]; then
  TAPS+=("leoafarias/fvm")
  LIBS+=("fvm")
fi
# cloud(aws): cloudwatch logs
SAW=$(echo $BREW_PKGS|grep saw)
if [ "x$SAW" = "x" ]; then
  TAPS+=("TylerBrock/saw")
  LIBS+=("saw")
fi
SSO=$(echo $BREW_PKGS|grep aws-sso-cli)
if [ "x$SSO" = "x" ]; then
  LIBS+=("aws-sso-cli")
fi
TERRAFORM=$(echo $BREW_PKGS|grep terraform)
if [ "x$TERRAFORM" = "x" ]; then
  TAPS+=("hashicorp/tap")
  LIBS+=("hashicorp/tap/terraform")
fi
JIRA=$(echo $BREW_PKGS|grep jira-cli)
if [ "x$JIRA" = "x" ]; then
  TAPS+=("ankitpokhrel/jira-cli")
  LIBS+=("jira-cli")
fi
WIREGUARD=$(echo $BREW_PKGS|grep wireguard-tools)
if [ "x$WIREGUARD" = "x" ]; then
  LIBS+=("wireguard-tools")
fi
KUBESEAL=$(echo $BREW_PKGS|grep kubeseal)
if [ "x$KUBESEAL" = "x" ]; then
  LIBS+=("kubeseal")
fi
SHELLCHECK=$(echo $BREW_PKGS|grep shellcheck)
if [ "x$SHELLCHECK" = "x" ]; then
  LIBS+=("shellcheck")
fi
HTTRACK=$(echo $BREW_PKGS|grep httrack)
if [ "x$HTTRACK" = "x" ]; then
  LIBS+=("httrack")
fi
LEDGER=$(echo $BREW_PKGS|grep ledger)
if [ "x$LEDGER" = "x" ]; then
  LIBS+=("ledger")
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

FZF=$HOME/.fzf
if [ ! -d  "$FZF" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

# DNS
if [ ! -f "/usr/local/bin/dnstest" ]; then
  pushd /tmp
  if [ -d "/tmp/dnsperftest/" ]; then rm -rf /tmp/dnsperftest; fi
  git clone --depth=1 https://github.com/cleanbrowsing/dnsperftest/ /tmp/dnsperftest/
  sudo mv /tmp/dnsperftest/dnstest.sh /usr/local/bin/dnstest
  popd
fi

# Symlinks
if [ ! -f /usr/local/bin/sed ]; then
  sudo ln -s $(which gsed) /usr/local/bin/sed
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

# Golang
#
if [ -z $GOPATH ]; then
  export GOPATH="$HOME/go"
  mkdir -p $GOPATH
fi

# golang binaries
PNG2SVG=$(which png2svg)
if [ "x$PNG2SVG" = "x" ] || [[ "$PNG2SVG" =~ "not found" ]]; then
  go install github.com/xyproto/png2svg/cmd/png2svg@latest
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
PYTHON38=$(pyenv versions|grep 3.8)
if [ "x$PYTHON38" = "x" ] && [ $APPLE_CHIP = "silicon" ]; then
  # https://github.com/pyenv/pyenv/issues/1768#issuecomment-753756051
  curl -sSL https://raw.githubusercontent.com/Homebrew/formula-patches/113aa84/python/3.8.3.patch\?full_index\=1|pyenv install --patch 3.8.6
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
if [ "x$POETRY" = "x" ]; then
  curl -sSL https://install.python-poetry.org | POETRY_HOME=$HOME/.poetry python3 -
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

# rust binaries
CARGO_LIBS=()
ZELLIJ=$(which zellij)
if [ "x$ZELLIJ" = "x" ] || [[ "$ZELLIJ" =~ "not found" ]]; then CARGO_LIBS+="zellij"; fi
TRIPPY=$(which trip)
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

# Flutter https://docs.flutter.dev/development/tools/sdk/releases
#
# fvm
FLUTTER332=$(fvm list|grep 3.3.2)
if [ "x$FLUTTER332" = "x" ]; then
  fvm install 3.3.2
  fvm global 3.3.2
  source $HOME/.zshrc
  # disable desktop support
  flutter config --no-enable-macos-desktop
  flutter config --no-enable-windows-desktop
  flutter config --no-enable-linux-desktop
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
# aws-cli
AWS=$(which aws)
if [ "x$AWS" = "x" ]; then
  pip3 install awscli

  # Session Manager Plugin https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
  if [ ! -d "/usr/local/sessionmanagerplugin" ]; then
    curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"
    unzip sessionmanager-bundle.zip
    sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
  fi
fi

AWS2=$(which /usr/local/bin/aws)
if [ "x$AWS2" = "x" ]; then
  curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  sudo installer -pkg AWSCLIV2.pkg -target /
  alias aws2=/usr/local/bin/aws
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

# tfenv
TFENV=$(which tfenv)
if [ "x$TFENV" = "x" ]; then
  brew install tfenv
fi

# terraform versions
TERRAFORM_144=$(tfenv list|grep "1.4.4")
if [ "x$TERRAFORM_144" = "x" ]; then
  tfenv install 1.4.4
  tfenv use 1.4.4
fi

# Logs
#
LNAV=$(which lnav)
if [[ "$LNAV" =~ "not found" ]]; then
  wget "https://github.com/tstack/lnav/releases/download/v0.11.2/lnav-0.11.2-x86_64-linux-musl.zip" -O /tmp/lnav.zip
  pushd /tmp
  unzip lnav.zip
  cd lnav-0.11.2
  sudo mv lnav /usr/local/bin/
  popd
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

# YoutubeDL
#
# https://github.com/ytdl-org/youtube-dl

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