setopt appendhistory extendedglob
unsetopt beep
bindkey -v

# eliminates duplicates in *paths
typeset -gU cdpath fpath path

# Zsh search path for executable
path=(
  /usr/local/{bin,sbin}
  $path
)

if [[ "x$SYSTEM" = "xLinux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi