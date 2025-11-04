#!/bin/bash

# from-scratch install of a solid terminal experience for vanilla (ubuntu) VPSs.
# This install script should be run without sudo, by a non-root user with passwordless sudo privileges

# if any command fails, we exit
set -eo pipefail

# Global variables
version="0.2"
brewapps="zsh micro stow zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search eza zoxide tlrc starship"
brewfolder="/home/linuxbrew/.linuxbrew"
user="tin" #change to your username on the VPS.

# Global Functions

# Formatting:
# colors: 1 = red, 2 = green, 3 = yellow, 4 = blue, 5 = pink, 6 = teal

echomain() {
  tput setaf 4
  tput bold
  echo "> $1"
  tput sgr0
}

echoyay() {
  tput setaf 6
  echo "> $1"
  tput sgr0
}

echofail() {
  tput setaf 1
  echo "> $1"
  tput sgr0
}

echomain "###############################################################"
echomain "Welcome to the Environment install script, version ${version}."
echomain "Checking if you're a regular user..."
echomain "###############################################################"


if [ $(id -u) == 0 ]
  then echofail "Please run this script as a non-root user or without sudo. Exiting..."
  exit 1
  else echoyay "You are! We can proceed."
fi

# checking if we're running on Linux:
if [[ ! "$(uname)" == "Linux" ]]; then
  echofail "This script is for Linux VPS, and this computer is running $(uname). Exiting..."
  exit 1
fi


# checking if we're running on Linux:
if [[ ! "$(uname)" == "Linux" ]]; then
  echofail "This script is for Linux VPS, and this computer is running $(uname). Exiting..."
  exit 1
fi

echo "installing pre-requisite apps..."
sudo apt-get install -y build-essential procps curl file git && echoyay "Done."

echomain "Checking if Homebrew is installed..."

if [[ -d $(brew --prefix) ]]; then
  brewfolder=$(brew --prefix)
  echofail "Homebrew is installed, we found the install directory at ${brewfolder}. Skipping installation."
else
  echoyay "No Homebrew found, installing..."
  # since we're running this entire script with sudo, we downgrade to regular user for the homebrew install
  # Homebrew does not allow to be installed as root
  # Adding CI=1 in front of the script should recognize passwordless sudo
  # thanks to https://github.com/Homebrew/install/issues/612

  CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
  && echoyay "Homebrew installed. Adding it to .bashrc..."

  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
fi

# reload bash to recognize homebrew
source ~/.bashrc

echomain "Installing our programs..."

brew install ${brewapps} && echoyay "Done."

echomain "symlinking dotfiles with stow..."
stow . && echo "Done."

echomain "Setting zsh as default shell..."

if grep -Fxq $(which zsh) /etc/shells
then
  echomain "our zsh is already in /etc/shells"
else
  echo $(which zsh) | sudo tee -a /etc/shells
fi

echomain "Switching to zsh..."
sudo usermod --shell $(which zsh) ${user} && echoyay "Done."


echomain "The script is done! Remember to run 'exec zsh' to change into the custom shell."