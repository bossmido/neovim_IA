#!/usr/bin/env bash

set -e

# Colors
GREEN="\033[0;32m"
RESET="\033[0m"

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

rustup-init -y
nvm install v24
cargo install rust-analyzer

echo -e "/n   eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.profile;
echo -e "/n export PATH='${HOME}/.cargo/bin:$PATH'"
