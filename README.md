# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). This repository contains shell, terminal, editor, window manager, status bar, theme, and utility script configuration for my macOS and Linux environments.

## Support

Currently supported platforms:

- macOS, with package installation through Homebrew.
- Ubuntu, with package installation through `apt`.

Other Linux distributions are not guaranteed at the moment. Support for Arch-based distributions, such as Arch Linux and EndeavourOS, and Fedora is planned, but there is no timeline yet.

## Repository Structure

This repository follows chezmoi naming conventions:

```text
.chezmoi.yaml.tmpl        # initialization prompts and template data
.chezmoiignore.tmpl       # files excluded by OS and machine type
.chezmoiscripts/          # scripts run after applying dotfiles
.chezmoitemplates/        # shared templates
dot_config/               # files targeting ~/.config
dot_local/bin/            # scripts installed into ~/.local/bin
dot_Brewfile.tmpl         # Homebrew packages for macOS
dot_gitconfig.tmpl        # templated Git configuration
dot_skhdrc                # macOS keyboard shortcuts
```

The main `dot_config/` areas cover Fish, Neovim, Kitty, tmux, Hyprland, Waybar, SwayNC, Rofi, Matugen, Yazi, Cava, and Wlogout.

## Installation

Install chezmoi first, then initialize this repository:

```bash
chezmoi init --apply ruets
```

During initialization, chezmoi asks for:

- the machine type: `personal` or `work`;
- whether the machine is a server;
- Git identity values to inject into the generated configuration.

Post-install scripts may then offer to install system packages and development environments. Each major step asks for confirmation before running.

## What Gets Installed

Depending on the platform and initialization answers, the scripts can configure:

- system packages through Homebrew on macOS or `apt` on Ubuntu;
- Fish as the default shell;
- Node.js through `nvm` and `pnpm`;
- Python through `uv` and `pipx`;
- Go and selected Go tools;
- Rust and selected Cargo tools;
- Nix, if the dedicated script is accepted;
- Flatpak packages and desktop assets on non-server Linux machines;
- Restic and Resticprofile on machines marked as servers.

## Daily Usage

Preview changes before applying them:

```bash
chezmoi diff
```

Apply the dotfiles:

```bash
chezmoi apply
```

Edit a file managed by chezmoi:

```bash
chezmoi edit ~/.config/fish/config.fish
chezmoi apply
```

Update the local checkout:

```bash
chezmoi update
```

## Notes

The Linux desktop profile primarily targets Ubuntu with Hyprland and its related tooling. On macOS, Linux-specific files are excluded through `.chezmoiignore.tmpl`.

Before committing, review the rendered output with `chezmoi diff`. For shell scripts, run `shellcheck` when possible.
