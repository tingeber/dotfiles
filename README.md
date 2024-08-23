# dotfiles and dev environment

## Vanilla VPS installs

This script is set up and tested on Hetzner Cloud, on a VPS running Ubuntu, with a non-root user with passwordless sudo privileges. If you're runnning `cloud-init` you can adapt my `cloud-config.yaml` to set the VPS up.

### Pre-requisites

- Git

### Steps

- If you're not me, change the `user` variable to your username on the VPS
- `git pull` this repo into your home directory `~`
- `bash vps-config.sh` (no `sudo`!)
- Drink some water while you wait, I'm sure you're dehydrated
- when the script ends, run `exec zsh` to switch over to the shell that's been set up for you.

# Mac installs

Make sure you're using `zsh` as your main shell. Here's a gist for you: https://gist.github.com/derhuerst/12a1558a4b408b3b2b6e. If it's out of date, ask the internet.

Make sure you have installed [homebrew](brew.sh), then install git and stow (follow this [youtube tutorial](https://www.youtube.com/watch?v=y6XCebnB9gs))

### Install git and stow

```sh
brew install git stow
```

### Install other useful programs

```sh
brew install zsh-autosuggestions zsh-syntax-highlighting eza zoxide gh
```

Clone this repo inside your home folder and run stow from it:

```sh
cd ~/
git clone git@github.com:tingeber/dotfiles.git
cd dotfiles
stow .
```

# Terminal tools

Thanks Josean for the tutorial: https://www.josean.com/posts/how-to-setup-alacritty-terminal

## QoL tools

`.zshrc` in this dotfiles repo is already set up for `zsh-autosuggestions zsh-syntax-highlighting eza zoxide`

## Fonts

Let's get our fonts figured out first. We're using Meslo [Nerd Font](https://www.nerdfonts.com/).

On Mac:

```sh
brew install --cask font-meslo-lg-nerd-font
```

On linux:

```sh
brew tap homebrew/linux-fonts
brew install font-meslo-lg-nerd-font
```

## Terminal setup

I'm currently using WezTerm, and there is a config file for it in the dotfiles. `stow` will put it where it needs to go.

## Starship

```sh
brew install starship
```

There is already a configuration `.toml` that I've been working on for a bit. Feel free to use it, Not Me.

## check if arrow keys are working

If on a Mac, the bind keys shoud be correct. If on another distro, run `cat -v`, press up and down arrow keys, copy the output and update these lines in `.zshrc`:

```sh
# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
```

## [TODO]

- set up `tmux`
