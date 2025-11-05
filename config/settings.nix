{ config, pkgs, ... }:

let
  defaultApps = [
    { name = "terminal"; command = "kitty"; }
    { name = "editor";   command = "nvim"; }

    { name = "launcher"; command = "rofi -show drun -replace -i -theme ~/.config/rofi/config.rasi"; }
    { name = "file_manager"; command = "dotfiles-terminal -e ranger"; }
    { name = "browser"; command = "google-chrome-stable --enable-features=TouchpadOverscrollHistoryNavigation"; }
    { name = "mail"; command = "google-chrome-stable --app-id=jnpecgipniidlgicjocehkhajgdnjekh"; }
    { name = "ai"; command = "google-chrome-stable --app-id=cadlkienfkclaiaibeoongdcgmdikeeg"; }

    { name = "window_walker"; command = "rofi -show window -replace -i -theme ~/.config/rofi/config.rasi"; }
    { name = "clipboard_manager"; command = "cliphist list | rofi -dmenu -replace -config ~/.config/rofi/config-cliphist.rasi | cliphist decode | wl-copy"; }
    { name = "system_monitor"; command = "mission-center"; }
    { name = "network_manager"; command = "nm-connection-editor"; }

    { name = "wallpaper_engine"; command = "waypaper"; }
    { name = "emoji_picker"; command = "smile"; }
    { name = "calculator"; command = "dotfiles-terminal -e qalc"; }

    { name = "lock_screen"; command = "hyprlock"; }
  ];

  generatedWrappers = map (app:
    pkgs.writeShellScriptBin "dotfiles-${app.name}"
      ''exec ${app.command} "$@"''
  ) defaultApps;
in
{
  home.packages = with pkgs;
    (generatedWrappers);
}
