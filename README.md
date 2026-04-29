# PocketMyth (Godot 4 Prototyp)

Spielbarer 2D Creature-Collector-RPG-Prototyp in düsterem Pixel-Look.

## Browser spielen (ohne lokale Installation)
Dieses Repo enthält jetzt eine GitHub-Action für automatischen Web-Export.

### Variante A: GitHub Pages (empfohlen)
1. Repo auf GitHub pushen
2. In GitHub: **Settings → Pages** aktivieren (Source: GitHub Actions)
3. Workflow **Web Export** ausführen
4. Danach steht eine Pages-URL bereit, über die du direkt im Browser spielst

### Variante B: itch.io / Netlify
- Nutze den erzeugten `build/web`-Exportordner und lade ihn hoch.

## Lokaler Start in Godot 4
1. Godot 4 öffnen
2. `project.godot` importieren
3. Projekt starten (`F5`)

## Steuerung
- Bewegung: WASD
- Teammenü: `T`
- Speichern: `F5`

## Features im Build
- Startmenü (Neues Spiel/Laden/Beenden)
- Starterwahl (Flammulus/Nymbri/Scarabun)
- Top-Down Startgebiet (Aigaion-Archipel)
- Wildgras-Encounters
- Rundenkampf: Attacke/Wechseln/Fangen/Fliehen
- Teammenü mit Grid-ähnlicher Liste + Detailpanel
- Fangsystem mit Myth Shards
- Myth-Gauge / Mythenruf-Leiste (Basis-Implementierung)
- Erste Arena: Tempel der Wellen (Kleia)
- Save/Load (JSON in `user://`)
- Datenstruktur für weitere Arenen und Champion Maelor

## Projektstruktur
- `scenes/`: MainMenu, StarterSelect, World, Battle
- `scripts/`: Gameplay-Logik
- `data/`: Creature-/Moves-/Arena-Daten
- `ui/`: Team-Menü
- `assets/`: Platzhalter für spätere Pixel-Art-Sprites
- `.github/workflows/`: CI Web-Export + Deploy
