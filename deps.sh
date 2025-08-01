#!/usr/bin/env bash

set -e

# Colors
GREEN="\033[0;32m"
RESET="\033[0m"

# Check for Ubuntu
OK=$(grep -qi "ubuntu" /etc/os-release) ;
if  [[ $? -eq 0 ]]   && [[ $EUID -ne 0 ]]; then
    echo -e "${RED} installation deps : Ubuntu.${RESET}"
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
        software-properties-common\
        nvm

    # Link fd if not already linked
    if ! command -v fd &>/dev/null; then
        ln -s $(which fdfind) /usr/local/bin/fd
    fi
elif [[ $(grep -qi "arch" /etc/os-release) -eq 0 ]] ; then
    echo -e "${GREEN}installation deps : archlinux ${RESET}"
    sudo pacman -Syu --noconfirm


    sudo pacman -S --noconfirm \
        git neovim wget curl htop tree fish ripgrep fd \
        python python-pip base-devel clang fzf lazygit unzip
    # Link fd if not already linked
    if ! command -v fd &>/dev/null; then
        ln -s $(which fdfind) /usr/local/bin/fd
    fi
elif [[ $(grep -qi "arch" /etc/os-release) -eq 0 ]] ; then
    echo -e "${GREEN}installation deps : archlinux ${RESET}"
    sudo pacman -Syu --noconfirm


    sudo pacman -S --noconfirm \
        git neovim wget curl htop tree fish ripgrep fd \
        python python-pip base-devel clang fzf lazygit unzip


else
    #############################################################################

    echo -e "${GREEN}installations deps : linuxbrew${RESET}"


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

        brew install fish
        brew install ripgrep 
        brew install fd
        brew install nvm
        brew install clang
        brew install python
        brew install fzf

fi

echo -e "${GREEN}⚙️ Installation de Rust...${RESET}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- 
source "$HOME/.cargo/env"

echo -e "${GREEN}⚙️ installation de node...${RESET}"
nvm install v24
nvm use v24
cargo install rust-analyzer

echo -e "/n   eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.profile;
echo -e "/n export PATH='${HOME}/.cargo/bin:$PATH'"

##mes dépendance à la con
pip install django-stubs
npm install -g yarn
