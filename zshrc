# ensure to only execute on ZSH
# https://stackoverflow.com/a/9911082/339302
[ ! -n "$ZSH_VERSION" ] && return

export ZSHCONFIG="${HOME}/.zsh-config"

# Initialize zinit
source ~/.zinit/bin/zinit.zsh

# Load the shell dotfiles, and then some:
for file in ${ZSHCONFIG}/.{path,exports,aliases,bindings,functions,extra}; do [ -r "$file" ] && [ -f "$file" ] && source "$file"; done
unset file;

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

# To reconfigure p10k run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Customize prompt
source ${ZSHCONFIG}/.prompt