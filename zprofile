# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
unset file;

# eliminates duplicates in *paths
typeset -gU cdpath fpath path

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Zsh search path for executable
path=(
  /usr/local/{bin,sbin}
  $path
)