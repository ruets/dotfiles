{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    docker
    docker-compose
  ];

  home.file = {
    "services/scripts" = {
      source = ./services/scripts;
      recursive = true;
      force = true;
    };

    "services/configs".source = ./services/configs;

    "services/docker-compose.yml".source = ./services/docker-compose.yml;
 
    "services/secrets/.keep".text = "";
  };
}
