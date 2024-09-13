#!/bin/bash

# Nom du moniteur (à modifier selon ton environnement)
MONITOR_NAME="eDP-1"

# Récupérer les informations du moniteur en format JSON
MONITOR_JSON=$(hyprctl -j monitors)

# Extraire la valeur du champ "transform" pour le moniteur spécifié
CURRENT_TRANSFORM=$(echo "$MONITOR_JSON" | jq -r '.[] | select(.name=="'"$MONITOR_NAME"'") | .transform')

# Vérifier si jq est installé
if [ -z "$CURRENT_TRANSFORM" ]; then
  echo "Erreur : jq n'est pas installé ou le moniteur spécifié n'existe pas."
  exit 1
fi

# Basculer la rotation en fonction de la valeur actuelle du transform
if [ "$CURRENT_TRANSFORM" -eq 0 ]; then
  # Si la rotation est normale (0), on la change à 90°
  hyprctl keyword monitor ,transform,1
else
  # Sinon, on la remet à normale (0)
  hyprctl keyword monitor ,transform,0
fi
