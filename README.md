packages :

waydroid
1password
gitkraken
npm / node
( adb-wifi
( gitignore
obsidian
pvpn-cli
w3m
grip (md)
networkmanager (nmtui, nm-applet)
barrier
discord
eog
gnome-disks
onedriver
gimp
inskape
kooha
lutris
lm studio
meld (diff tool)
min browser
missioncenter
obs studio
qdirstat
responsively
galaxy buds client
rnote
showmethekey
smile
spotify
virt-manager
zathura
nnn
mpv video player
pacseek
scrcpy
bar-protonmail
spotify-tui
eza
fprint
lazygit
cmatrix
qemu
virt-manager
elia-chat (pipx)
btop
warp terminal

script :

- nix install via script
- `nix-shell '<home-manager>' -A install`
- clone git repo into `~/.config/home-manager`
- ask for config to apply
- `home-manager switch --flake ./#SELECTED_CONFIG`
- ask for wallpapers & scripts repos (https://github.com/mylinuxforwork/wallpaper)
- ask for installer by OS (yay for example)
  sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

```
script nix (nixos.com)
script home-manager (standalone installation)

rm home manager config dir
git config --global core.sshCommand ssh.exe
git clone (via ssh)

cd home manager config dir

home-manager switch --flake ./#wsl --extra-experimental-features "nix-command flakes"
```

For windows :

- powertoys settings
- quake mode terminal (on CTR+ALT+T)

https://render.com/docs/cli
ADB
