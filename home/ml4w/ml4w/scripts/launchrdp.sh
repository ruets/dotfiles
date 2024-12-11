#!/bin/bash

if [ -f ~/private/rdp-credentials.sh ]; then
  echo "Credential file exists. Using the file."
  source ~/private/rdp-credentials.sh
else
  defaultuser="USER"
  defaultip="192.168.0.1"

  echo "## Preparing to remotely access your computer ##"

  echo -n "Please enter your computer name or ip [default: $defaultip]: "
  read ip
  ip=${ip:-$defaultip}

  echo -n "Please enter your username [default: $defaultuser]: "
  read user
  user=${user:-$defaultuser}
fi

# Détection si nous sommes dans un environnement graphique pour utiliser zenity
if command -v zenity >/dev/null 2>&1; then
  password=$(zenity --password --title="Enter your password")
else
  echo -n "Please enter your password: "
  read -s password
  echo ""
fi

echo "Hello, $ip, $user, $password"

echo "Starting xfreerdp now..."

if command -v xfreerdp >/dev/null 2>&1; then
  xfreerdp -grab-keyboard /v:$ip /size:100% /cert-ignore /u:$user /p:$password /d: /dynamic-resolution /gfx-h264:avc444 +gfx-progressive /f &
elif command -v xfreerdp3 >/dev/null 2>&1; then
  xfreerdp3 -v:$ip -u:$user -p:$password -d: -dynamic-resolution /cert:ignore /f /gfx:AVC444 &
else
  echo "'xfreerdp' or 'xfreerdp3' command not found."
fi
