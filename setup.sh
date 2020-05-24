#/usr/bin/env bash

# Constants
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;93m'

info() {
 echo -e "${BLUE}$1${NC}" 
}

error() {
  echo -e "${RED}$1${NC}" 
}

warn() {
  echo -e "${YELLOW}$1${NC}" 
}

success() {
  echo -e "${GREEN}$1${NC}" 
}

check_root() {
  if [ $(whoami) != "root" ]
  then
    info ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
    error "######### This script must be executed as root! #########"
    info ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
    exit 1
  fi
}

install_chrome() {
    info "Lets install Google Chrome"
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
    apt update
    apt install google-chrome-stable -y

    success "Google Chrome is installed"
}

install_docker() {
    info "Lets install Docker"
    apt remove docker docker-engine docker.io -y
    apt install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    apt-key fingerprint 0EBFCD88
    add-apt-repository -y -u -s "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt install docker-ce docker-compose -y
    docker run hello-world

    info "Type the name of your user (not root), followed by [ENTER]:"
    read COMMON_USER
    info "Some configurations will be applied to $COMMON_USER"
    usermod -aG docker $COMMON_USER
    success "Now user $COMMON_USER can perform docker commands" 
    success "without sudo. Make sure restart user session before"
    success "run docker commands."
}

install_game_clients() {
    info "Lets install Game stuff"
    apt install steam lutris -y
    flatpak install flathub org.gnome.Games -y
    flatpak install flathub com.snes9x.Snes9x -y
    success "Game clients installed"
}

install_development_tools() {
  flatpak install flathub postman -y
  flatpak install flathub com.jetbrains.PyCharm-Community -y
  flatpak install flathub com.jetbrains.WebStorm -y
  flatpak install flathub com.jetbrains.IntelliJ-IDEA-Ultimate -y
  flatpak install flathub com.google.AndroidStudio -y
  flatpak install flathub cc.arduino.arduinoide -y
  snap install google-cloud-sdk --classic
  snap install goland --classic
  snap install kotlin --classic
}

install_miscellaneous() {
  apt install flatpak -y
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  
  apt install snapd -y

  flatpak install flathub com.slack.Slack -y
  flatpak install flathub com.discordapp.Discord -y
  snap install obs-studio
  snap install onlyoffice-desktopeditors
}

info ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
info ":::::::::: Setup Script For $(lsb_release -d -s) :::::::::::"
info ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
info ""
info ""
info "This setup is meant for developers, so if you're not a "
info "developer do not use it"
info ""
info ""

check_root

apt update
apt upgrade -y
apt autoremove -y

install_miscellaneous
install_chrome
install_docker
install_game_clients

info ""
info ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
success ":::::::::: Setup for $(lsb_release -d -s) has DONE! ::::::::"
info ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
info ""