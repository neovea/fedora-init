#!/bin/bash

# Mise à jour des paquets et installation des programmes de base
sudo dnf update -y
sudo dnf install -y alacritty neovim tmux zsh curl git make ripgrep evolution evolution-ews steam transmission timeshift

# Installation de Docker Desktop
curl https://desktop.docker.com/linux/main/amd64/docker-desktop-4.26.1-x86_64.rpm
sudo dnf install -y ./docker-desktop-4.26.1-x86_64.rpm

# Installation de navigateurs
sudo dnf install dnf-plugins-core
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install -y brave-browser
sudo dnf install -y google-chrome-stable

# Installation de Enpass, Evolution et leurs extensions
cd /etc/yum.repos.d/
sudo wget https://yum.enpass.io/enpass-yum.repo
sudo yum install -y enpass && cd -

# Téléchargement de JetBrains Toolbox
curl -L "https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.21.9712.tar.gz" -o jetbrains-toolbox.tar.gz
tar -xzf jetbrains-toolbox.tar.gz -C $HOME
rm jetbrains-toolbox.tar.gz

# Installation de Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Installation de NVM et Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install v18.19.0
nvm alias default v18.19.0
nvm use default

# Création des liens symboliques pour les fichiers de configuration
link_files() {
  if [ -e "$2" ]; then
    rm -rf "$2"
  fi
  ln -s "$1" "$2"
}

link_files "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
link_files "$HOME/dotfiles/.tmux.conf" "$HOME/.tmux.conf"
link_files "$HOME/dotfiles/nvim" "$HOME/.config/nvim"
link_files "$HOME/dotfiles/alacritty" "$HOME/.config/alacritty"
link_files "$HOME/dotfiles/.fonts" "$HOME/.fonts"

# Installation de Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# Génération des nouvelles clés SSH
ssh-keygen

# Lancement d'une sauvegarde complète du système avec Timeshift
sudo timeshift --create --comments "Initial backup" --tags D

echo "Installation et configuration terminées !"
