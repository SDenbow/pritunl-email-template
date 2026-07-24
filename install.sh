#!/usr/bin/env bash
set -Eeuo pipefail

SOURCE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/scripts/pritunl-email-template"
DEST="/usr/local/sbin/pritunl-email-template"
BACKUP_DIR="/root/pritunl-email-template-installer-backups"

log() { printf '[%(%Y-%m-%d %H:%M:%S)T] %s\n' -1 "$*"; }
die() { log "ERROR: $*" >&2; exit 1; }

(( EUID == 0 )) || die "Run this installer as root."
[[ -f "$SOURCE" ]] || die "Source file not found: $SOURCE"
bash -n "$SOURCE"
if command -v shellcheck >/dev/null 2>&1; then shellcheck -x "$SOURCE"; fi
mkdir -p "$BACKUP_DIR"
chmod 0700 "$BACKUP_DIR"
if [[ -f "$DEST" ]]; then
  cp -a "$DEST" "${BACKUP_DIR}/pritunl-email-template.$(date +%F-%H%M%S)"
fi
temp="${DEST}.new.$$"
trap 'rm -f -- "$temp"' EXIT
install -o root -g root -m 0700 "$SOURCE" "$temp"
bash -n "$temp"
mv -f "$temp" "$DEST"
trap - EXIT
[[ "$(sha256sum "$SOURCE" | awk '{print $1}')" == "$(sha256sum "$DEST" | awk '{print $1}')" ]] || die "Installed checksum mismatch."
log "Installed: $DEST"
log "Run: sudo pritunl-email-template --check"
