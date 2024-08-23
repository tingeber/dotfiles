#!/bin/bash

# from-scratch install of a solid terminal experience for vanilla (ubuntu) VPSs

# if any command fails, we exit
set -eo pipefail

# Global variables
version="0.0.1"
brewapps="zsh micro stow zsh-autosuggestions zsh-syntax-highlighting eza zoxide tldr starship"
brewfolder="/home/linuxbrew/.linuxbrew"
user="tin"


echo "
******************************************************************
Welcome to the Environment install script, version ${version}.
This script is for vanilla VPS installs on Debian/Ubuntu, running bash,
without zsh or homebrew.
******************************************************************
"

echo "installing pre-requisite apps..."
sudo apt-get install -y build-essential procps curl file git && echo "Done."

echo "Checking if Homebrew is installed..."

if [[ -d $(brew --prefix) ]]; then
  brewfolder=$(brew --prefix)
  echo "Homebrew is installed, we found the install directory at ${brewfolder}. Skipping installation."
else
  echo "No Homebrew found, installing..."
  # since we're running this entire script with sudo, we downgrade to regular user for the homebrew install
  # Homebrew does not allow to be installed as root
  # Adding CI=1 in front of the script should recognize passwordless sudo
  # thanks to https://github.com/Homebrew/install/issues/612

  CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
  && echo "Homebrew installed. Adding it to .bashrc..."

  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc

  # reload bash to recognize homebrew
  source ~/.bashrc

  echo "Installing our programs..."

  brew install ${brewapps}
fi

echo "symlinking dotfiles with stow..."
stow . && echo "Done."

echo "Setting zsh as default shell..."
echo $(which zsh) | sudo tee -a /etc/shells
sudo usermod --shell $(which zsh) ${user} && echo "Done."

echo "The script is done! Remember to run 'exec zsh' to change into the custom shell."