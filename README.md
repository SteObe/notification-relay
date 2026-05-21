# Notification Relay

Zentraler SMTP-Relay-Dienst für Benachrichtigungen aus Systemskripten und Docker-Containern.

## Ziel

- E-Mail als verlässlicher Hauptkanal
- später optional Push als Zusatzkanal
- einheitlicher Versand über einen zentralen Dienst

## Dateien

- `docker-compose.yml` – SMTP-Relay Container
- `.env.example` – benötigte Variablen
- `scripts/notify.sh` – einfacher Mail-Versand per CLI

## Einrichtung auf dem Pi

```bash
ssh stefan@192.168.88.249
cd /opt/docker
sudo git clone https://github.com/SteObe/notification-relay.git
cd notification-relay
sudo cp .env.example .env
sudo nano .env
sudo docker compose up -d
```

## Testversand

```bash
cd /opt/docker/notification-relay
SMTP_TO=oberbreyer.stefan@gmail.com SMTP_FROM=oberbreyer.stefan@gmail.com ./scripts/notify.sh "Relay Test" "Testmail vom Notification Relay"
```

## Nutzung in anderen Skripten

```bash
/opt/docker/notification-relay/scripts/notify.sh "Backup erfolgreich" "Snapshot wurde erstellt"
```

## Sicherheit

- niemals echte Passwörter ins Repo committen
- nur App-Passwort für Gmail verwenden
- `.env` bleibt lokal auf dem Pi
