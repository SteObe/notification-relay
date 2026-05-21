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

[ -z "$MSG" ] && exit 0

/usr/local/bin/notify.sh "System-Warnung – Pi" "${MSG%  }"
