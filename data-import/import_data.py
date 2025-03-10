#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import pandas as pd
import datetime
from dotenv import load_dotenv
from pathlib import Path
from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS

# Lade Umgebungsvariablen aus der .env-Datei
env_path = Path(__file__).parents[1] / '.env'
load_dotenv(dotenv_path=env_path)

# InfluxDB-Verbindungsparameter
INFLUXDB_URL = "http://localhost:8086"
INFLUXDB_TOKEN = os.getenv("INFLUXDB_TOKEN")
INFLUXDB_ORG = os.getenv("INFLUXDB_ORG")
INFLUXDB_BUCKET = os.getenv("INFLUXDB_BUCKET")

def connect_to_influxdb():
    """Verbindung zu InfluxDB herstellen"""
    try:
        client = InfluxDBClient(url=INFLUXDB_URL, token=INFLUXDB_TOKEN, org=INFLUXDB_ORG)
        return client
    except Exception as e:
        print(f"Fehler bei der Verbindung zu InfluxDB: {e}")
        sys.exit(1)

def import_csv_data(file_path, measurement_name, customer_id=None):
    """
    Importiert Lastgangdaten aus einer CSV-Datei in InfluxDB
    
    Erwartet eine CSV mit folgenden Spalten:
    - timestamp: Zeitstempel im Format 'YYYY-MM-DD HH:MM:SS'
    - value: Messwert (z.B. Leistung in kW)
    
    Optionale Spalten:
    - meter_id: ID des Zählers
    - phase: Phasenbezeichnung (bei mehrphasigen Messungen)
    - type: Art der Messung (z.B. "consumption", "production")
    """
    print(f"Importiere Daten aus {file_path}...")
    
    # CSV-Datei laden
    try:
        df = pd.read_csv(file_path, parse_dates=['timestamp'])
    except Exception as e:
        print(f"Fehler beim Laden der CSV-Datei: {e}")
        return False
    
    # Verbindung zu InfluxDB herstellen
    client = connect_to_influxdb()
    write_api = client.write_api(write_options=SYNCHRONOUS)
    
    # Daten in Points umwandeln und in InfluxDB schreiben
    points = []
    for _, row in df.iterrows():
        point = Point(measurement_name)
        
        # Zeitstempel setzen
        point.time(row['timestamp'], WritePrecision.NS)
        
        # Wert hinzufügen
        point.field("value", float(row['value']))
        
        # Tags hinzufügen
        if customer_id:
            point.tag("customer_id", customer_id)
        
        if 'meter_id' in df.columns:
            point.tag("meter_id", str(row['meter_id']))
            
        if 'phase' in df.columns:
            point.tag("phase", str(row['phase']))
            
        if 'type' in df.columns:
            point.tag("type", str(row['type']))
        
        points.append(point)
    
    # Daten in Batches schreiben (je 1000 Punkte)
    batch_size = 1000
    for i in range(0, len(points), batch_size):
        batch = points[i:i+batch_size]
        try:
            write_api.write(bucket=INFLUXDB_BUCKET, record=batch)
            print(f"Batch {i//batch_size + 1}/{(len(points)-1)//batch_size + 1} geschrieben")
        except Exception as e:
            print(f"Fehler beim Schreiben von Batch {i//batch_size + 1}: {e}")
    
    client.close()
    print(f"Import abgeschlossen: {len(points)} Datenpunkte importiert.")
    return True

def main():
    """Hauptfunktion"""
    if len(sys.argv) < 3:
        print("Verwendung: python import_data.py <csv_datei> <measurement_name> [customer_id]")
        print("Beispiel: python import_data.py lastgang_2023.csv power_consumption customer_123")
        sys.exit(1)
    
    file_path = sys.argv[1]
    measurement_name = sys.argv[2]
    customer_id = sys.argv[3] if len(sys.argv) > 3 else None
    
    if not os.path.exists(file_path):
        print(f"Datei nicht gefunden: {file_path}")
        sys.exit(1)
    
    import_csv_data(file_path, measurement_name, customer_id)

if __name__ == "__main__":
    main()