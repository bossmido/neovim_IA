#!/usr/bin/env bash

#!/usr/bin/env bash
set -e

# Colors
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# Détection de la distribution
if grep -qi "ubuntu" /etc/os-release; then
    echo -e "${RED}Installation des dépendances : Ubuntu.${RESET}"

    sudo apt update && sudo apt upgrade -y
    sudo apt install -y git neovim wget curl htop tree fish ripgrep fd-find python3 python3-pip \
        build-essential clang fzf lazygit unzip ca-certificates gnupg lsb-release \
        software-properties-common nvm zoxide lnav

    if ! command -v fd &>/dev/null; then
        sudo ln -s "$(which fdfind)" /usr/local/bin/fd
    fi

elif grep -qi "arch" /etc/os-release; then
    echo -e "${GREEN}Installation des dépendances : Arch Linux.${RESET}"

    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm git neovim wget curl htop tree fish ripgrep fd \
        python python-pip base-devel clang fzf lazygit unzip zoxide lnav

else
    echo -e "${GREEN}Installation via Homebrew (autre Linux ou macOS)...${RESET}"

    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || \
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    brew update
    brew doctor || true
    brew install git neovim wget curl htop tree fish ripgrep fd nvm clang python fzf lazygit zoxide lnav
fi

echo -e "${GREEN}⚙️ Installation de du dernier neovim...${RESET}"
bob install stable;

echo -e "${GREEN}⚙️ Installation de Rust...${RESET}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- 
source "$HOME/.ca:q!rgo/env"
rustup install stable

echo -e "${GREEN}⚙️ installation de node...${RESET}"
nvm install v24
nvm use v24
cargo install rust-analyzer

echo -e "/n   eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.profile;
echo -e "/n export PATH='${HOME}/.cargo/bin:$PATH'"

##mes dépendance à la con
pip install django-stubs
npm install -g yarn
npm install -g vscode-langservers-extracted
#installation de ollama qui peut echouer
curl -fsSL https://ollama.com/install.sh | sh

zoxide add ~
