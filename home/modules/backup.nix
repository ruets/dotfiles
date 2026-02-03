{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  home = {
    packages = with pkgs; [
      restic
      resticprofile
    ];

    file = {
      ".config/resticprofile".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/home/modules/backup";
    };
  };
  home.activation.resticprofileSchedule = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.resticprofile}/bin/resticprofile schedule --all
  '';
}
