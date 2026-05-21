#!/usr/bin/env bash
set -euo pipefail

SUBJECT="${1:-(kein Betreff)}"
BODY="${2:-(kein Text)}"
FROM="oberbreyer.stefan@gmail.com"
RECIPIENT="oberbreyer.stefan@gmail.com"
RELAY="127.0.0.1:2525"

curl -s \
  --url "smtp://${RELAY}" \
  --mail-from "$FROM" \
  --mail-rcpt "$RECIPIENT" \
  --upload-file - << EOF
From: $FROM
To: $RECIPIENT
Subject: [Pi] $SUBJECT

$BODY
EOF
