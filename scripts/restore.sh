#!/bin/bash

if [ -z "$1" ]; then
    echo "Bitte gib den Pfad zur Backup-Datei an."
    echo "Verwendung: $0 /pfad/zur/backup_datei.tar.gz"
    exit 1
fi

BACKUP_FILE="$1"

echo "==== Energiemonitoring-Tool Wiederherstellung ===="
echo "Stelle Backup wieder her: $BACKUP_FILE"

# Arbeitsverzeichnis ist das Hauptverzeichnis des Projekts
cd "$(dirname "$0")/.." || exit

# Container stoppen
echo "Stoppe laufende Container..."
docker-compose down

# Konfigurationsdateien wiederherstellen
echo "Stelle Konfigurationsdateien wieder her..."
tar -xzf "$BACKUP_FILE"

# Container neu starten
echo "Starte Container neu..."
docker-compose up -d

echo "==== Wiederherstellung abgeschlossen ===="