#!/bin/bash
# /usr/local/bin/notify-backup.sh — Backup-Ergebnis Benachrichtigung
# Deployed by: notification-relay
# Called by: restic-backup.service via systemd drop-in

EXIT_CODE=${1:-0}

if [ "$EXIT_CODE" -eq 0 ]; then
  /usr/local/bin/notify.sh \
    "Backup erfolgreich – Pi" \
    "restic-backup abgeschlossen  |  $(date '+%d.%m.%Y %H:%M')"
else
  /usr/local/bin/notify.sh \
    "Backup fehlgeschlagen – Pi" \
    "restic-backup Exit-Code: $EXIT_CODE  |  $(date '+%d.%m.%Y %H:%M')"
fi

exit 0
