setopt promptsubst

# zsh-zprof
zinit ice atinit'zmodload zsh/zprof' \
    atload'zprof | head -n 20; zmodload -u zsh/zprof'

# # sudo.zsh -- press twice "esc" key to prefix your command with `sudo`
# zinit ice wait
# zinit snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

# zsh-nvm
zinit ice wait"1" lucid
zinit light lukechilds/zsh-nvm

# zsh-completions
zplugin ice wait"0" lucid
zplugin light zsh-users/zsh-completions

# zsh-history-substring-search, must load it otherwise bindkeys won't work
# zplugin ice wait"0" lucid
zplugin light zsh-users/zsh-history-substring-search

# zsh-autosuggestions
zinit ice wait lucid atload"!_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# evalcache
zinit light mroth/evalcache

# git
zinit wait lucid for \
        OMZL::git.zsh \
  atload"unalias grv" \
        OMZP::git

# fast-syntax-hightlighting + colored-man-pages + docker completion
zinit wait lucid for \
  atinit"zicompinit; zicdreplay"  \
        zdharma-continuum/fast-syntax-highlighting \
      OMZP::colored-man-pages \
  as"completion" \
        OMZP::docker/_docker

# git-extras
zinit ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX" nocompile
zinit light tj/git-extras

# ogham/exa also uses the definitions
zinit ice wait"0c" lucid reset \
    atclone"local P=${${(M)OSTYPE:#*darwin*}:+g}
            \${P}sed -i \
            '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
            \${P}dircolors -b LS_COLORS > c.zsh" \
    atpull'%atclone' pick"c.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'

# LS_COLORS
zinit light trapd00r/LS_COLORS

# ogham/exa, replacement for ls
zinit ice wait"2" lucid from"gh-r" as"program" mv"exa* -> exa"
zinit light ogham/exa

# nnn, a file browser
# zinit pick"misc/quitcd/quitcd.bash_zsh" sbin"nnn" make light-mode for jarun/nnn

# theme: powerlevel10k
zinit light romkatv/powerlevel10k