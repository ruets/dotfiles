#!/usr/bin/env bash

set -euo pipefail

# === CONSTANTS ===
DOTFILES_DIR="$HOME/.config/home-manager"
AVAILABLE_CONFIGS=(
  "cli"
  "gui"
)

DOTFILES_REPO="git@github.com:ruets/dotfiles"
EXTRA_REPOS=(
  "git@github.com:ruets/scripts"
  "git@github.com:mylinuxforwork/wallpaper"
)

REQUIRED_COMMANDS=(
  curl
  git
  xz
)
NIX_PACKAGES=(
  gum
)
WINGET_PACKAGES=(
  "Google.Chrome"
  "AgileBits.1Password"
  "Discord.Discord"
  "Spotify.Spotify"

  "Axosoft.GitKraken"
  "qBittorrent.qBittorrent"
  "Responsively.ResponsivelyApp"

  "Proton.ProtonMail"
  "Proton.ProtonVPN"
  "Notion.Notion"
  "Notion.NotionCalendar"

  "Microsoft.PowerToys"
  "Samsung.GalaxyBudsManager"
  "DebaucheeOpenSourceGroup.Barrier"
)

# === 1. Check environment and dependencies ===
echo "==> 1. Check environment and dependencies"
# == 1.0 Check if the scripts have admin privileges ==
echo "  -> 1.0 Check if the scripts have admin privileges"

echo "🔐 This script needs administrative privileges to perform certain actions."
echo "    Please enter your password when prompted below."
echo ""
sudo -v

(while true; do
  sudo -v
  sleep 60
done) &
sudo_keeppid=$!
trap 'kill $sudo_keeppid' EXIT

# == 1.1 Check if $USER is defined ==
echo "  -> 1.1 Check if \$USER is defined"

if [ -z "${USER-}" ]; then
  export USER=$(whoami)
  echo "✅ \$USER is set to '$USER'."
else
  echo "✅ \$USER is already set to '$USER'."
fi

# == 1.2 Check if /home/$USER exists ==
echo "  -> 1.2 Check if /home/\$USER exists"
if [ ! -d "/home/$USER" ]; then
  sudo ln -s $HOME "/home/$USER"
else
  echo "✅ /home/$USER exists."
fi

# == 1.3 Verify required commands/tools ==
echo "  -> 1.3 Verify required commands/tools"

for cmd in "${REQUIRED_COMMANDS[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Command '$cmd' is required but not found. Aborting."
    exit 1
  fi
done

echo "✅ All required commands are available."

# === 2. Install Nix ===
echo "==> 2. Install Nix"
# == 2.1 Install Nix==
echo "  -> 2.1 Install Nix"

if ! command -v nix >/dev/null 2>&1; then
  echo "📦 Installing Nix..."
  sh <(curl -L https://nixos.org/nix/install) --daemon
  echo "✅ Nix installed successfully."
else
  echo "✅ Nix is already installed."
fi

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# == 2.2 Install home-manager==
echo "  -> 2.2 Install home-manager"

if ! command -v home-manager >/dev/null 2>&1; then
  echo "📦 Installing Home Manager..."
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
  echo "✅ Home Manager installed successfully."
else
  echo "✅ Home Manager already installed."
fi

# == 2.3 Install additional nix packages ==
echo "  -> 2.3 Install additional nix packages"

for pkg in "${NIX_PACKAGES[@]}"; do
  if ! nix-env -q "$pkg" >/dev/null 2>&1; then
    echo "📦 Installing nix package: $pkg"
    nix-env -iA "nixpkgs.$pkg"
    echo "✅ nix package $pkg installed successfully."
  else
    echo "✅ nix package $pkg is already installed."
  fi
done

# === 3. Configure environment for specific OS ===
echo "==> 3. Configure environment for specific OS"
# == 3.1 Apply WSL-specific Configuration ==
echo "  -> 3.1 Apply WSL-specific configuration"

IS_WSL=$(gum confirm "💻 Is this installation under WSL?" && echo "true" || echo "false")

if [[ "$IS_WSL" == "true" ]]; then
  if command -v ssh.exe >/dev/null 2>&1; then
    git config --global core.sshCommand "ssh.exe"
    echo "✅ Git configured to use ssh.exe for WSL."
  else
    echo "🚫 Command ssh.exe is not found. Skipping git configuration."
  fi

  if command -v winget.exe >/dev/null 2>&1; then
    for pkg in "${WINGET_PACKAGES[@]}"; do
      if ! winget.exe list --name "$pkg" | grep -q "$pkg"; then
        echo "📦 Installing $pkg via winget..."
        winget.exe install --id="$pkg" --silent --accept-source-agreements --accept-package-agreements
        echo "✅ $pkg installed successfully."
      else
        echo "✅ $pkg already installed."
      fi
    done
  else
    echo "🚫 winget is not available on this system. Skipping winget installations."
  fi

  echo "✅ WSL-specific configuration applied."
else
  echo "🚫 Skipping WSL-specific configuration."
fi

# === 4. Clone or move dotfiles ===
echo "==> 4. Clone or move dotfiles"
# == 4.1 Clone or move base repo
echo "  -> 4.1 Clone or move base repo"

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

if git -C "$SCRIPT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if [ "$SCRIPT_DIR" != "$DOTFILES_DIR" ]; then
    rm -rf "$DOTFILES_DIR"
    mv "$SCRIPT_DIR" "$DOTFILES_DIR"
    echo "✅ Moved dotfiles from $SCRIPT_DIR to $DOTFILES_DIR."
  fi
  echo "✅ Dotfiles repository is already in $DOTFILES_DIR."
else
  rm -rf "$DOTFILES_DIR"
  gum spin --title "🐙 Cloning $DOTFILES_REPO..." -- git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  echo "✅ Dotfiles repository cloned to $DOTFILES_DIR."
fi

# == 4.2 Clone extra repos ==
echo "  -> 4.1 Clone extra repos"

if gum confirm "🐙 Do you want to clone extra GitHub repositories?"; then
  SELECTED_REPOS=$(printf '%s\n' "${EXTRA_REPOS[@]}" | gum filter --placeholder "Select repositories to clone" --no-limit)

  if [[ -z "$SELECTED_REPOS" ]]; then
    echo "🚫 No repositories selected. Skipping."
  else
    while IFS= read -r repo; do
      REPO_NAME=$(basename "$repo" .git)
      TARGET_DIR="$HOME/$REPO_NAME"

      if [ -d "$TARGET_DIR" ]; then
        echo "✅ Repository $REPO_NAME already exists at $TARGET_DIR"
      else
        gum spin --title "🐙 Cloning $repo..." -- git clone "$repo" "$TARGET_DIR"
        echo "✅ Repository $REPO_NAME cloned to $TARGET_DIR"
      fi
      sleep 2
    done <<<"$SELECTED_REPOS"
  fi
else
  echo "🚫 Skipping GitHub repository installation."
fi

cd "$DOTFILES_DIR"

# === 5. Apply home-manager configuration ===
echo "==> 5. Apply home-manager configuration"

# == 5.1 Present available configs for selection ==
echo "  -> 5.1 Present available configs for selection"
CHOICE=$(printf '%s\n' "${AVAILABLE_CONFIGS[@]}" | gum choose --header="Choose your Home Manager configuration")
echo "✅ Selected configuration: $CHOICE"

# == 5.2 Apply selected configuration with home-manager ==
echo "  -> 5.2 Apply selected configuration with home-manager"
home-manager switch -b backup --flake "./#$CHOICE" --extra-experimental-features "nix-command flakes"
echo "✅ Home Manager configuration applied."

# === 6. Finalization ===
echo "==> 6. Finalization"

echo "✅ All done! Your environment is ready."
