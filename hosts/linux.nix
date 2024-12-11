{ config, pkgs, ... }:

{
  imports = [
    ../config/config.nix
    ../home/ags/ags.nix
    ../home/cava/cava.nix
    ../home/dunst/dunst.nix
    ../home/fastfetch/fastfetch.nix
    ../home/fish/fish.nix
    ../home/git/git.nix
    ../home/htop/htop.nix
    # ../home/kitty/kitty.nix
    ../home/nvim/nvim.nix
    ../home/nwg-dock-hyprland/nwg-dock-hyprland.nix
    # ../home/hypr/hypr.nix
    ../home/tmux/tmux.nix
    ../home/ml4w/ml4w.nix
    # ../home/rofi/rofi.nix
    ../home/starship/starship.nix
    ../home/wal/wal.nix
    ../home/waybar/waybar.nix
    ../home/waypaper/waypaper.nix
    ../home/wlogout/wlogout.nix
  ];
}
