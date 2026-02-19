![Clawmarchy](wallpaper-preview.png)

![Clawmarchy Desktop](preview.png)

# Clawmarchy

AMOLED dark theme with 6 accent color variants and curated anime wallpapers for [Omarchy](https://omarchy.com).

## Contents

- [Install](#install)
- [Features](#features)
- [Themed Components](#themed-components)
- [Accent Variants](#accent-variants)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Compatibility](#compatibility)
- [Palette](#palette)
- [Credits](#credits)
- [Switching Themes](#switching-themes)

## Install

```
omarchy-theme-install https://github.com/AsemHub/omarchy-clawmarchy-theme
```

## Features

- **AMOLED true black** -- pure `#000000` background, no gray wash
- **6 accent variants** -- purple (default), sakura, ocean, tide, ember, and moss
- **5 anime wallpapers** -- dark atmospheric scenes paired to each accent variant
- **Custom btop gradients** -- cyan-to-magenta load mapping
- **tokyonight-night Neovim** -- AMOLED black overrides for seamless integration
- **Hyprland effects** -- purple borders, subtle shadows, smooth animations
- **Yaru-purple-dark icons** -- consistent GTK icon set

## Themed Components

```
clawmarchy/
├── colors.toml              # Color palette (source of truth)
├── hyprland.conf            # Window manager config
├── waybar.css               # Status bar styling
├── walker.css               # App launcher styling
├── mako.ini                 # Notification styling
├── swayosd.css              # Volume/brightness popups
├── hyprlock.conf            # Lock screen config
├── btop.theme               # System monitor gradients
├── neovim.lua               # Neovim color overrides
├── vscode.json              # VS Code workspace colors
├── chromium.theme           # Browser toolbar color
├── icons.theme              # GTK icon theme name
├── clawmarchy-variant       # Variant switching script
├── backgrounds/
│   ├── 1-sakura-cherry-blossoms.png
│   ├── 2-ocean-midnight-harbor.png
│   ├── 3-tide-underwater-shrine.png
│   ├── 4-ember-lantern-festival.png
│   ├── 5-moss-forest-shrine.png
│   └── qhd/                # QHD downscaled versions
└── variants/
    ├── ember/               # 9 config files per variant
    ├── moss/
    ├── ocean/
    ├── sakura/
    ├── tide/
    └── yoru/
```

All config files except `colors.toml` are static overrides. See [COLORS.md](COLORS.md) for detailed color mapping.

| File | Component | What It Controls |
|------|-----------|------------------|
| `colors.toml` | Color palette | All theme colors; read by Omarchy's template engine |
| `hyprland.conf` | Hyprland | Window borders, opacity override, blur, shadows, animations |
| `waybar.css` | Waybar | Status bar colors, accent highlights, battery/network status indicators |
| `walker.css` | Walker | App launcher AMOLED background and accent search border |
| `mako.ini` | Mako | Notification colors with urgency-based border differentiation |
| `swayosd.css` | SwayOSD | Volume/brightness popup colors |
| `hyprlock.conf` | Hyprlock | Lock screen colors, accent clock, wallpaper dimming overlay |
| `btop.theme` | btop | System monitor color gradients (cyan-to-magenta load mapping) |
| `neovim.lua` | Neovim | tokyonight-night AMOLED black background overrides |
| `vscode.json` | VS Code | 30 workspace color customizations for AMOLED black surfaces |
| `chromium.theme` | Chromium | Browser toolbar background color |
| `icons.theme` | GTK icons | Yaru-purple-dark icon set |

## Accent Variants

Clawmarchy ships with 6 accent color variants. Switch with a single command:

```
clawmarchy-variant <name>
```

| Variant | Color | Description |
|---------|-------|-------------|
| yoru | `#7B6CBD` | Muted blue-violet (default) |
| sakura | `#D4839B` | Cherry blossom pink |
| ocean | `#5B8EC9` | Deep sea blue |
| tide | `#5AB5B5` | Coastal teal |
| ember | `#D4895A` | Lantern warm orange |
| moss | `#6EA88E` | Forest green |

Run `clawmarchy-variant --list` to see all options.

## Palette

![#000000](https://img.shields.io/badge/-%23000000-000000?style=flat-square)
![#7B6CBD](https://img.shields.io/badge/-%237B6CBD-7B6CBD?style=flat-square)
![#E8E0D0](https://img.shields.io/badge/-%23E8E0D0-E8E0D0?style=flat-square)
![#C45B6E](https://img.shields.io/badge/-%23C45B6E-C45B6E?style=flat-square)
![#6EA88E](https://img.shields.io/badge/-%236EA88E-6EA88E?style=flat-square)
![#5AA8B5](https://img.shields.io/badge/-%235AA8B5-5AA8B5?style=flat-square)
![#9B7BC8](https://img.shields.io/badge/-%239B7BC8-9B7BC8?style=flat-square)

## Credits

- Wallpapers: AI-generated via Google Gemini
- Framework: [Omarchy](https://omarchy.com) by DHH
- Neovim colorscheme: [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) (tokyonight-night)
- Icons: Yaru-purple-dark

## Switching Themes

To switch to a different theme:

```
omarchy-theme-set <other-theme>
```
