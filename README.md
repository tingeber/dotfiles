# dotfiles for a pretty and sane dev environment

Do you spend time in the terminal? Are you, like me, obsessively tweaking the terminal so it doesn’t look and feel like you’re talking to a 1984 typewriter? Are you looking for a sane set of simple, pretty quality of life programs and a pleasing, calm UI that gets out of your way? Do you work with remote servers, and want them to behave exactly the same as your main comp?

This repo is for you (and me). It's a set of config (dot) files that define and customize my terminal environment.

## My dotfile manifesto

- If it can be installed with `brew`, it will be installed with `brew`
- As identical as possible across operating systems
- When customizing, I prefer tools I fully control through a config file
- as simple as possible
- fewest moving pieces
- as automated as possible

## My tools

| Tool                | MacOS            | Linux                |
| ------------------- | ---------------- | -------------------- |
| **Shell**           | zsh              | zsh                  |
| **Terminal**        | WezTerm          | n.a. (remote access) |
| **Nerd Font**       | Meslo LG         | Meslo LG             |
| **Package Manager** | Homebrew         | Homebrew             |
| **Theme**           | Catpuccin Frappé | Catpuccin Frappé     |
| **Prompt UI**       | Starship         | Starship             |

### Zsh

My main computer is a Mac so I got used to Zsh since Mac OS set it as default. It's also where I started discovering the joys of customization thanks to `oh-my-zsh`. I don't use it anymore; it's great but I prefer writing my own custom configs, and I don't need all the bells and whistles it has.

These are the quality of life tools I use to improve my terminal experience:

- [eza](https://eza.rocks): a modern replacement for `ls` with more features and better defaults
- [zoxide](https://github.com/ajeetdsouza/zoxide): a smarter `cd` that remembers your most visited folders, and makes traversing directories more fun
- [tldr](https://tldr.sh): awesome short condensed replacement for `--help` and `man` pages. For when you just need a quick reminder how `curl` works
- [micro](https://micro-editor.github.io): a file editor for the Terminal that acts like a desktop app so i don't have to memorize new shortcuts. I mean, one day I will fully commit to Neovim, but that day isn't today
- [Starship](https://starship.rs): cross-platform customizable prompt. I used to use `p10k` as a plugin for `oh-my-zsh`, then I removed `oh-my-zsh` and ran vanilla `p10k`, then I discovered Starship and, after a couple of rocky starts, I fully committed. Again, mainly because it's fully customizable through a text config file.
- [stow](https://www.gnu.org/software/stow/manual/stow.html): a symlink manager. This tiny utility makes this whole dotfiles thing work.

### Let's talk about `stow`

So stow really makes all of this work. it’s super simple, as long as your `dotfiles` folder is in your home holder, you just run `stow .` from the dotfiles folder once and it symlinks everything for you.

```bash
cd ~/dotfiles
stow .
```

If at some point you change, remove, or add stuff to dotfiles, just run `stow —restow .` and it will update all symlinks for you.

```bash
cd ~/dotfiles
stow --restow .
```

The default for stow is super simple - it looks at any file it finds in the directory, and creates symlinks 'one step up'. That's it, and that's 99% of the job done. There are also ways to ignore files by using a `.stow-local-ignore` file, though stow already knows not to symlink things like a `README` or a `.gitignore`.

This way you have your `dotfiles` folder that is clean and simple and manageable, without having to deal with the chaos of the home folder.

### WezTerm

I switched to WezTerm from iTerm2 because it is much, much simpler and it's super customizable with a simple text config file.

### Nerd Font

There's something _just right_ about Meslo Nerd. I think it's the ligatures.

### Homebrew

Honestly, if I could run my washing machine with Homebrew, I would. Super well defined and documented, and the Mac OS - Linux feature parity means I get to use the same commands across platforms.

### Catpuccin Frappé

I love the pastels and the super sensible palette. I especially love that Catpuccin has theme presets for pretty much any themeable software in existence, so I can have the same styles from WezTerm to Starship.

## Remote VPS installs

> I run this script whenever I create a new machine. It is set up and tested on Hetzner Cloud, on a VPS running Ubuntu, with a non-root user with passwordless sudo privileges. If you're runnning `cloud-init` you can adapt my `cloud-config.yaml` to set the VPS up.

### Pre-requisites

- Git

### Steps

- If you're not me, change the `user` variable to your username on the VPS
- `git pull` this repo into your home directory `~`
- `bash vps-config.sh` (no `sudo`!)
- Drink some water while you wait, I'm sure you're dehydrated
- when the script ends, run `exec zsh` to switch over to the shell that's been set up for you.

# Mac installs

Hello, friend

## Pre-requisites

- Make sure you're using `zsh` as your main shell. You probably are: MacOS ships with `zsh` enabled by default. Here's a gist for you: https://gist.github.com/derhuerst/12a1558a4b408b3b2b6e.
- Make sure you have installed [homebrew](brew.sh):

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install all apps:

```sh
brew install wezterm git stow zsh-autosuggestions zsh-syntax-highlighting eza zoxide gh starship
```

Clone this repo inside your home folder and run stow from it:

```sh
cd ~/
git clone git@github.com:tingeber/dotfiles.git
cd dotfiles
stow .
```

Install your Nerd Font. I'm using Meslo LGS [Nerd Font](https://www.nerdfonts.com/) but you can pick any other nerd font you like. Make sure you're _not_ using the "Mono" version of your font because the symbols and icons won't resize properly. Once you pick your font, make sure to update WezTerm's config file.

On Mac:

```sh
brew install --cask font-meslo-lg-nerd-font
```

On linux:

```sh
brew tap homebrew/linux-fonts
brew install font-meslo-lg-nerd-font
```

Open WezTerm and it should automatically pick up its config file, and the terminal UI should automatically load all our configs from the `.zshrc` file.

# Special thanks

- Thanks Josean for the tutorial: https://www.josean.com/posts/how-to-setup-alacritty-terminal
- CJ for the awesome "Mac from Scratch" video (link)
