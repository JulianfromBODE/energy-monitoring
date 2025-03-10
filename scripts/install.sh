#!/bin/bash

echo "==== Energiemonitoring-Tool Installation ===="

# Prüfen, ob Docker installiert ist
if ! command -v docker &> /dev/null; then
    echo "Docker ist nicht installiert. Bitte installiere Docker und Docker Compose."
    exit 1
fi

# Prüfen, ob Docker Compose installiert ist
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose ist nicht installiert. Bitte installiere Docker Compose."
    exit 1
fi

# Arbeitsverzeichnis ist das Hauptverzeichnis des Projekts
cd "$(dirname "$0")/.." || exit

# Container starten
echo "Starte Container..."
docker-compose up -d

echo "Warte auf Initialisierung der Dienste (30 Sekunden)..."
sleep 30

echo "==== Installation abgeschlossen ===="
echo "InfluxDB ist unter http://localhost:8086 erreichbar"
echo "Grafana ist unter http://localhost:3000 erreichbar"
echo "Home Assistant ist unter http://localhost:8123 erreichbar"
echo ""
echo "Du kannst dich mit folgenden Zugangsdaten anmelden:"
echo "InfluxDB: $(grep INFLUXDB_USERNAME .env | cut -d '=' -f2)/$(grep INFLUXDB_PASSWORD .env | cut -d '=' -f2)"
echo "Grafana: $(grep GRAFANA_USERNAME .env | cut -d '=' -f2)/$(grep GRAFANA_PASSWORD .env | cut -d '=' -f2)"
echo ""
echo "Für Home Assistant musst du bei der ersten Anmeldung einen Benutzer erstellen."