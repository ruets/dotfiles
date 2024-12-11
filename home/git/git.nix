{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    userName = "ruets";
    userEmail = "dev@ruets.pro";

    extraConfig = {
      core.editor = "nvim";
      init = { defaultBranch = "main"; };
    };
  };
}
