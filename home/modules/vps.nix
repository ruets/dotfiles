{ config, pkgs, ... }:

{
  home.file = {
    "services/scripts" = {
      source = ./services/scripts;
      recursive = true;
      force = true;
    };

    "services/configs".source = ./vps/configs;

    "services/docker-compose.yml".source = ./vps/docker-compose.yml;
 
    "services/secrets/.keep".text = "";
  };
}
