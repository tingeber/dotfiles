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
  exit 1
fi

echo "No Homebrew found, installing..."

# echo "Creating Homebrew directory..."
# sudo mkdir -p ${brewfolder}
# echo "Cloning Homebrew into Homebrew directory..."
# sudo curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components 1 -C ${brewfolder}


# since we're running this entire script with sudo, we downgrade to regular user for the homebrew install
# Homebrew does not allow to be installed as root
# Adding CI=1 in front of the script should recognize passwordless sudo
# thanks to https://github.com/Homebrew/install/issues/612

sudo -u ${user} \
CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
&& echo "Homebrew installed. Adding it to .bashrc..."

test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc

# reload bash to recognize homebrew
source ~/.bashrc

echo "Installing our programs..."

brew install ${brewapps}

# echo "Setting zsh as default shell..."

echo $(which zsh) | tee -a /etc/shells
chsh -s $(which zsh) $USER

echo "symlinking dotfiles with stow..."

stow .

echo "Done! Switching to zsh..."

exec $SHELL