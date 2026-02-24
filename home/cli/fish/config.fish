#    _               _              
#   | |__   __ _ ___| |__  _ __ ___ 
#   | '_ \ / _` / __| '_ \| '__/ __|
#  _| |_) | (_| \__ \ | | | | | (__ 
# (_)_.__/ \__,_|___/_| |_|_|  \___|
# 
# by Stephan Raabe (2023)
# -----------------------------------------------------
# ~/.bashrc
# -----------------------------------------------------

if status is-interactive
    # Commands to run in interactive sessions can go here
end

abbr --add dotdot --regex '^\.\.+$' --function multicd

set -g fish_key_bindings fish_vi_key_bindings

# Define Editor
set EDITOR nvim

# Define AI Tool
set AI claude

# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------
alias c='clear'
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'
alias ls='eza --icons --group-directories-first'
alias lsa='eza -a --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias lla='eza -al --icons --group-directories-first'
alias lt='eza --tree --level=1 --icons --group-directories-first'
alias lta='eza -a --tree --level=1 --icons --group-directories-first'
alias lT='eza --tree --icons --group-directories-first'
alias lTa='eza -a --tree --icons --group-directories-first':
alias shutdown='systemctl poweroff'
alias v='$EDITOR'
alias sv='sudoedit'
alias vim='$EDITOR'
alias svim='sudoedit'
alias ts='~/.config/ml4w/scripts/snapshot.sh'
alias matrix='cmatrix'
alias files="dotfiles-files"
alias calc="dotfiles-calc"
alias wifi='nmtui'
alias cleanup='~/.config/ml4w/scripts/cleanup.sh'
alias combinedaudio='pactl load-module module-combine-sink'
alias clock='tty-clock -sc'

# -----------------------------------------------------
# Nix HomeManager
# -----------------------------------------------------
alias dot='cd ~/.config/home-manager'
alias updateDots='dot; scripts/setup.sh'

function reloadNix
    if test (count $argv) -lt 1
        set AVAILABLE_CONFIGS (nix eval $HOME/.config/home-manager/#homeConfigurations --apply builtins.attrNames | tr -d '[]"' | string trim | tr ' ' '\n')
        set CHOICE (printf '%s\n' $AVAILABLE_CONFIGS | gum choose --header="Choose your configuration")
    else
        set CHOICE $argv[1]
    end
    home-manager switch -b backup --flake "$HOME/.config/home-manager/#$CHOICE" --extra-experimental-features "nix-command flakes"
end

function cleanupNix
    echo "🧹 Suppression des générations Home Manager de plus de 7 jours..."
    home-manager expire-generations "-7 days"

    echo "🧹 Suppression des anciennes générations système..."
    nix-collect-garbage --delete-older-than 7d

    echo "🧹 Garbage collect..."
    nix store gc

    echo "🧩 Optimisation du store..."
    nix store optimise

    echo "✅ Nettoyage terminé."
end

# -----------------------------------------------------
# ML4W Apps
# -----------------------------------------------------
alias ml4w='com.ml4w.welcome'
alias ml4w-settings='com.ml4w.dotfilessettings'
alias ml4w-hyprland='com.ml4w.hyprland.settings'
alias ml4w-sidebar='~/.config/ml4w/eww/ml4w-sidebar/launch.sh'
alias ml4w-diagnosis='~/.config/ml4w/hypr/scripts/diagnosis.sh'
alias ml4w-hyprland-diagnosis='~/.config/ml4w/hypr/scripts/diagnosis.sh'

# -----------------------------------------------------
# Apps
# -----------------------------------------------------
alias pvpn='protonvpn-cli'

# -----------------------------------------------------
# NPM DEV TOOLS
# -----------------------------------------------------
alias viteinit="npm create vite"
alias addelectron="~/.config/ml4w/scripts/browser.sh https://medium.com/@utkuy.ceng/converting-your-react-app-to-an-electron-desktop-app-5efdafd15d7b"
alias czinit="commitizen init cz-conventional-changelog --save-dev --save-exact"

# -----------------------------------------------------
# GIT
# -----------------------------------------------------
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash; git pull"
alias gcheck="git checkout"
alias gcredential="git config credential.helper store"

# -----------------------------------------------------
# System
# -----------------------------------------------------
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# -----------------------------------------------------
# EDIT CONFIG FILES
# -----------------------------------------------------
alias confp='$EDITOR ~/.config/picom/picom.conf'
alias confb='$EDITOR ~/.config/fish/config.fish'

# -----------------------------------------------------
# SYSTEM
# -----------------------------------------------------
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias setkb='setxkbmap fr;echo "Keyboard set back to fr."'

set PATH "/home/ruets/.local/bin/:/home/ruets/.jdks/openjdk-21.0.2/platform-tools:/usr/lib/ccache/bin/:$PATH"

# -----------------------------------------------------
# START STARSHIP
# -----------------------------------------------------
#starship preset nerd-font-symbols
starship init fish | source

# -----------------------------------------------------
# PYWAL
# -----------------------------------------------------
cat ~/.cache/wal/sequences

# -----------------------------------------------------
# Fastfetch if on wm
# -----------------------------------------------------
if string match -q '*pts*' (tty)
    fastfetch
else
    echo
    if test -f /bin/hyprctl
        echo "Start Hyprland with command Hyprland"
    end
end
