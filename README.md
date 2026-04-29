# PocketMyth (Godot 4 Prototyp)

Spielbarer 2D Creature-Collector-RPG-Prototyp in düsterem Pixel-Look.

## Features im Build
- Startmenü (Neues Spiel/Laden/Beenden)
- Starterwahl (Flammulus/Nymbri/Scarabun)
- Top-Down Startgebiet (Aigaion-Archipel)
- Wildgras-Encounters
- Rundenkampf: Attacke/Wechseln/Fangen/Fliehen
- Teammenü mit Grid-ähnlicher Liste + Detailpanel
- Fangsystem mit Myth Shards
- Erste Arena: Tempel der Wellen (Kleia)
- Save/Load (JSON in `user://`)
- Datenstruktur für weitere Arenen und Champion Maelor

## Start in Godot 4
1. Godot 4 öffnen
2. `project.godot` importieren
3. Projekt starten (`F5`)

## Steuerung
- Bewegung: WASD
- Teammenü: `T`
- Speichern: `F5`

## Projektstruktur
- `scenes/`: MainMenu, StarterSelect, World, Battle
- `scripts/`: Gameplay-Logik
- `data/`: Creature-/Moves-/Arena-Daten
- `ui/`: Team-Menü
- `assets/`: Platzhalter für spätere Pixel-Art-Sprites
