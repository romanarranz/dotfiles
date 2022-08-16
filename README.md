# Roman's dotfiles

The configurations are for my Linux/macOS workstation and therefore contain some Linux/macOS-specific code and commands.

![](./assets/prompt.png)

## Quick Start

Install zsh

```
# macOS
brew install zsh
chsh -s /usr/local/bin/zsh
# Linux
apt install zsh
```

Clone this repository

```
# get to the home folder
$ cd

# pull the git repos
$ git clone https://github.com/romanarranz/dotfiles.git .zsh-config
```

Install dependencies

```
$ ./.zsh-config/starters/start_linux.zsh

# then link the startup files
$ zsh ~/.zsh-config/bootstrap.zsh

# add gitconfig options
$ cat  ~/.zsh-config/config/.gitconfig >> ~/.gitconfig
```

## Programming languages setup

Python dual setup for version 2 and 3

```
pyenv global 3.9.4 2.7.18
```

## Credits

- https://github.com/mathiasbynens/dotfiles
- https://github.com/htr3n/zsh-config
- https://github.com/broucz/dotfiles
- https://github.com/thoughtbot/dotfiles