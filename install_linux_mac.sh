#!/bin/bash

# Detect OS
OS=""
PKG_MANAGER=""

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/os-release ]; then
        OS=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
    elif [ -f /etc/debian_version ]; then
        OS="debian"
    elif [ -f /etc/redhat-release ]; then
        OS="redhat"
    else
        OS="unknown-linux"
    fi

    # Detect package manager, update system, and install Nmap
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
        sudo apt update && sudo apt upgrade -y
        sudo apt install -y nmap
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        sudo dnf upgrade -y
        sudo dnf install -y nmap
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
        sudo yum update -y
        sudo yum install -y nmap
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm nmap
    elif command -v zypper &> /dev/null; then
        PKG_MANAGER="zypper"
        sudo zypper refresh && sudo zypper update -y
        sudo zypper install -y nmap
    elif command -v apk &> /dev/null; then
        PKG_MANAGER="apk"
        sudo apk update && sudo apk upgrade
        sudo apk add nmap
    elif command -v emerge &> /dev/null; then
        PKG_MANAGER="portage"
        sudo emerge --sync && sudo emerge -avuDN @world
        sudo emerge -av nmap
    elif command -v nix-env &> /dev/null; then
        PKG_MANAGER="nix"
        nix-channel --update && nix-env -u '*'
        nix-env -iA nixpkgs.nmap
    else
        PKG_MANAGER="unknown"
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    if command -v brew &> /dev/null; then
        PKG_MANAGER="brew"
        brew update && brew upgrade
        brew install nmap
    else
        PKG_MANAGER="none"
    fi

elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    OS="windows"
    if command -v choco &> /dev/null; then
        PKG_MANAGER="choco"
        choco upgrade all -y
        choco install -y nmap
    elif command -v scoop &> /dev/null; then
        PKG_MANAGER="scoop"
        scoop update *
        scoop install nmap
    else
        PKG_MANAGER="none"
    fi

else
    OS="unknown"
    PKG_MANAGER="unknown"
fi

echo "Detected OS: $OS"
echo "Detected Package Manager: $PKG_MANAGER"

if [[ "$PKG_MANAGER" == "unknown" || "$PKG_MANAGER" == "none" ]]; then
    echo "No supported package manager detected, unable to install Nmap."
else
    echo "Nmap installation completed using $PKG_MANAGER."
fi

echo "Creating python virtual environement"
python3 -m venv .venv

source .venv/bin/activate

pip install -r requirements.txt

deactivate
echo "You are free to go now."
echo "Have fun!"
