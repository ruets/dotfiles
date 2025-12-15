#!/usr/bin/env bash
set -euo pipefail

### -----------------------------
### Helpers (UI: gum if available)
### -----------------------------
has_gum() { command -v gum >/dev/null 2>&1; }
ask_yes_no() {
  local prompt="$1"
  if has_gum; then
    gum confirm "$prompt"
    return $?
  fi
  local a
  while true; do
    read -rp "$prompt (y/n) " a
    case "$a" in [Yy]*) return 0 ;; [Nn]*) return 1 ;; *) echo "Please answer y/n." ;; esac
  done
}
ask_string() {
  local prompt="$1" def="${2:-""}"
  if has_gum; then
    gum input --placeholder "$prompt" --value "$def"
  else
    local v
    read -rp "$prompt ${def:+[$def]}: " v
    echo "${v:-$def}"
  fi
}
say() { echo -e "\033[1;96m$*\033[0m"; }
warn() { echo -e "\033[1;93m$*\033[0m"; }
err() { echo -e "\033[1;91m$*\033[0m" >&2; }

### -----------------------------
### Prerequisites
### -----------------------------
for bin in git openssl; do
  command -v "$bin" >/dev/null 2>&1 || {
    err "Missing: $bin"
    exit 1
  }
done
if command -v docker >/dev/null 2>&1; then
  if docker compose version >/dev/null 2>&1; then DC=(docker compose); else DC=(docker-compose); fi
else
  err "Docker not found."
  exit 1
fi

### -----------------------------
### Choose directory
### -----------------------------
DEFAULT_DIR="$HOME/services"
TARGET_DIR=$(ask_string "Directory to init into" "$DEFAULT_DIR")
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

### -----------------------------
### Secrets folder
### -----------------------------
SECDIR="./secrets"
mkdir -p "$SECDIR"

### -----------------------------
### .env setup & questions
### -----------------------------
ENV_FILE=".env"
touch "$ENV_FILE"
# Helper to read a value from the .env file
get_kv() {
  # grep for key=value, take first match, return everything after first "="
  grep -E "^${1}=" "$ENV_FILE" | head -n 1 | cut -d'=' -f2-
}

DOMAIN_NAME=$(ask_string "Main domain name" "$(get_kv DOMAIN_NAME)")
GENERIC_TIMEZONE=$(ask_string "IANA Timezone" "$(get_kv GENERIC_TIMEZONE || echo 'Europe/Paris')")

# Default for SSL_EMAIL depends on DOMAIN_NAME, which may have just been entered
DEFAULT_SSL_EMAIL=$(get_kv SSL_EMAIL)
if [[ -z "$DEFAULT_SSL_EMAIL" && -n "$DOMAIN_NAME" ]]; then
  DEFAULT_SSL_EMAIL="user@$DOMAIN_NAME"
fi
SSL_EMAIL=$(ask_string "Let's Encrypt/ACME Email" "$DEFAULT_SSL_EMAIL")

MAIN_USER=$(ask_string "Main admin username" "$(get_kv MAIN_USER || echo 'admin')")

# Conditionally ask for SMTP secrets only if they don't already exist
SMTP_USER=""
if ! [[ -s "$SECDIR/smtp_user" ]]; then
  SMTP_USER=$(ask_string "SMTP username (Proton Bridge: 'info' output)" "")
else
  say "Secret 'smtp_user' already exists, skipping prompt."
fi

SMTP_PASS=""
if ! [[ -s "$SECDIR/smtp_pass" ]]; then
  SMTP_PASS=$(ask_string "SMTP password (Proton Bridge: 'info' output)" "")
else
  say "Secret 'smtp_pass' already exists, skipping prompt."
fi

LDAP_BASE_DN=$(echo "$DOMAIN_NAME" | awk -F. '{for(i=1;i<=NF;i++){printf "dc=%s", $i; if(i<NF) printf ","}}')

### -----------------------------
### Write .env (simple merge)
### -----------------------------
say "Writing $ENV_FILE"
set_kv() {
  local k="$1" v="$2"
  if grep -qE "^${k}=" "$ENV_FILE"; then
    sed -i "s|^${k}=.*|${k}=${v//|/\\|}|" "$ENV_FILE"
  else
    printf "%s=%s\n" "$k" "$v" >>"$ENV_FILE"
  fi
}
set_kv DOMAIN_NAME "$DOMAIN_NAME"
set_kv LDAP_BASE_DN "$LDAP_BASE_DN"
set_kv GENERIC_TIMEZONE "$GENERIC_TIMEZONE"
set_kv SSL_EMAIL "$SSL_EMAIL"
set_kv MAIN_USER "$MAIN_USER"

### -----------------------------
### Generate secrets
### -----------------------------
rand32() { openssl rand -base64 32; }
write_secret() {
  local secname="${1:?missing secret name}"
  local value="${2-""}" path="$SECDIR/$secname"
  [ -z "${value+x}" ] && value=""

  if [[ -s "$path" ]]; then
    say "Keeping existing secret: $secname"
    return
  fi

  printf "%s" "$value" >"$path"
  chmod 600 "$path"
  say "→ $path"
}

say "Generating Authelia/LLDAP/SMTP secrets"
write_secret authelia_jwt_secret "$(rand32)"
write_secret authelia_session_secret "$(rand32)"
write_secret authelia_storage_encryption_key "$(rand32)"
write_secret authelia_oidc_hmac_secret "$(rand32)"
write_secret authelia_oidc_actual_secret "$(rand32)"
write_secret authelia_oidc_linkding_secret "$(rand32)"
write_secret lldap_jwt_secret "$(rand32)"
write_secret lldap_key_seed "$(rand32)"
write_secret admin_pass "$(rand32)"

OIDC_PRIV="$SECDIR/authelia_oidc_private_key.pem"
OIDC_PUB="$SECDIR/authelia_oidc_public_key.pem"
if [[ -s "$OIDC_PRIV" && -s "$OIDC_PUB" ]]; then
  say "OIDC keys already present."
else
  say "Generating OIDC RSA 4096 keys"
  openssl genrsa -out "$OIDC_PRIV" 4096 >/dev/null 2>&1
  chmod 600 "$OIDC_PRIV"
  openssl rsa -in "$OIDC_PRIV" -pubout -out "$OIDC_PUB" >/dev/null 2>&1
fi

[[ -n "$SMTP_USER" ]] && write_secret smtp_user "$SMTP_USER"
[[ -n "$SMTP_PASS" ]] && write_secret smtp_pass "$SMTP_PASS"

### -----------------------------
### Launch
### -----------------------------
ask_yes_no "Proceed with Docker Compose setup?" || {
  warn "Aborted by user."
  exit 1
}
"${DC[@]}" --profile neko up --no-start
"${DC[@]}" up -d
say "Containers started."

say "🎉 Done.
- Repo: $(pwd)
- .env filled
- Secrets in $SECDIR
"
