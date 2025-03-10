#!/bin/bash

echo "==== Energiemonitoring-Tool Update ===="

# Arbeitsverzeichnis ist das Hauptverzeichnis des Projekts
cd "$(dirname "$0")/.." || exit

# Git-Updates abrufen
if [ -d ".git" ]; then
    echo "Aktualisiere Repository..."
    git pull
fi

# Container neu starten mit aktuellen Images
echo "Aktualisiere Docker-Container..."
docker-compose pull
docker-compose up -d

echo "==== Update abgeschlossen ===="