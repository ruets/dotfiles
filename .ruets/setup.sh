#!/bin/bash

#Set constants
readonly DOTFILES_DIR="$HOME/dotfiles"
readonly SCRIPTS_DIR="$HOME/scripts"
readonly TEMP_DIR="$HOME/.tmp_ruets"

readonly RUETS_GIT_URL="git@github.com:ruets/dotfiles.git"
readonly SCRIPTS_GIT_URL="git@github.com:ruets/scripts.git"
readonly ML4W_SETUP_SCRIPT_URL="https://gitlab.com/stephan-raabe/dotfiles/-/raw/main/setup.sh"

toInstall = (
  "fish"
  "starship"
  "tmux"

  "npm"
  "nodejs"
  "python-pipx"
  "libqalculate"
  "texlive-binextra"
  
  "zathura"
  "zathura-cb"
  "zathura-ps"
  "zathura-djvu"
  "zathura-pdf-mupdf"

  "jetbrains-toolbox"
  "gitkraken"
  "lazygit"
  "ollama"
  "lmstudio-appimage"

  "1password"
  "google-chrome"
  "min-browser-bin"
  "spotify"
  "discord"

  "w3m"
  "nnn"
  "responsively"
  "qdirstat"
  "inkscape"
  "eog"
)

git clone $RUETS_GIT_URL $DOTFILES_DIR

curl -s $ML4W_SETUP_SCRIPT_URL >> $DOTFILES_DIR/setup.sh
chmod +x $DOTFILES_DIR/setup.sh
$DOTFILES_DIR/setup.sh

yay --noconfirm -S "${toInstall[@]}"
pipx install elia-chat

ln -s $DOTFILES_DIR/fish/ $HOME/.config

# starship preset nerd-fonts-symbols

git clone $SCRIPTS_GIT_URL $SCRIPTS_DIR

rm -rf $TEMP_DIR
