# Rime 德语输入方案

[English](README.md) | 简体中文 | [Deutsch](README_DE.md)

`yoce_de` 是一个适合新手使用的 Rime 德语输入方案。它由 Schema、Lua 翻译器和德英词库组成，让德语输入更接近真实的使用习惯。

## 支持的功能
- 德语字符：`ä`、`ö`、`ü`、`ß` 及大写形式
- 替代拼写：`ae`、`oe`、`ue`、`ss`
- 连续输入和短语分词，例如 `dubist` -> `du bist`
- 前缀联想，例如 `kom` -> `kommen`、`kommt`、`komisch`
- 带连字符的单词，例如 `U-Bahn`
- 候选项中显示英文释义

## 项目文件
| 文件 | 作用 |
| --- | --- |
| `yoce_de.schema.yaml` | 注册 Rime 方案并保存配置 |
| `lua/yoce_de.lua` | 自定义翻译和词组分词逻辑 |
| `yoce_de.txt` | 德英词库，格式为 `德语<Tab>英语` |

## 安装

请先安装对应平台的 Rime 前端，再按下面的步骤安装本方案。

### iOS / Hamster3 元书输入法

1. 安装并启用 Hamster3，在系统设置中添加 Hamster 键盘；按系统提示开启“允许完全访问”。
2. 在 Hamster3 的方案管理或文件导入功能中导入本项目文件，保持 `yoce_de.schema.yaml`、`yoce_de.txt` 和 `lua/yoce_de.lua` 的目录结构。
3. 选择 `yoce_de` 方案，刷新或重新部署，然后在键盘中测试输入 `du`、`dubist` 或 `U-Bahn`。

### Android / Trime 同文输入法

1. 安装并启用 Trime，授权其使用 Rime 用户目录；默认目录通常为手机存储根目录下的 `/rime`。
2. 将本项目文件复制到 Trime 当前使用的 Rime 用户目录，Lua 文件放入 `lua/` 子目录。
3. 在 Trime 的方案管理中添加或选择 `yoce_de`，执行“部署”，再切换到该方案测试输入。

### Windows / Weasel 小狼毫

1. 安装并启用 Weasel，右键托盘区图标，打开“用户文件夹”；默认通常为 `%APPDATA%\Rime`。
2. 将 `yoce_de.schema.yaml` 和 `yoce_de.txt` 复制到该目录，并将 `lua/yoce_de.lua` 复制到 `lua/` 子目录。
3. 从托盘菜单执行“重新部署”，再在方案选单中选择 `yoce_de`。

### macOS / Squirrel 鼠须管

1. 安装并启用 Squirrel，点击菜单栏输入法图标，打开“用户设定”；用户目录通常为 `~/Library/Rime`。
2. 将 `yoce_de.schema.yaml` 和 `yoce_de.txt` 复制到该目录，并将 `lua/yoce_de.lua` 复制到 `lua/` 子目录。
3. 从菜单执行“重新部署”，再在方案选单中选择 `yoce_de`。

### Linux / Fcitx5

1. 安装 `fcitx5-rime` 和带 Lua 支持的 `librime`，在 Fcitx5 输入法设置中添加“中州韵”。
2. 将本项目文件复制到 `~/.local/share/fcitx5/rime`，Lua 文件放入 `lua/` 子目录。
3. 从 Fcitx5 托盘菜单执行“重新部署”，再选择 `yoce_de`。如果使用自定义 Rime 目录，请以实际目录为准。

无论使用哪种前端，用户目录中都应保持以下结构：
```text
<rime-user-dir>/
├── yoce_de.schema.yaml
├── yoce_de.txt
└── lua/
  └── yoce_de.lua
```

然后：
1. 从前端托盘菜单或设置中执行“重新部署”。
2. 在方案切换器中选择 `yoce_de`（`Yoce Deutsch`）。
3. 尝试输入 `du`、`dubist`、`kom` 或 `U-Bahn`。

不同前端的用户目录和菜单名称可能不同。`yoce_de.lua` 必须放在 `lua/` 子目录中，不能和 Schema 放在同一层。

### Linux 命令行复制示例
如果当前目录是项目源码，可以用命令行复制。下面以 Fcitx5 为例：
```bash
rime_dir="$HOME/.local/share/fcitx5/rime"
mkdir -p "$rime_dir/lua"
cp yoce_de.schema.yaml yoce_de.txt "$rime_dir/"
cp lua/yoce_de.lua "$rime_dir/lua/"
```
复制完成后，在前端执行“重新部署”。使用 iBus 时，将 `rime_dir` 改为 `~/.config/ibus/rime`。

### Linux 依赖
Lua 翻译器需要带 Lua 支持的较新版本 `librime`。不同发行版的软件包名称可能不同：
- Debian/Ubuntu/Arch 系：安装发行版提供的 `fcitx5-rime` 或 `ibus-rime`，如果 Lua 插件单独提供，再安装 `librime-lua` 或 `librime-plugin-lua`。
- Fedora 等缺少或版本过旧的系统：可以使用维护中的 Flatpak、[ibus-rime AppImage](https://github.com/hchunhui/ibus-rime.AppImage)，或自行编译带合并插件的 `librime`。
- Fcitx5 请安装 `fcitx5-rime`，不要安装已经过时的 `fcitx-rime`。

## 试着输入
词库条目示例：
```text
du	you
bist	are
U-Bahn	subway
Spaß	fun
Überstunden	overtime
```

部署后，可以尝试输入 `du`、`dubist`、`kom` 或 `U-Bahn`，然后选择候选项。

## 修改词库
在 `yoce_de.txt` 中每行添加一条词条：
```text
德语<Tab>English meaning
```
修改词库后重新部署 Rime。

## 许可
本项目是面向 Rime 的本地定制方案，可自由修改用于个人用途。如果重新发布，请保留原始署名，并遵守 Rime 生态及词库来源的许可条款。
