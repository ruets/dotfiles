{ config, pkgs, ... }:

let
  defaultApps = [
    { name = "terminal"; command = "kitty"; }
    { name = "editor";   command = "nvim"; }

    { name = "launcher"; command = "rofi -show drun -replace -i -theme ~/.config/rofi/config.rasi"; }
    { name = "file_manager"; command = "dotfiles-terminal -e yazi"; }
    { name = "browser"; command = "google-chrome-stable --enable-features=TouchpadOverscrollHistoryNavigation"; }
    { name = "mail"; command = "google-chrome-stable --app-id=jnpecgipniidlgicjocehkhajgdnjekh"; }
    { name = "ai"; command = "google-chrome-stable --app-id=cadlkienfkclaiaibeoongdcgmdikeeg"; }

    { name = "window_walker"; command = "rofi -show window -replace -i -theme ~/.config/rofi/config.rasi"; }
    { name = "clipboard_manager"; command = "cliphist list | rofi -dmenu -replace -config ~/.config/rofi/config-cliphist.rasi | cliphist decode | wl-copy"; }
    { name = "system_monitor"; command = "mission-center"; }
    { name = "network_manager"; command = "nm-connection-editor"; }

    { name = "screenshot"; command = "grimblast copy area"; }
    { name = "screen_recorder"; command = "obs"; }
    { name = "wallpaper_engine"; command = "waypaper"; }
    { name = "emoji_picker"; command = "smile"; }
    { name = "calculator"; command = "dotfiles-terminal -e qalc"; }

    { name = "lock_screen"; command = "swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --fade-in 0.2"; }
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
