#!/bin/bash
# /usr/local/bin/nvme-health-check.sh — NVMe Gesundheitsprüfung
# Deployed by: notification-relay

OUT=$(nvme smart-log /dev/nvme0 2>&1)
if [ $? -ne 0 ]; then
  /usr/local/bin/notify.sh "NVMe Fehler – Pi" "nvme smart-log fehlgeschlagen: $OUT"
  exit 0
fi

WARN=$(echo "$OUT" | grep -oP 'critical_warning\s*:\s*\K0x[0-9a-fA-F]+' || true)
USED=$(echo "$OUT" | grep -oP 'percentage_used\s*:\s*\K[0-9]+' || true)

MSG=""
[ -n "$WARN" ] && [ "$WARN" != "0x0" ] && MSG+="critical_warning=$WARN  "
[ "${USED:-0}" -ge 90 ] && MSG+="percentage_used=${USED}%"

[ -z "$MSG" ] && exit 0

/usr/local/bin/notify.sh "NVMe Warnung – Pi" "$MSG"
