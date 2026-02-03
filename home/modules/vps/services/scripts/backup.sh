#!/usr/bin/env bash
# -----------------------------------------
# Restic backup + prune + init
# Dotfiles-ready
# -----------------------------------------

set -euo pipefail
IFS=$'\n\t'

# --- Charger variables depuis .env si existant ---
ENV_FILE="$HOME/.config/home-manager/env/.env.backup"
if [ -f "$ENV_FILE" ]; then
  echo "Chargement des variables depuis $ENV_FILE..."
  source "$ENV_FILE"
fi

# --- Vérification Restic ---
echo "Vérification de Restic..."
if ! command -v restic &>/dev/null; then
  echo "Restic n'est pas installé. Installe-le avant de continuer."
  exit 1
fi

# --- Vérification variables ---
for var in RESTIC_REPOSITORY RESTIC_PASSWORD AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY; do
  if [ -z "${!var:-}" ]; then
    echo "❌ Variable $var non définie. Remplis ton .env ou l'environnement."
    exit 1
  fi
done

# --- INIT ---
echo "Vérification du repo Restic..."
if restic snapshots &>/dev/null; then
  echo "Le repo existe déjà. Init ignoré."
else
  echo "Repo non trouvé. Initialisation du repo Restic..."
  restic init
fi

# --- BACKUP ---
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$DATE] Démarrage du backup..."

restic backup \
  /home \
  /etc \
  /var/lib/docker/volumes \
  --exclude "/etc/mtab" \
  --exclude "/etc/.pwd.lock" \
  --exclude "/var/lib/docker/volumes/tmp" \
  --tag "daily"

echo "[$DATE] Backup terminé. Derniers snapshots :"
restic snapshots --last 5

# --- PRUNE / RETENTION ---
echo "[$DATE] Application de la retention..."
restic forget \
  --keep-daily 7 \
  --keep-weekly 4 \
  --prune

echo "[$DATE] Backup + prune terminé. ✅"
