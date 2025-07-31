#!/usr/bin/env bash

set -e

# Colors
GREEN="\033[0;32m"
RESET="\033[0m"

# Check for Ubuntu
if  [[ $(grep -qi "ubuntu" /etc/os-release) -eq 0 ]]   && [[ $EUID -ne 0 ]]; then
    echo -e "${RED}🚫 Ce script est uniquement conçu pour Ubuntu.${RESET}"
    sudo apt update && sudo apt upgrade -y

    sudo apt install -y \
        git \
        neovim \
        wget \
        curl \
        htop \
        tree \
        fish \
        ripgrep \
        fd-find \
        python3 \
        python3-pip \
        build-essential \

        clang \
        fzf \

        lazygit \
        unzip \
        ca-certificates \
        gnupg \

        lsb-release \
        software-properties-common

# Link fd if not already linked
if ! command -v fd &>/dev/null; then
    ln -s $(which fdfind) /usr/local/bin/fd
fi

else
    #############################################################################

    echo -e "${GREEN}🔧 Bootstrapping de Homebrew...${RESET}"


# Detect if Homebrew is already installed
if ! command -v brew &>/dev/null; then
    echo -e "${GREEN}📦 Installation Homebrew...${RESET}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


  # For Linux or Apple Silicon
  echo -e "${GREEN}🔄 Ajout de  Homebrew au PATH...${RESET}"

  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || \
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    echo -e "${GREEN}✅ Homebrew est deja installé.${RESET}"
fi

# Update and check
echo -e "${GREEN}🔄 Updating Homebrew...${RESET}"
brew update

echo -e "${GREEN}🔍 lancement brew doctor...${RESET}"
brew doctor || true


# Install common packages
echo -e "${GREEN}📦 Installing super utiles packages...${RESET}"
brew install git neovim wget curl htop tree lazygit

echo -e "${GREEN}✅ Bootstrap complété!${RESET}"

brew install rustup
brew install fish
brew install ripgrep 
brew install fd
brew install nvm
brew install clang
brew install python
brew install fzf

fi

rustup-init -y
nvm install v24
cargo install rust-analyzer

echo -e "/n   eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.profile;
echo -e "/n export PATH='${HOME}/.cargo/bin:$PATH'"
