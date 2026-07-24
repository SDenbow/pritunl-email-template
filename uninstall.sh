#!/usr/bin/env bash
set -Eeuo pipefail
DEST="/usr/local/sbin/pritunl-email-template"
(( EUID == 0 )) || { echo "ERROR: Run this uninstaller as root." >&2; exit 1; }
if [[ -f "$DEST" ]]; then
  rm -f "$DEST"
  echo "Removed $DEST"
else
  echo "$DEST is not installed."
fi
echo "Pritunl templates and backups were not changed."
