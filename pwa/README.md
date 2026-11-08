# Moro als PWA

Dieselbe App wie das Artefakt `moro.html`, aber als installierbare Web-App:

- **Echte Tage statt Simulation:** Der Tag ergibt sich aus dem Startdatum. Es gibt keine Knöpfe „Tag weiter“ oder „Woche vorspulen“ und keine Beispieldaten. Moro startet als Ei.
- **Aufgeräumte Ansicht:** Ohne Prototyp-Steuerung, Darkmode, Highres-Grafik. Im Verlauf stehen Datumsangaben statt „Tag 19“.
- **Offline:** Ein Service Worker speichert die App. Nach dem ersten Öffnen funktioniert sie ohne Internet.
- **Daten:** Bleiben nur auf dem Gerät (im Browser-Speicher). Kein Konto, kein Server.

## Dateien

| Datei | Zweck |
|---|---|
| `index.html` | Die App. **Nicht von Hand bearbeiten**, wird aus `../moro.html` gebaut. Liegt nicht im Repository (`.gitignore`), der Workflow baut sie beim Veröffentlichen. |
| `manifest.webmanifest` | Name, Farben und Icons für die Installation |
| `sw.js` | Service Worker für den Offline-Betrieb |
| `icons/` | App-Icons (32, 180, 192, 512, maskierbar 512) |
| `build.ps1` | Baut `index.html` aus `../moro.html` und erneuert die Cache-Version |
| `tools/serve.ps1` | Kleiner lokaler Webserver auf Port 8765 |
| `tools/icons.html` | Erzeugt die Icons neu (nur über `serve.ps1`) |

## Änderungen an der App

1. In `moro.html` ändern (wie bisher beim Artefakt).
2. Zum lokalen Testen bauen (fürs Veröffentlichen nicht nötig, das erledigt der Workflow):

   ```bash
   pwsh -File pwa/build.ps1
   ```

3. Wenn sich die Figur geändert hat und die Icons mitziehen sollen: Server starten und `http://localhost:8765/tools/icons.html` öffnen.

## Lokal testen

```bash
pwsh -File pwa/tools/serve.ps1
```

Dann `http://localhost:8765/` im Browser öffnen. Service Worker funktionieren nur über `localhost` oder `https`, nicht über eine geöffnete Datei.

## Veröffentlichen

Das Repository `AgentK42/Tamagotchi` baut `pwa/` bei jedem Push auf `main` mit `build.ps1` aus dem aktuellen `moro.html` und veröffentlicht es automatisch über GitHub Pages (Workflow `.github/workflows/pages.yml`) unter **https://agentk42.github.io/Tamagotchi/**. Ein vergessener Build kann also keine veraltete App mehr veröffentlichen. Einmalig muss im Repository unter Settings → Pages die Quelle „GitHub Actions“ gewählt sein.

Alternativ geht jeder andere statische Webspace mit **https**, zum Beispiel:

- **Netlify Drop:** Erst `build.ps1` ausführen, dann den Ordner `pwa` auf app.netlify.com/drop ziehen.
- **GitHub Pages:** Den Inhalt von `pwa/` in ein Repository legen und Pages aktivieren.

`tools/` muss nicht mit hochgeladen werden.

## Auf dem Handy installieren

- **iPhone (Safari):** Seite öffnen → Teilen → „Zum Home-Bildschirm“.
- **Android (Chrome):** Seite öffnen → Menü → „App installieren“.

## Noch nicht enthalten

Push-Erinnerungen, Apple Health oder Strava, Widgets und soziale Funktionen stehen im [Backlog](../BACKLOG.md).
