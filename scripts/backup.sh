#!/bin/bash

echo "==== Energiemonitoring-Tool Backup ===="

# Arbeitsverzeichnis ist das Hauptverzeichnis des Projekts
cd "$(dirname "$0")/.." || exit

# Aktuelles Datum für den Backup-Namen
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="./backups"
BACKUP_FILE="$BACKUP_DIR/backup_$DATE.tar.gz"

# Backup-Verzeichnis erstellen, falls nicht vorhanden
mkdir -p "$BACKUP_DIR"

# Konfigurationen sichern
echo "Sichere Konfigurationsdateien..."
tar -czf "$BACKUP_FILE" config .env docker-compose.yml

# InfluxDB-Backup (Beispiel mit influx CLI Befehl)
echo "Sichere InfluxDB-Daten..."
# Hier würdest du den eigentlichen InfluxDB-Backup-Befehl einfügen
# Dies ist ein Platzhalter, da der genaue Befehl von deiner Konfiguration abhängt

echo "==== Backup abgeschlossen: $BACKUP_FILE ===="