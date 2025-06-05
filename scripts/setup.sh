#!/usr/bin/env bash

set -euo pipefail

# === CONSTANTS ===
DOTFILES_DIR="$HOME/.config/home-manager"
DOTFILES_REPO="git@github.com:ruets/dotfiles.git"
EXTRA_REPOS=(
  "git@github.com:ruets/scripts.git"
  "git@github.com:mylinuxforwork/wallpaper.git"
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
  "Parsec.Parsec"
  ""
  "Axosoft.GitKraken"
  "qBittorrent.qBittorrent"
  "Responsively.ResponsivelyApp"
  "Docker.DockerDesktop"
  ""
  "Proton.ProtonMail"
  "Proton.ProtonVPN"
  "Notion.Notion"
  "Notion.NotionCalendar"
  ""
  "Microsoft.PowerToys"
  "Samsung.GalaxyBudsManager"
  "DebaucheeOpenSourceGroup.Barrier"
  ""
  "MedalB.V.Medal"
  "Valve.Steam"
  "EpicGames.EpicGamesLauncher"
  "RiotGames.Valorant.EU"
  "ppy.osu"
  "Logitech.GHUB"
  "RivaFarabi.Deckboard"
  "WeMod.WeMod"
)

# === UTILITY FUNCTIONS ===
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

load_nix_profile() {
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
}

winget_package_installed() {
  winget.exe list --name "$1" | grep -q "$1"
}

# === MAIN STEP FUNCTIONS ===
require_admin_privileges() {
  if [ "$(id -u)" -eq 0 ]; then
    echo "🔐 Already running as root, no need to sudo."
    IS_ROOT=true
    return 0
  fi

  IS_ROOT=false
  echo "🔐 This script needs administrative privileges to perform certain actions."
  echo "    Please enter your password when prompted below.\n"
  sudo -v

  (
    while true; do
      sudo -v
      sleep 60
    done
  ) &
  sudo_keeppid=$!
}

check_user_var() {
  if [ -z "${USER-}" ]; then
    export USER=$(whoami)
    echo "✅ \$USER is set to '$USER'."
  else
    echo "✅ \$USER is already set to '$USER'."
  fi
}

ensure_home_symlink() {
  if [ "$IS_ROOT" = "true" ]; then
    [ -d "/home/$USER" ] || ln -s "$HOME" "/home/$USER"
  else
    [ -d "/home/$USER" ] || sudo ln -s "$HOME" "/home/$USER"
  fi

  echo "✅ /home/$USER is ready."
}

check_required_commands() {
  for cmd in "${REQUIRED_COMMANDS[@]}"; do
    command_exists "$cmd" || {
      echo "❌ Command '$cmd' is required but not found. Aborting."
      exit 1
    }
  done
  echo "✅ All required commands are available."
}

install_nix() {
  if ! command_exists nix; then
    echo "📦 Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon
    echo "✅ Nix installed successfully."
  else
    echo "✅ Nix is already installed."
  fi
  load_nix_profile
}

install_home_manager() {
  if ! command_exists home-manager; then
    echo "📦 Installing Home Manager..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    echo "✅ Home Manager installed successfully."
  else
    echo "✅ Home Manager already installed."
  fi
}

install_nix_packages() {
  for pkg in "${NIX_PACKAGES[@]}"; do
    if ! command_exists "$pkg"; then
      echo "📦 Installing nix package: $pkg"
      nix-env -iA "nixpkgs.$pkg"
      echo "✅ nix package $pkg installed successfully."
    else
      echo "✅ nix package $pkg is already installed."
    fi
  done
}

configure_wsl_environment() {
  IS_WSL=$(gum confirm "💻 Is this installation under WSL?" && echo "true" || echo "false")

  if [[ "$IS_WSL" == "true" ]]; then
    if command_exists ssh.exe; then
      git config --global core.sshCommand "ssh.exe"
      echo "✅ Git configured to use ssh.exe for WSL."
    else
      echo "🚫 Command ssh.exe is not found. Skipping git configuration."
    fi

    if command_exists winget.exe; then
      if gum confirm "📦 Do you want to install Windows packages via winget?"; then
        SELECTED_PACKAGES=$(printf '%s\n' "${WINGET_PACKAGES[@]}" | gum filter --placeholder "Select packages to install" --no-limit)

        if [[ -z "$SELECTED_PACKAGES" ]]; then
          echo "🚫 No packages selected. Skipping winget installation."
        else
          while IFS= read -r pkg; do
            if ! winget.exe list --name "$pkg" | grep -q "$pkg"; then
              gum spin --title "📦 Installing $pkg via winget..." -- \
                winget.exe install --id="$pkg" --silent --accept-source-agreements --accept-package-agreements
              echo "✅ $pkg installed successfully."
            else
              echo "✅ $pkg already installed."
            fi
            sleep 2
          done <<<"$SELECTED_PACKAGES"
        fi
      else
        echo "🚫 Skipping winget package installation."
      fi
    else
      echo "🚫 winget is not available on this system. Skipping winget installations."
    fi

    echo "✅ WSL-specific configuration applied."
  else
    echo "🚫 Skipping WSL-specific configuration."
  fi
}

setup_dotfiles() {
  if git -C "$DOTFILES_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    origin_url="$(git -C "$DOTFILES_DIR" remote get-url origin 2>/dev/null)"
    if [ "$origin_url" = "$DOTFILES_REPO" ]; then
      echo "✅ Dotfiles repository already exists at $DOTFILES_DIR and matches $DOTFILES_REPO."
      return
    else
      echo "⚠️ Dotfiles directory exists but origin doesn't match. Replacing..."
      rm -rf "$DOTFILES_DIR"
    fi
  else
    echo "📁 Dotfiles directory is not a git repository. Replacing..."
    rm -rf "$DOTFILES_DIR"
  fi

  gum spin --title "📦 Cloning $DOTFILES_REPO..." -- git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  echo "✅ Dotfiles repository cloned to $DOTFILES_DIR."
}

clone_extra_repos() {
  if gum confirm "🐙 Do you want to clone extra GitHub repositories?"; then
    SELECTED_REPOS=$(printf '%s\n' "${EXTRA_REPOS[@]}" | gum filter --placeholder "Select repositories to clone" --no-limit)

    if [[ -z "$SELECTED_REPOS" ]]; then
      echo "🚫 No repositories selected. Skipping."
    else
      while IFS= read -r repo; do
        REPO_NAME=$(basename "$repo" .git)
        TARGET_DIR="$HOME/$REPO_NAME"

        if [ -d "$TARGET_DIR" ]; then
          echo "✅ Directory $TARGET_DIR already exists. Skipping clone for $REPO_NAME."
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
}

apply_home_manager_config() {
  AVAILABLE_CONFIGS=($(nix eval .#homeConfigurations --apply builtins.attrNames --extra-experimental-features "nix-command flakes" | tr -d '[]"'))
  CHOICE=$(printf '%s\n' "${AVAILABLE_CONFIGS[@]}" | gum choose --header="Choose your Home Manager configuration")
  home-manager switch -b backup --flake "./#$CHOICE" --extra-experimental-features "nix-command flakes"
  echo "✅ Home Manager configuration $CHOICE applied."
}

# === CLEANUP ===
cleanup() {
  echo "🧹 Cleaning up..."
  if [ -n "${sudo_keeppid-}" ]; then
    kill "$sudo_keeppid"
    echo "✅ Stopped sudo keep-alive process."
  else
    echo "🚫 No sudo keep-alive process found."
  fi

  if command_exists nix-env; then
    for pkg in "${NIX_PACKAGES[@]}"; do
      if nix-env -q "$pkg" >/dev/null 2>&1; then
        echo "­🧹 Removing nix package: $pkg"
        nix-env -e "$pkg"
      fi
    done
    echo "✅ Nix packages cleanup done."
  else
    echo "🚫 nix-env not found, skipping Nix package cleanup."
  fi

  echo "✅ Cleanup complete."
}

# === MAIN ENTRYPOINT ===
main() {
  trap cleanup EXIT INT TERM

  echo "==> 1. Check environment and dependencies"
  require_admin_privileges
  check_user_var
  ensure_home_symlink
  check_required_commands

  echo "==> 2. Install Nix and Home Manager"
  install_nix
  install_home_manager
  install_nix_packages

  echo "==> 3. Configure WSL (if applicable)"
  configure_wsl_environment

  echo "==> 4. Setup dotfiles and extra repos"
  setup_dotfiles
  clone_extra_repos
  cd "$DOTFILES_DIR"

  echo "==> 5. Apply Home Manager configuration"
  apply_home_manager_config

  # === 6. Finalization ===
  echo "==> 6. Finalization"
  echo "✅ All done! Your environment is ready."
}

main "$@"
