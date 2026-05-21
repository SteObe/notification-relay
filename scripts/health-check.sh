#!/bin/bash
# /usr/local/bin/health-check.sh — tägliche System-Gesundheitsprüfung

MSG=""

# Disk-Füllstand /mnt/nvme
USED_PCT=$(df /mnt/nvme --output=pcent 2>/dev/null | tail -1 | tr -d ' %')
[ "${USED_PCT:-0}" -ge 85 ] && MSG+="Disk: ${USED_PCT}% belegt  "

# Fehlgeschlagene Systemd-Services
FAILED=$(systemctl list-units --state=failed --no-legend --plain 2>/dev/null | awk '{print $1}' | tr '\n' ' ')
[ -n "$FAILED" ] && MSG+="Failed services: $FAILED  "

# Neustart erforderlich
[ -f /var/run/reboot-required ] && MSG+="Neustart erforderlich  "

# Docker-Container gestoppt
STOPPED=$(docker ps --filter "status=exited" --filter "status=dead" --format "{{.Names}}" 2>/dev/null | tr '\n' ' ')
[ -n "$STOPPED" ] && MSG+="Container gestoppt: $STOPPED  "

# System-Updates verfügbar
UPDATES=$(apt list --upgradable 2>/dev/null | grep -c '\[' || true)
[ "${UPDATES:-0}" -gt 0 ] && MSG+="Updates verfügbar: ${UPDATES} Pakete  "

# Zertifikats-Ablauf (NPM Let's Encrypt, < 14 Tage)
for cert in /mnt/nvme/docker/nginx-proxy-manager/npm/letsencrypt/live/*/fullchain.pem; do
  [ -f "$cert" ] || continue
  EXPIRY=$(openssl x509 -enddate -noout -in "$cert" 2>/dev/null | cut -d= -f2)
  [ -z "$EXPIRY" ] && continue
  EXPIRY_TS=$(date -d "$EXPIRY" +%s 2>/dev/null) || continue
  DAYS=$(( (EXPIRY_TS - $(date +%s)) / 86400 ))
  NAME=$(basename "$(dirname "$cert")")
  [ "$DAYS" -lt 14 ] && MSG+="Zertifikat ${NAME} läuft in ${DAYS}d ab  "
done

[ -z "$MSG" ] && exit 0

/usr/local/bin/notify.sh "System-Warnung – Pi" "${MSG%  }"
