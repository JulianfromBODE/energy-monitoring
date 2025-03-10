@echo off
echo ==== Energiemonitoring-Tool Installation ====

REM Prüfen, ob Docker installiert ist
where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Docker ist nicht installiert. Bitte installiere Docker und Docker Compose.
    exit /b 1
)

REM Prüfen, ob Docker Compose installiert ist
where docker-compose >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Docker Compose ist nicht installiert. Bitte installiere Docker Compose.
    exit /b 1
)

REM Zum Hauptverzeichnis wechseln
cd /d "%~dp0\.."

REM Container starten
echo Starte Container...
docker-compose up -d

echo Warte auf Initialisierung der Dienste (30 Sekunden)...
timeout /t 30 /nobreak >nul

echo ==== Installation abgeschlossen ====
echo InfluxDB ist unter http://localhost:8086 erreichbar
echo Grafana ist unter http://localhost:3000 erreichbar
echo Home Assistant ist unter http://localhost:8123 erreichbar
echo.
echo Du kannst dich mit folgenden Zugangsdaten anmelden:
for /f "tokens=2 delims==" %%a in ('type .env ^| findstr INFLUXDB_USERNAME') do set IUSER=%%a
for /f "tokens=2 delims==" %%a in ('type .env ^| findstr INFLUXDB_PASSWORD') do set IPASS=%%a
for /f "tokens=2 delims==" %%a in ('type .env ^| findstr GRAFANA_USERNAME') do set GUSER=%%a
for /f "tokens=2 delims==" %%a in ('type .env ^| findstr GRAFANA_PASSWORD') do set GPASS=%%a
echo InfluxDB: %IUSER%/%IPASS%
echo Grafana: %GUSER%/%GPASS%
echo.
echo Für Home Assistant musst du bei der ersten Anmeldung einen Benutzer erstellen.