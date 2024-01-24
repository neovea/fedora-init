##!/bin/bash

# Définition du fichier journal
LOG_FILE="install_errors.log"

# Fonction pour enregistrer les erreurs
log_error() {
  echo "[Erreur $(date +'%Y-%m-%d %H:%M:%S')] $1 a échoué" >> $LOG_FILE
}

# Mise à jour des paquets et installation des programmes de base
sudo dnf update -y || log_error "dnf update"
sudo dnf install -y alacritty neovim tmux zsh curl git make ripgrep evolution evolution-ews steam transmission timeshift || log_error "dnf install packages"

# Installation de la police Nerd Fonts
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip -o JetBrainsMono.zip || log_error "téléchargement JetBrainsMono.zip"
mkdir -p ~/.fonts && unzip -o JetBrainsMono.zip -d ~/.fonts || log_error "installation JetBrainsMono fonts"

# Installation de Docker Desktop
curl https://desktop.docker.com/linux/main/amd64/docker-desktop-4.26.1-x86_64.rpm -o docker-desktop.rpm || log_error "téléchargement docker-desktop"
sudo dnf install -y ./docker-desktop-4.26.1-x86_64.rpm || log_error "installation Docker Desktop"

# Installation de navigateurs
sudo dnf install -y dnf-plugins-core || log_error "dnf install dnf-plugins-core"
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo || log_error "ajout repo Brave"
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc || log_error "import clé Brave"
sudo dnf install -y brave-browser || log_error "installation Brave"
sudo dnf install -y google-chrome-stable || log_error "installation Chrome"

# Installation de Enpass
cd /etc/yum.repos.d/ || log_error "cd /etc/yum.repos.d/"
sudo wget https://yum.enpass.io/enpass-yum.repo || log_error "téléchargement enpass-yum.repo"
sudo yum install -y enpass && cd - || log_error "installation Enpass"

# Téléchargement de JetBrains Toolbox
curl -L "https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.21.9712.tar.gz" -o jetbrains-toolbox.tar.gz || log_error "téléchargement JetBrains Toolbox"
tar -xzf jetbrains-toolbox.tar.gz -C $HOME || log_error "extraction JetBrains Toolbox"
rm jetbrains-toolbox.tar.gz || log_error "suppression jetbrains-toolbox.tar.gz"

# Installation de Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || log_error "installation Oh My Zsh"

# Installation de NVM et Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash || log_error "installation NVM"
nvm install v18.19.0 || log_error "installation Node.js v18.19.0"
nvm alias default v18.19.0 || log_error "alias Node.js v18.19.0"
nvm use default || log_error "utilisation Node.js v18.19.0"

# Création des liens symboliques pour les fichiers de configuration
link_files() {
  if [ -e "$2" ]; then
    rm -rf "$2"
  fi
  ln -s "$1" "$2" || log_error "lien symbolique pour $2"
}

link_files "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
link_files "$HOME/dotfiles/.tmux.conf" "$HOME/.tmux.conf"
link_files "$HOME/dotfiles/nvim" "$HOME/.config/nvim"
link_files "$HOME/dotfiles/alacritty" "$HOME/.config/alacritty"
link_files "$HOME/dotfiles/.fonts" "$HOME/.fonts"

# Installation de Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm || log_error "installation Tmux Plugin Manager"

# Génération des nouvelles clés SSH
ssh-keygen ||

