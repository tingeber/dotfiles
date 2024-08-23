#! /bin/bash

# from-scratch install of a solid terminal experience for vanilla (ubuntu) VPSs

version="0.0.1"

brewapps="zsh micro stow zsh-autosuggestions zsh-syntax-highlighting eza zoxide tldr starship"

brewfolder="/home/linuxbrew/.linuxbrew"

git clone https://github.com/Homebrew/brew

echo "
******************************************************************
Welcome to the Environment install script, version ${version}.
This script is for vanilla VPS installs on Debian/Ubuntu, running bash,
without zsh or homebrew.
******************************************************************
"

echo "installing pre-requisite apps..."
apt-get install -y build-essential procps curl file git

echo "Checking if Homebrew is installed..."

if [[ -d $(brew --prefix) ]]; then
  brewfolder=$(brew --prefix)
  echo "Homebrew is installed, we found the install directory at ${brewfolder}. Skipping installation."
  exit
fi

echo "No Homebrew found, installing..."

echo "Creating Homebrew directory..."
mkdir -p ${brewfolder}

echo "Cloning Homebrew into Homebrew directory..."
git clone https://github.com/Homebrew/brew ${brewfolder}

echo "Homebrew installed. Adding it to .bashrc..."

test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc

echo "Updating Homebrew..."
brew update --force --quiet
# chmod -R go-w "$(brew --prefix)/share/zsh"

# reload bash to recognize homebrew
source ~/.bashrc

echo "Installing our programs..."

brew install ${brewapps}

echo "Setting zsh as default shell..."

echo $(which zsh) | tee -a /etc/shells
chsh -s $(which zsh) $USER

echo "symlinking dotfiles with stow..."

stow .

echo "Done! Switching to zsh..."

exec $SHELL