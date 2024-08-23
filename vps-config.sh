#! /bin/bash

# from-scratch install of a solid terminal experience for vanilla (ubuntu) VPSs

version="0.0.1"

brewapps="zsh micro stow zsh-autosuggestions zsh-syntax-highlighting eza zoxide tldr starship"

echo "
******************************************************************
Welcome to the Environment install script, version ${version}.
This script is for vanilla VPS installs, running bash,
without zsh or homebrew.
******************************************************************
"

echo "Checking if Homebrew is installed..."

if [[ -d $(brew --prefix) ]]; then
  brewfolder=$(brew --prefix)
  echo "Homebrew is installed, we found the install directory at ${brewfolder}. Skipping installation."
  exit
fi

echo "No Homebrew found, installing..."

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Homebrew installed. Adding it to .bashrc..."

test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc

# reload bash to recognize homebrew
source ~/.bashrc

echo "Installing our programs..."

brew install ${brewapps}


echo "Setting zsh as default shell..."

echo $(which zsh) | sudo tee -a /etc/shells
sudo chsh -s $(which zsh) $USER

echo "symlinking dotfiles with stow..."

stow .

echo "Done! Switching to zsh..."

exec $SHELL