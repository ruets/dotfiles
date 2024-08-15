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

set -g fish_key_bindings fish_vi_key_bindings

# Define Editor
set EDITOR nvim

# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------
alias c='clear'
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'
alias ls='eza --icons'
alias lsa='eza -a --icons'
alias ll='eza -l --icons'
alias lla='eza -al --icons'
alias lt='eza - --tree --level=1 --icons'
alias lta='eza -a --tree --level=1 --icons'
alias lT='eza - --tree --icons'
alias lTa='eza -a --tree --icons'
alias shutdown='systemctl poweroff'
alias v='$EDITOR'
alias vim='$EDITOR'
alias ts='~/.config/ml4w/scripts/snapshot.sh'
alias matrix='cmatrix'
alias wifi='nmtui'
alias dot="cd ~/dotfiles"
alias cleanup='~/.config/ml4w/scripts/cleanup.sh'

# -----------------------------------------------------
# ML4W Apps
# -----------------------------------------------------
alias ml4w='~/.config/ml4w/apps/ML4W_Welcome-x86_64.AppImage'
alias ml4w-settings='~/.config/ml4w/apps/ML4W_Dotfiles_Settings-x86_64.AppImage'
alias ml4w-sidebar='~/.config/ml4w/eww/ml4w-sidebar/launch.sh'
alias ml4w-hyprland='~/.config/ml4w/apps/ML4W_Hyprland_Settings-x86_64.AppImage'
alias ml4w-diagnosis='~/.config/ml4w/hypr/scripts/diagnosis.sh'
alias ml4w-hyprland-diagnosis='~/.config/ml4w/hypr/scripts/diagnosis.sh'
alias ml4w-qtile-diagnosis='~/.config/ml4w/qtile/scripts/diagnosis.sh'

# -----------------------------------------------------
# Window Managers
# -----------------------------------------------------

alias Qtile='startx'
# Hyprland with Hyprland

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
# SCRIPTS
# -----------------------------------------------------
alias ascii='~/.config/ml4w/scripts/figlet.sh'

# -----------------------------------------------------
# System
# -----------------------------------------------------
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# -----------------------------------------------------
# Qtile
# -----------------------------------------------------
alias res1='xrandr --output DisplayPort-0 --mode 2560x1440 --rate 120'
alias res2='xrandr --output DisplayPort-0 --mode 1920x1080 --rate 120'
alias setkb='setxkbmap fr;echo "Keyboard set back to fr."'

# -----------------------------------------------------
# VIRTUAL MACHINE
# -----------------------------------------------------
alias vm='~/dotfiles/scripts/launchvm.sh'
alias lg='~/dotfiles/scripts/looking-glass.sh'

# -----------------------------------------------------
# EDIT CONFIG FILES
# -----------------------------------------------------
alias confq='$EDITOR ~/dotfiles/qtile/config.py'
alias confp='$EDITOR ~/dotfiles/picom/picom.conf'
alias confb='$EDITOR ~/dotfiles/fish/config.fish'

# -----------------------------------------------------
# EDIT NOTES
# -----------------------------------------------------
alias notes='$EDITOR ~/notes.txt'

# -----------------------------------------------------
# SYSTEM
# -----------------------------------------------------
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias setkb='setxkbmap fr;echo "Keyboard set back to fr."'

# -----------------------------------------------------
# SCREEN RESOLUTINS
# -----------------------------------------------------

# Qtile
alias res1='xrandr --output DisplayPort-0 --mode 2560x1440 --rate 120'
alias res2='xrandr --output DisplayPort-0 --mode 1920x1080 --rate 120'

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
    fastfetch --config examples/13
else
    echo
    if test -f /bin/qtile
        echo "Start Qtile X11 with command Qtile"
    end
    if test -f /bin/hyprctl
        echo "Start Hyprland with command Hyprland"
    end
end