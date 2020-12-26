# ensure to only execute on ZSH
# https://stackoverflow.com/a/9911082/339302
[ ! -n "$ZSH_VERSION" ] && return

export ZSHCONFIG="${HOME}/.zsh-config"

# Initialize zinit
source ~/.zinit/bin/zinit.zsh

# Load plugins
source "$ZSHCONFIG/zplugins.zsh"

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

# PYENV
if [ -z $PYENV_ROOT ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"

    if command -v pyenv 1>/dev/null 2>&1; then
      _evalcache pyenv init -
    fi
fi

# RUST
export PATH="$HOME/.cargo/bin:$PATH"
