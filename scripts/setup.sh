#!/usr/bin/env bash

set -euo pipefail

# === CONSTANTS ===
DOTFILES_DIR="$HOME/.config/home-manager"
AVAILABLE_CONFIGS=(
  "gui"
  "cli"
)

DOTFILES_REPO="git@github.com:ruets/dotfiles"
GITHUB_REPOS=(
  "https://github.com/tweag/nickel"
  "https://github.com/nix-community/home-manager"
  "https://github.com/nix-dot-dev/getting-started"
)

REQUIRED_COMMANDS=(
  curl
  git
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

# === 1. Check Environment and Dependencies ===
gum style "==> 1. Check Environment and Dependencies"
# == 1.1 Verify required commands/tools ==
gum style "  -> 1.1 Verify required commands/tools"

for cmd in "${REQUIRED_COMMANDS[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Command '$cmd' is required but not found. Aborting."
    exit 1
  fi
done

# === 2. Install Nix ===
gum style "==> 2. Install Nix"
# == 2.1 Install Nix if missing ==
gum style "  -> 2.1 Install Nix if missing"

if ! command -v nix >/dev/null 2>&1; then
  echo "📦 Installing Nix..."
  sh <(curl -L https://nixos.org/nix/install) --no-daemon
else
  echo "✅ Nix is already installed."
fi

. "$HOME/.nix-profile/etc/profile.d/nix.sh"

# == 2.2 Install home-manager if missing ==
gum style "  -> 2.2 Install home-manager if missing"

if ! command -v home-manager >/dev/null 2>&1; then
  echo "📦 Installing Home Manager..."
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
else
  echo "✅ Home Manager already installed."
fi

# == 2.3 Install additional nix packages ==
gum style "  -> 2.3 Install additional nix packages"

for pkg in "${NIX_PACKAGES[@]}"; do
  if ! nix-env -q "$pkg" >/dev/null 2>&1; then
    echo "📦 Installing nix package: $pkg"
    nix-env -iA "nixpkgs.$pkg"
  else
    echo "✅ nix package $pkg is already installed."
  fi
done

# === 3. Configure environment for specific OS ===
gum style "==> 3. Configure environment for specific OS"
# == 3.1 Apply WSL-specific Configuration ==
gum style "  -> 3.1 Apply WSL-specific configuration"

IS_WSL=$(gum confirm "💻 Is this installation under WSL?" && echo "true" || echo "false")

if [[ "$IS_WSL" == "true" ]]; then
  if command -v ssh.exe >/dev/null 2>&1; then
    git config --global core.sshCommand "ssh.exe"
  else
    echo "⚠️  Command ssh.exe is not found. Skipping git configuration."
  fi

  if command -v winget.exe >/dev/null 2>&1; then
    for pkg in "${WINGET_PACKAGES[@]}"; do
      if ! winget.exe list --name "$pkg" | grep -q "$pkg"; then
        echo "📦 Installing $pkg via winget..."
        winget.exe install --id="$pkg" --silent --accept-source-agreements --accept-package-agreements
      else
        echo "✅ $pkg already installed."
      fi
    done
  else
    echo "⚠️  winget is not available on this system. Skipping winget installations."
  fi
fi

# === 4. Clone or move dotfiles ===
gum style "==> 4. Clone or move dotfiles"
# == 4.1 Clone or move base repo
gum style "  -> 4.1 Clone or move base repo"

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

rm -rf "$DOTFILES_DIR"

if git -C "$SCRIPT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if [ "$SCRIPT_DIR" != "$DOTFILES_DIR" ]; then
    mv "$SCRIPT_DIR" "$DOTFILES_DIR"
  fi
else
  gum spin --title "🐙 Cloning $REPO_URL..." -- git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# == 4.2 Clone extra repos ==
gum style "  -> 4.1 Clone extra repos"

if gum confirm "🐙 Do you want to clone extra GitHub repositories?"; then
  SELECTED_REPOS=$(printf '%s\n' "${GITHUB_REPOS[@]}" | gum filter --placeholder "Select repositories to clone" --no-limit)

  if [[ -z "$SELECTED_REPOS" ]]; then
    echo "🚫 No repositories selected. Skipping."
  else
    while IFS= read -r repo; do
      REPO_NAME=$(basename "$repo" .git)
      TARGET_DIR="$HOME/$REPO_NAME"

      if [ -d "$TARGET_DIR" ]; then
        echo "✅ Repository $REPO_NAME already exists at $TARGET_DIR"
      else
        gum spin --title "🐙 Cloning $REPO_URL..." -- git clone "$repo" "$TARGET_DIR"
      fi
      sleep 2
    done <<<"$SELECTED_REPOS"
  fi
else
  echo "🚫 Skipping GitHub repository installation."
fi

cd "$DOTFILES_DIR"

# === 5. Apply home-manager configuration ===
gum style "==> 5. Apply home-manager configuration"

# == 5.1 Present available configs for selection ==
gum style "  -> 5.1 Present available configs for selection"
CHOICE=$(printf '%s\n' "${AVAILABLE_CONFIGS[@]}" | gum choose --header="Choose your Home Manager configuration")

# == 5.2 Apply selected configuration with home-manager ==
gum style "  -> 5.2 Apply selected configuration with home-manager"
home-manager switch -b backup --flake "./#$CHOICE" --extra-experimental-features "nix-command flakes"

# === 6. Finalization ===
gum style "==> 6. Finalization"

echo "✅ All done! Your environment is ready."
