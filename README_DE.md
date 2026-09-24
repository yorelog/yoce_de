# Deutsches Eingabeschema für Rime

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

Zuerst das Rime-Frontend für die jeweilige Plattform installieren und anschließend die folgenden Schritte ausführen.

### iOS / Hamster3

1. Hamster3 installieren und aktivieren, in den iOS-Einstellungen die Hamster-Tastatur hinzufügen und bei Aufforderung **Vollen Zugriff erlauben** aktivieren.
2. Die Dateien über die Schema-Verwaltung oder Importfunktion von Hamster3 importieren. Die Struktur mit `yoce_de.schema.yaml`, `yoce_de.txt` und `lua/yoce_de.lua` beibehalten.
3. Das Schema `yoce_de` auswählen, aktualisieren oder bereitstellen und anschließend `du`, `dubist` oder `U-Bahn` testen.

### Android / Trime

1. Trime installieren und aktivieren und den Zugriff auf das Rime-Benutzerverzeichnis erlauben. Standardmäßig ist dies meist `/rime` im gemeinsamen Telefonspeicher.
2. Die Projektdateien in Trimes aktives Rime-Benutzerverzeichnis kopieren; die Lua-Datei gehört in das Unterverzeichnis `lua/`.
3. In Trimes Schema-Verwaltung `yoce_de` hinzufügen oder auswählen, bereitstellen und anschließend das Schema zum Testen aktivieren.

### Windows / Weasel

1. Weasel installieren und aktivieren. Über das Tray-Menü den **Benutzerordner** öffnen; standardmäßig ist dies meist `%APPDATA%\Rime`.
2. `yoce_de.schema.yaml` und `yoce_de.txt` in dieses Verzeichnis kopieren und `lua/yoce_de.lua` in das Unterverzeichnis `lua/` kopieren.
3. Im Tray-Menü **Deploy** beziehungsweise **Neu bereitstellen** ausführen und anschließend `yoce_de` auswählen.

### macOS / Squirrel

1. Squirrel installieren und aktivieren. Über das Eingabemenü **Benutzereinstellungen** öffnen; standardmäßig ist dies meist `~/Library/Rime`.
2. `yoce_de.schema.yaml` und `yoce_de.txt` in dieses Verzeichnis kopieren und `lua/yoce_de.lua` in das Unterverzeichnis `lua/` kopieren.
3. Im Menü **Deploy** beziehungsweise **Neu bereitstellen** ausführen und anschließend `yoce_de` auswählen.

### Linux / Fcitx5

1. `fcitx5-rime` und ein Lua-fähiges `librime` installieren und anschließend **Rime** in den Fcitx5-Eingabemethoden aktivieren.
2. Die Projektdateien nach `~/.local/share/fcitx5/rime` kopieren; die Lua-Datei gehört in das Unterverzeichnis `lua/`.
3. Im Fcitx5-Tray-Menü **Neu bereitstellen** ausführen und anschließend `yoce_de` auswählen. Bei einem eigenen Rime-Verzeichnis das tatsächlich konfigurierte Verzeichnis verwenden.

Unabhängig vom Frontend muss diese Struktur im Rime-Benutzerverzeichnis erhalten bleiben:
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

### Beispiel für Linux-Kommandozeile
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
