# dotfiles and dev environment

This readme assumes you're on a Mac and are running Homebrew. For installing on other distros, check documentation.



## First things first

Make sure you're using `zsh` as your main shell. Here's a gist for you: https://gist.github.com/derhuerst/12a1558a4b408b3b2b6e. If it's out of date, ask the internet.

Make sure you have installed [homebrew](brew.sh), then install git and stow (follow this [youtube tutorial](https://www.youtube.com/watch?v=y6XCebnB9gs))


```sh
brew install git
brew install stow
```

Set up git and stow as you would.

# Terminal tools
Thanks Josean for the tutorial: https://www.josean.com/posts/how-to-setup-alacritty-terminal

## QoL tools

`.zshrc` in this dotfiles repo is already set up for these tools:

```sh
brew install zsh-autosuggestions zsh-syntax-highlighting eza zoxide
```

## Fonts
We're using Meslo [Nerd Font](https://www.nerdfonts.com/).

```sh
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font
```


## PowerLevel10k
I stopped using ohmyzsh, easier to run the small list of apps directly, esp with this readme.

```sh
brew install powerlevel10k
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
source ~/.zshrc
```

you can run the wizard again with `p10k configure`

## check if arrow keys are working

If on a Mac, the bind keys shoud be correct. If on another distro, run `cat -v`, press up and down arrow keys, copy the output and update these lines in `.zshrc`:

```sh
# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
```

## [TODO]
- set up `tmux`
