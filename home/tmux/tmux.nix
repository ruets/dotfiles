{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      # Enable true colors
      set -g default-terminal "$TERM"
      set -ag terminal-overrides ",$TERM:Tc"

      # Enable mouse mode
      set -g mouse on

      # Start counting pane and window number at 1
      set -g base-index 1
      setw -g pane-base-index 1
    '';
  };
}
