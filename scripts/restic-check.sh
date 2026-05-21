#!/bin/bash
# /usr/local/bin/restic-check.sh — wöchentliche Backup-Integritätsprüfung

OUT=$(RESTIC_PASSWORD_FILE=/etc/restic-password restic -r /mnt/nvme/restic-backup check 2>&1)
EXIT=$?

if [ "$EXIT" -ne 0 ]; then
  /usr/local/bin/notify.sh "Backup-Integritätsfehler – Pi" "$OUT"
fi
