#!/usr/bin/env bash
# /usr/local/bin/notify.sh — zentraler Notification-Dispatcher
# Deployed by: notification-relay
# Usage: notify.sh "Betreff" "Nachricht"

set -euo pipefail

SUBJECT="${1:-(kein Betreff)}"
BODY="${2:-(kein Text)}"
RECIPIENT="oberbreyer.stefan@gmail.com"

printf "To: %s\nSubject: [Pi] %s\n\n%s\n" \
  "$RECIPIENT" "$SUBJECT" "$BODY" \
  | sudo msmtp "$RECIPIENT"
