# Energiemonitoring-Tool

Ein Tool zur Speicherung, Visualisierung und Analyse von Energiedaten mit InfluxDB, Grafana und Home Assistant.

## Funktionen

- Echtzeit-Datenerfassung über Home Assistant
- Langzeitdatenspeicherung in InfluxDB
- Visualisierung und Analyse mit Grafana-Dashboards
- Einfacher Import historischer Lastgangdaten

## Voraussetzungen

- Docker und Docker Compose
- Git (optional, für Updates)
- Python 3.8+ (für Datenimport-Skripte)

## Installation

1. Repository klonen:
   ```bash
   git clone https://github.com/dein-benutzername/energy-monitoring.git
   cd energy-monitoring
   ```

2. Konfiguration anpassen:
   - Bearbeite die `.env`-Datei und passe die Zugangsdaten an
   - Passe ggf. die Docker-Compose-Datei an deine Bedürfnisse an

3. Installation starten:
   ```bash
   ./scripts/install.sh
   ```

4. Nach der Installation kannst du auf folgende Dienste zugreifen:
   - InfluxDB: http://localhost:8086
   - Grafana: http://localhost:3000
   - Home Assistant: http://localhost:8123

## Datenimport

Um historische Lastgangdaten zu importieren:

1. Installiere die Python-Abhängigkeiten:
   ```bash
   cd data-import
   pip install -r requirements.txt
   ```

2. Führe das Import-Skript aus:
   ```bash
   python import_data.py pfad/zur/datei.csv measurement_name [kunden_id]
   ```

   Die CSV-Datei sollte mindestens folgende Spalten enthalten:
   - `timestamp`: Zeitstempel im Format 'YYYY-MM-DD HH:MM:SS'
   - `value`: Messwert (z.B. Leistung in kW)

   Optionale Spalten:
   - `meter_id`: ID des Zählers
   - `phase`: Phasenbezeichnung
   - `type`: Art der Messung (z.B. "consumption", "production")

## Wartung

### Updates

Um die neuesten Änderungen zu erhalten:

```bash
./scripts/update.sh
```

### Backup

Um ein Backup deiner Konfiguration zu erstellen:

```bash
./scripts/backup.sh
```

Die Backup-Dateien werden im Verzeichnis `./backups` gespeichert.

### Wiederherstellung

Um ein Backup wiederherzustellen:

```bash
./scripts/restore.sh ./backups/backup_YYYY-MM-DD_HH-MM-SS.tar.gz
```

## Konfiguration von Home Assistant für InfluxDB

Nach der Installation musst du Home Assistant so konfigurieren, dass es Daten an InfluxDB sendet. Füge folgende Konfiguration zu deiner `configuration.yaml` hinzu:

```yaml
influxdb:
  host: influxdb
  port: 8086
  token: !secret influxdb_token
  organization: !secret influxdb_org
  bucket: !secret influxdb_bucket
  ssl: false
  verify_ssl: false
  exclude:
    domains:
      - persistent_notification
    entities:
      - sun.sun
    entity_globs:
      - sensor.weather_*
```

Füge außerdem diese Zeilen zu deiner `secrets.yaml` hinzu:

```yaml
influxdb_token: dein_token_aus_env_datei
influxdb_org: dein_org_aus_env_datei
influxdb_bucket: dein_bucket_aus_env_datei
```

## Lizenz

MIT