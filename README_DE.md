# yoce_de — Deutsches Eingabeschema für Rime

[English](README.md) | [简体中文](README_CN.md) | Deutsch

`yoce_de` ist ein einsteigerfreundliches deutsches Eingabeschema für Rime. Es kombiniert ein Schema, einen Lua-Translator und ein Deutsch-Englisch-Wörterbuch, damit sich Deutsch natürlicher eingeben lässt.

## Funktionen
- Deutsche Zeichen: `ä`, `ö`, `ü`, `ß` und Großbuchstaben
- Alternative Schreibweisen: `ae`, `oe`, `ue` und `ss`
- Zusammengeschriebene Eingabe und Wortgruppen, zum Beispiel `dubist` -> `du bist`
- Präfix-Vervollständigung, zum Beispiel `kom` -> `kommen`, `kommt` und `komisch`
- Wörter mit Bindestrich, zum Beispiel `U-Bahn`
- Englische Bedeutungen als Kandidaten-Kommentar

## Projektdateien
| Datei | Zweck |
| --- | --- |
| `yoce_de.schema.yaml` | Registrierung und Einstellungen des Rime-Schemas |
| `lua/yoce_de.lua` | Eigener Translator und Wortgruppen-Erkennung |
| `yoce_de.txt` | Deutsch-Englisch-Wörterbuch (`Deutsch<Tab>Englisch`) |

## Installation

### Variante 1: Dateien manuell kopieren
Zuerst ein Rime-Frontend installieren und danach die Projektdateien in dessen Rime-Benutzerverzeichnis kopieren:

| Plattform / Frontend | Rime-Benutzerverzeichnis oder Aktion |
| --- | --- |
| Windows / Weasel | Rechtsklick auf das Weasel-Symbol im Tray und **Benutzerordner** öffnen |
| macOS / Squirrel | Rechtsklick auf das Eingabemenü und **Benutzereinstellungen** öffnen; meist `~/Library/Rime` |
| Linux / Fcitx5 | Meist `~/.local/share/fcitx5/rime`; vorher `fcitx5-rime` und Lua-Unterstützung installieren |
| Linux / iBus | Meist `~/.config/ibus/rime`; vorher `ibus-rime` und Lua-Unterstützung installieren |
| Android / Trime | Trimes Benutzerdatenverzeichnis sowie Import-/Deploy-Funktion verwenden |

Die Struktur im Benutzerverzeichnis muss so aussehen:
```text
<rime-user-dir>/
├── yoce_de.schema.yaml
├── yoce_de.txt
└── lua/
  └── yoce_de.lua
```

Danach:
1. Über das Tray- oder Einstellungsmenü des Frontends **Deploy** ausführen.
2. Im Schema-Umschalter `yoce_de` (`Yoce Deutsch`) auswählen.
3. Zum Test `du`, `dubist`, `kom` oder `U-Bahn` eingeben.

Benutzerverzeichnis und Menübezeichnungen unterscheiden sich je nach Frontend. `yoce_de.lua` gehört in das Unterverzeichnis `lua/`, nicht neben die Schema-Datei.

### Variante 2: Kopieren über die Kommandozeile
Wenn das Projekt ausgecheckt ist, können die Dateien per Kommandozeile kopiert werden. Beispiel für Fcitx5:
```bash
rime_dir="$HOME/.local/share/fcitx5/rime"
mkdir -p "$rime_dir/lua"
cp yoce_de.schema.yaml yoce_de.txt "$rime_dir/"
cp lua/yoce_de.lua "$rime_dir/lua/"
```
Danach im Frontend **Deploy** ausführen. Für iBus `rime_dir` auf `~/.config/ibus/rime` setzen.

### Linux-Abhängigkeiten
Der Lua-Translator benötigt ein aktuelles `librime` mit Lua-Unterstützung. Die Paketnamen unterscheiden sich je nach Distribution:
- Debian/Ubuntu/Arch: das Paket `fcitx5-rime` oder `ibus-rime` installieren; falls das Lua-Plugin separat angeboten wird, zusätzlich `librime-lua` oder `librime-plugin-lua` installieren.
- Fedora und Systeme mit fehlendem oder veraltetem Lua-Plugin: ein gepflegtes Flatpak, das [ibus-rime AppImage](https://github.com/hchunhui/ibus-rime.AppImage) oder ein selbst kompiliertes `librime` mit zusammengeführten Plugins verwenden.
- Für Fcitx5 `fcitx5-rime` installieren, nicht das veraltete `fcitx-rime`.

## Ausprobieren
Beispiele für Wörterbuch-Einträge:
```text
du	you
bist	are
U-Bahn	subway
Spaß	fun
Überstunden	overtime
```

Nach dem Deployen können `du`, `dubist`, `kom` oder `U-Bahn` eingegeben und anschließend passende Kandidaten ausgewählt werden.

## Wörterbuch anpassen
In `yoce_de.txt` kann pro Zeile ein Eintrag ergänzt werden:
```text
Deutsch<Tab>English meaning
```
Nach Änderungen am Wörterbuch Rime erneut deployen.

## Lizenz
Dieses Projekt ist als lokale Anpassung für Rime gedacht und darf für den persönlichen Gebrauch angepasst werden. Bei einer Weitergabe bitte die ursprüngliche Zuordnung beibehalten und die Lizenzbedingungen des Rime-Ökosystems sowie der Wörterbuchquellen beachten.
