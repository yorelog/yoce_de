# German input schema for Rime

English | [简体中文](README_CN.md) | [Deutsch](README_DE.md)

`yoce_de` is a beginner-friendly German input schema for Rime. It combines a schema, a Lua translator, and a German-English dictionary to make German typing more natural.

## Features
- German characters: `ä`, `ö`, `ü`, `ß`, and uppercase variants
- Alternative spellings: `ae`, `oe`, `ue`, and `ss`
- Joined input and phrase splitting, such as `dubist` -> `du bist`
- Prefix completion, such as `kom` -> `kommen`, `kommt`, and `komisch`
- Hyphenated words, such as `U-Bahn`
- English meanings in candidate comments

## Project files
| File | Purpose |
| --- | --- |
| `yoce_de.schema.yaml` | Rime schema registration and settings |
| `lua/yoce_de.lua` | Custom translator and word segmentation |
| `yoce_de.txt` | German-English dictionary (`German<Tab>English`) |

## Installation

### Option A: Copy the files manually
Install a Rime frontend first, then copy the project files into its Rime user directory:

| Platform / frontend | Rime user directory or action |
| --- | --- |
| Windows / Weasel | Right-click the Weasel tray icon and open **User Folder** |
| macOS / Squirrel | Right-click the input menu icon and open **User Settings**; the folder is usually `~/Library/Rime` |
| Linux / Fcitx5 | Usually `~/.local/share/fcitx5/rime`; install `fcitx5-rime` and Lua support first |
| Linux / iBus | Usually `~/.config/ibus/rime`; install `ibus-rime` and Lua support first |
| Android / Trime | Use Trime's user data directory and its import/deploy function |

Keep this layout inside the user directory:
```text
<rime-user-dir>/
├── yoce_de.schema.yaml
├── yoce_de.txt
└── lua/
  └── yoce_de.lua
```

Then:
1. Deploy Rime from the frontend's tray/menu action.
2. Select `yoce_de` (`Yoce Deutsch`) in the schema switcher.
3. Type `du`, `dubist`, `kom`, or `U-Bahn` to test it.

The exact user directory and menu names vary by frontend. Do not put `yoce_de.lua` beside the schema; it belongs in the `lua/` subdirectory.

### Option B: Install from the command line
For a repository checkout, copy the same three files into the target Rime user directory. On Linux, the target can be selected explicitly:
```bash
rime_dir="$HOME/.local/share/fcitx5/rime"
mkdir -p "$rime_dir/lua"
cp yoce_de.schema.yaml yoce_de.txt "$rime_dir/"
cp lua/yoce_de.lua "$rime_dir/lua/"
```
After copying, trigger **Deploy** in the frontend. The `rime_dir` value must match your frontend.

### Linux dependencies
The Lua translator requires a recent `librime` with Lua support. Package names vary:
- Debian/Ubuntu/Arch-based systems: use the distribution package for `fcitx5-rime` or `ibus-rime`, plus `librime-lua` or `librime-plugin-lua` when provided separately.
- Fedora and other systems with missing or outdated Lua plugins: use a maintained Flatpak or the [ibus-rime AppImage](https://github.com/hchunhui/ibus-rime.AppImage), or build `librime` with its merged plugins.
- Fcitx5 users should install `fcitx5-rime`, not the legacy `fcitx-rime`.

## Try it
Example dictionary entries:
```text
du	you
bist	are
U-Bahn	subway
Spaß	fun
Überstunden	overtime
```

After deployment, try typing `du`, `dubist`, `kom`, or `U-Bahn` and choose a candidate.

## Customizing the dictionary
Add one entry per line to `yoce_de.txt`:
```text
German<Tab>English meaning
```
Deploy Rime again after changing the dictionary.

## License
This project is intended as a local customization for Rime and may be adapted for personal use. If you redistribute it, keep the original attribution and respect the license terms of the Rime ecosystem and the dictionary sources.
