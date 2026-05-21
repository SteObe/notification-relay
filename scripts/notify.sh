#!/usr/bin/env bash
set -euo pipefail

SUBJECT="${1:-Benachrichtigung}"
BODY="${2:-Kein Text angegeben}"
TO="${SMTP_TO:-oberbreyer.stefan@gmail.com}"
FROM="${SMTP_FROM:-oberbreyer.stefan@gmail.com}"

{
  echo "From: ${FROM}"
  echo "To: ${TO}"
  echo "Subject: ${SUBJECT}"
  echo
  echo "${BODY}"
} | docker exec -i smtp-relay sendmail -t
