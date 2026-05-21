#!/bin/bash
# /usr/local/bin/restic-check.sh — wöchentliche Backup-Integritätsprüfung

ERRORS=""

check_repo() {
  local repo="$1"
  local label="$2"
  OUT=$(RESTIC_PASSWORD_FILE=/etc/restic-password restic -r "$repo" check 2>&1)
  if [ $? -ne 0 ]; then
    ERRORS+="${label}: ${OUT}\n\n"
  fi
}

check_repo /mnt/nvme/restic-backup "NVMe"

if mountpoint -q /mnt/usb-backup 2>/dev/null; then
  check_repo /mnt/usb-backup/restic-backup "USB"
fi

if [ -n "$ERRORS" ]; then
  /usr/local/bin/notify.sh "Backup-Integritätsfehler – Pi" "$(printf '%b' "$ERRORS")"
fi
