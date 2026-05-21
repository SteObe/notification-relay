#!/bin/bash
# /usr/local/bin/notify-ssh-login.sh — PAM SSH-Login Benachrichtigung
# Deployed by: notification-relay
# PAM config: session optional pam_exec.so /usr/local/bin/notify-ssh-login.sh

[ "$PAM_SERVICE" != "sshd"        ] && exit 0
[ "$PAM_TYPE"    != "open_session" ] && exit 0

/usr/local/bin/notify.sh \
  "SSH Login – Pi" \
  "Benutzer: ${PAM_USER:-?}  |  IP: ${PAM_RHOST:-lokal}  |  $(date '+%d.%m.%Y %H:%M:%S')" \
  > /dev/null 2>&1 &

exit 0
