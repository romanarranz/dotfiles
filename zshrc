# ensure to only execute on ZSH
# https://stackoverflow.com/a/9911082/339302
[ ! -n "$ZSH_VERSION" ] && return

export ZSHCONFIG="${HOME}/.zsh-config"

if [[ "x$SYSTEM" = "xLinux" ]]; then
  # Fix rare Java Problem
  export _JAVA_AWT_WM_NONREPARENTING=1
fi

# Initialize zinit
source ~/.zinit/bin/zinit.zsh

# Load the shell dotfiles, and then some:
for file in ${ZSHCONFIG}/.{path,exports,bindings,functions,extra}; do [ -r "$file" ] && [ -f "$file" ] && source "$file"; done
unset file;

# Load aliases
source ${ZSHCONFIG}/aliases/.common
if [[ "x$SYSTEM" = "xDarwin"  ]]; then
  source ${ZSHCONFIG}/aliases/.macos

  ARCH=$(uname -m)
  if [ "$ARCH" = "arm64" ]; then
    # Homebrew installation patch https://github.com/Homebrew/discussions/discussions/446
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi
if [[ "x$SYSTEM" = "xLinux" ]]; then
  source ${ZSHCONFIG}/aliases/.linux
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

SHOPT=`which shopt`
if [ -z SHOPT ]; then
    shopt -s histappend        # Append history instead of overwriting
    shopt -s cdspell           # Correct minor spelling errors in cd command
    shopt -s dotglob           # includes dotfiles in pathname expansion
    shopt -s checkwinsize      # If window size changes, redraw contents
    shopt -s cmdhist           # Multiline commands are a single command in history.
    shopt -s extglob           # Allows basic regexps in bash.
fi
set ignoreeof on           # Typing EOF (CTRL+D) will not exit interactive sessions

# Load plugins
source "${ZSHCONFIG}/zplugins.zsh"

# Use modern completion system
# https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
case $SYSTEM in
  Darwin)
    if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
      compinit;
    else
      compinit -C;
    fi
    ;;
  Linux)
    # not yet match GNU & BSD stat
  ;;
esac

# required for load-nvmrc
autoload -U add-zsh-hook

# NVM
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(/bin/cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use >/dev/null 2>&1
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default >/dev/null 2>&1
  fi
}

if [ -d $HOME/.nvm ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

# RBENV
if [ -z $RBENV_ROOT ]; then
  export RBENV_ROOT="$HOME/.rbenv"
  export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
  eval "$(rbenv init -)"
fi

# PYENV
if [ -z $PYENV_ROOT ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  PYENV_VER=$(pyenv -v)
  if [[ $PYENV_VER =~ "pyenv 1." ]]; then
    eval "$(pyenv init -)"
  else
    eval "$(pyenv init --path)"
  fi
fi

# GO
if [ -z $GOPATH ]; then
  export GOPATH="$HOME/go"
  export PATH="$GOPATH/bin:$PATH"

  if [ ! -d $GOPATH ]; then
    mkdir -p $GOPATH
  fi
fi

# POETRY
if [ -d $HOME/.poetry ]; then
  export PATH="$HOME/.poetry/bin:$PATH"
fi

# ARKADE
export PATH=$PATH:$HOME/.arkade/bin/

# RUST
export PATH="$HOME/.cargo/bin:$PATH"

# JAVA
if [ -d $HOME/.sdkman ]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# AWS
if [[ "x$SYSTEM" = "xLinux" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# To reconfigure p10k run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Zoxide
eval "$(zoxide init zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Customize prompt
source ${ZSHCONFIG}/.prompt
