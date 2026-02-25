# dotfiles

[Home Manager](https://github.com/nix-community/home-manager) configuration managed as a Nix flake, across multiple machines.

## How it works

The repo is structured in layers:

```
flake.nix               # entry point — declares available configurations
config/
  config.nix            # base settings for all hosts (nixpkgs, nix, nixGL)
  settings.nix          # dotfiles-* wrappers (dotfiles-terminal, dotfiles-editor…)
hosts/
  darwin.nix            # macOS (aarch64)
  ubuntu.nix            # Linux desktop
  hostinger.nix         # VPS
  test.nix              # test config (aarch64-linux)
  _template.nix         # template for a new host
home/
  cli/cli.nix           # common CLI tools (fish, neovim, git, tmux…)
  desktop/desktop.nix   # GUI packages
  languages/            # language toolchains (go, node, python, rust…)
  modules/              # optional modules (vps, wallpapers, winapps)
```

Each host imports only the `home/` modules it needs. For example, `darwin.nix` only imports `cli.nix` (no desktop), while `ubuntu.nix` imports both cli and desktop.

## Installation

### Automatic (recommended)

The `scripts/setup.sh` script handles the entire process:

```bash
bash <(curl -s https://raw.githubusercontent.com/ruets/dotfiles/main/scripts/setup.sh)
```

It runs the following steps:

- 1. Installs Nix and Home Manager if not already present
- 2. Clones this repo into `~/.config/home-manager`
- 3. Detects and configures WSL if applicable (git via `ssh.exe`, Windows packages via `winget`)
- 4. Prompts to choose a configuration and applies it

### Manual

**1. Install Nix:**

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

**2. Install Home Manager:**

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

**3. Clone the repo:**

```bash
git clone https://github.com/ruets/dotfiles ~/.config/home-manager
cd ~/.config/home-manager
```

**4. Apply your host configuration:**

```bash
home-manager switch --flake .#darwin     # macOS
home-manager switch --flake .#ubuntu     # Linux desktop
home-manager switch --flake .#hostinger  # VPS
```

## Usage

### Apply changes

```bash
home-manager switch --flake .#<host>
```

With a backup of replaced files:

```bash
home-manager switch -b backup --flake .#<host>
```

### Build without applying

```bash
home-manager build --flake .#<host>
```

### Update dependencies

```bash
nix flake update          # all inputs
nix flake update nixpkgs  # a specific input
```

### Add a new host

Copy `hosts/_template.nix` to `hosts/<name>.nix`, adapt it, then register the configuration in `flake.nix`:

```nix
"<name>" = mkHome "<name>" "<system>";  # e.g. "x86_64-linux"
```
