# Clawmarchy Theme - Color Traceability Reference

This document is the single-page reference for color management in the Clawmarchy theme.
It answers two questions: "What do I need to update when changing the accent color?" and
"Where does each hardcoded color value come from?"

For inline annotations, see the `colors.toml: keyname` comments in each config file.

## Quick Reference: What to Update When Changing Accent Color

When changing the accent color from `#7B6CBD` to a new value, update these files:

| File | Affected? | Values to Update | Search For |
|------|-----------|-----------------|------------|
| colors.toml | YES | `accent`, `selection_background` | `#7B6CBD` |
| waybar.css | YES | 2 accent values | `#7B6CBD` |
| walker.css | YES | 2 @define-color accent values | `#7B6CBD` |
| swayosd.css | YES | 1 @define-color accent value | `#7B6CBD` |
| mako.ini | YES | 1 border-color | `#7B6CBD` |
| hyprland.conf | YES | 1 rgb() border color | `7B6CBD` (no # prefix) |
| hyprlock.conf | YES | 3 rgba() values (outer_color, check_color, clock label) | `123,108,189` (decimal) |
| btop.theme | YES | 7 accent-role values | `#7B6CBD` |
| vscode.json | YES | 5 values (3 pure accent + 2 alpha-derived) | `#7B6CBD` |
| neovim.lua | NO | Background overrides only | -- |
| chromium.theme | NO | Background RGB only | -- |

**Tip:** Use `grep -rn '7B6CBD' .` to find all accent color occurrences across the repo.
This covers hex (`#7B6CBD`), rgb() (`rgb(7B6CBD)`), and the decimal conversion (`123,108,189`)
can be found with `grep -rn '123,108,189' .`.

## File Classification

| File | Classification | Description |
|------|---------------|-------------|
| colors.toml | Source of truth | Defines the 24-key color palette; read by Omarchy's template engine |
| btop.theme | Static override | System monitor theme with gradient mappings |
| hyprland.conf | Static override | Window manager borders, shadows, effects |
| hyprlock.conf | Static override | Lock screen color variables and overlay |
| mako.ini | Static override | Notification popup colors and urgency levels |
| waybar.css | Static override | Status bar GTK CSS overrides |
| walker.css | Static override | App launcher GTK CSS overrides |
| swayosd.css | Static override | Volume/brightness popup GTK CSS overrides |
| vscode.json | Static override | Editor workspace color customizations |
| neovim.lua | Static override | Terminal editor AMOLED background overrides |
| chromium.theme | Static override | Browser toolbar RGB triplet |

All files in this repo except colors.toml are static overrides. They contain hardcoded color
values that must be manually updated when the palette changes. Omarchy's template engine
generates configs for components where the theme does NOT ship a static override -- those
generated files live at runtime in `~/.config/omarchy/current/theme/` and are not in this repo.

## colors.toml Palette Reference

The palette defines 24 keys organized by category:

### Base Colors

| Key | Value | Role |
|-----|-------|------|
| background | `#000000` | AMOLED true black base |
| foreground | `#E8E0D0` | Primary text color |
| cursor | `#E8E0D0` | Terminal cursor color |
| accent | `#7B6CBD` | Theme accent (muted blue-violet) |

### Selection

| Key | Value | Role |
|-----|-------|------|
| selection_foreground | `#E8E0D0` | Selected text color |
| selection_background | `#7B6CBD` | Selection highlight color |

### ANSI Normal (0-7)

| Key | Value | Role |
|-----|-------|------|
| color0 | `#111118` | Black (dark surface) |
| color1 | `#C45B6E` | Red |
| color2 | `#6EA88E` | Green |
| color3 | `#C49B5A` | Yellow |
| color4 | `#6E8EC4` | Blue |
| color5 | `#9B7BC8` | Magenta |
| color6 | `#5AA8B5` | Cyan |
| color7 | `#8A8598` | White (muted) |

### ANSI Bright (8-15)

| Key | Value | Role |
|-----|-------|------|
| color8 | `#2A2835` | Bright black (dark border) |
| color9 | `#D47585` | Bright red |
| color10 | `#85C4A5` | Bright green |
| color11 | `#D4B572` | Bright yellow |
| color12 | `#85A5D4` | Bright blue |
| color13 | `#B595DA` | Bright magenta |
| color14 | `#72C4CE` | Bright cyan |
| color15 | `#E8E0D0` | Bright white |

## Per-File Color Audit

### btop.theme (33 values)

| Config Key | Value | colors.toml Key | Notes |
|-----------|-------|----------------|-------|
| theme[main_bg] | `#000000` | background | |
| theme[main_fg] | `#E8E0D0` | foreground | |
| theme[title] | `#E8E0D0` | foreground | |
| theme[hi_fg] | `#7B6CBD` | accent | |
| theme[selected_bg] | `#2A2835` | color8 | |
| theme[selected_fg] | `#7B6CBD` | accent | |
| theme[inactive_fg] | `#2A2835` | color8 | |
| theme[graph_text] | `#E8E0D0` | foreground | |
| theme[meter_bg] | `#111118` | color0 | |
| theme[proc_misc] | `#7B6CBD` | accent | |
| theme[cpu_box] | `#7B6CBD` | accent | Box outline |
| theme[mem_box] | `#7B6CBD` | accent | Box outline |
| theme[net_box] | `#7B6CBD` | accent | Box outline |
| theme[proc_box] | `#7B6CBD` | accent | Box outline |
| theme[div_line] | `#2A2835` | color8 | |
| theme[temp_start] | `#5AA8B5` | color6 | Gradient: cool |
| theme[temp_mid] | `#7B6CBD` | accent | Gradient: warm |
| theme[temp_end] | `#C45B6E` | color1 | Gradient: hot |
| theme[cpu_start] | `#5AA8B5` | color6 | Gradient: cyan |
| theme[cpu_mid] | `#6E8EC4` | color4 | Gradient: blue |
| theme[cpu_end] | `#9B7BC8` | color5 | Gradient: magenta |
| theme[free_start] | `#B595DA` | color13 | |
| theme[free_mid] | `#85A5D4` | color12 | |
| theme[free_end] | `#72C4CE` | color14 | |
| theme[cached_start] | `#6E8EC4` | color4 | |
| theme[cached_mid] | `#5AA8B5` | color6 | |
| theme[cached_end] | `#72C4CE` | color14 | |
| theme[available_start] | `#72C4CE` | color14 | |
| theme[available_mid] | `#85A5D4` | color12 | |
| theme[available_end] | `#B595DA` | color13 | |
| theme[used_start] | `#5AA8B5` | color6 | |
| theme[used_mid] | `#6E8EC4` | color4 | |
| theme[used_end] | `#9B7BC8` | color5 | |

Gradient pattern: download (color6 -> color4 -> color12), upload (color4 -> color5 -> color13),
process (color6 -> color4 -> color5). These follow the cool-to-warm design (cyan -> blue -> magenta).

### hyprland.conf (2 values)

| Config Key | Value | colors.toml Key | Notes |
|-----------|-------|----------------|-------|
| $activeBorderColor | `rgb(7B6CBD)` | accent | Hyprland rgb() format (no # prefix) |
| shadow color | `rgba(00000088)` | background | 53% alpha; see Unmapped Values |

### hyprlock.conf (7 values)

| Config Key | Value | colors.toml Key | Notes |
|-----------|-------|----------------|-------|
| $color | `rgba(0,0,0, 1.0)` | background | Full opacity |
| $inner_color | `rgba(0,0,0, 0.8)` | background | 80% opacity |
| $outer_color | `rgba(123,108,189, 1.0)` | accent | Decimal RGB format |
| $font_color | `rgba(232,224,208, 1.0)` | foreground | Decimal RGB format |
| $check_color | `rgba(123,108,189, 1.0)` | accent | Decimal RGB format |
| background color | `rgba(0, 0, 0, 0.45)` | background | 45% overlay; see Unmapped Values |
| label color | `rgba(123,108,189, 1.0)` | accent | Clock display color |

### mako.ini (5 values)

| Config Key | Value | colors.toml Key | Notes |
|-----------|-------|----------------|-------|
| text-color | `#E8E0D0` | foreground | |
| border-color (global) | `#7B6CBD` | accent | Normal urgency |
| background-color | `#000000FF` | background | With FF alpha suffix; see Unmapped Values |
| border-color [urgency=low] | `#C49B5A` | color3 | Yellow for low urgency |
| border-color [urgency=critical] | `#C45B6E` | color1 | Red for critical urgency |

### waybar.css (9 values)

| CSS Property | Value | colors.toml Key | Notes |
|-------------|-------|----------------|-------|
| @define-color foreground | `#E8E0D0` | foreground | |
| @define-color background | `#000000` | background | |
| @define-color theme-red | `#C45B6E` | color1 | Semantic: battery critical |
| @define-color theme-yellow | `#C49B5A` | color3 | Semantic: battery warning |
| @define-color theme-green | `#6EA88E` | color2 | Semantic: status OK |
| #workspaces button.active color | `#7B6CBD` | accent | |
| Module icons color | `#7B6CBD` | accent | battery, network, pulseaudio, bluetooth, cpu |
| tooltip background-color | `#000000` | background | |
| tooltip color | `#E8E0D0` | foreground | |

### walker.css (6 values)

| CSS Property | Value | colors.toml Key | Notes |
|-------------|-------|----------------|-------|
| @define-color selected-text | `#7B6CBD` | accent | |
| @define-color text | `#E8E0D0` | foreground | |
| @define-color base | `#000000` | background | |
| @define-color border | `#7B6CBD` | accent | Search border |
| @define-color foreground | `#E8E0D0` | foreground | |
| @define-color background | `#000000` | background | |

### swayosd.css (5 values)

| CSS Property | Value | colors.toml Key | Notes |
|-------------|-------|----------------|-------|
| @define-color background-color | `#000000` | background | |
| @define-color border-color | `#E8E0D0` | foreground | |
| @define-color label | `#E8E0D0` | foreground | |
| @define-color image | `#E8E0D0` | foreground | |
| @define-color progress | `#7B6CBD` | accent | |

### vscode.json (30 values)

Color source annotations are stored as `_comment_*` keys within the `[Tokyo Night]` scope,
grouped by semantic role: backgrounds, foregrounds, accent, surfaces.

| colorCustomizations Key | Value | colors.toml Key | Notes |
|------------------------|-------|----------------|-------|
| editor.background | `#000000` | background | |
| editor.foreground | `#E8E0D0` | foreground | |
| sideBar.background | `#000000` | background | |
| sideBar.foreground | `#E8E0D0` | foreground | |
| sideBarTitle.foreground | `#E8E0D0` | foreground | |
| activityBar.background | `#000000` | background | |
| activityBar.foreground | `#E8E0D0` | foreground | |
| panel.background | `#000000` | background | |
| panel.border | `#111118` | color0 | Dark surface border |
| terminal.background | `#000000` | background | |
| terminal.foreground | `#E8E0D0` | foreground | |
| titleBar.activeBackground | `#000000` | background | |
| titleBar.activeForeground | `#E8E0D0` | foreground | |
| statusBar.background | `#000000` | background | |
| statusBar.foreground | `#E8E0D0` | foreground | |
| tab.activeBackground | `#000000` | background | |
| tab.inactiveBackground | `#000000` | background | |
| tab.inactiveForeground | `#8A8598` | color7 | Muted text |
| editorGroupHeader.tabsBackground | `#000000` | background | |
| dropdown.background | `#000000` | background | |
| breadcrumb.background | `#000000` | background | |
| editorWidget.background | `#000000` | background | |
| input.background | `#111118` | color0 | Dark surface |
| input.foreground | `#E8E0D0` | foreground | |
| input.border | `#2A2835` | color8 | Dark border |
| tab.activeBorderTop | `#7B6CBD` | accent | |
| focusBorder | `#7B6CBD` | accent | |
| selection.background | `#7B6CBD40` | accent + 25% alpha | See Unmapped Values |
| list.activeSelectionBackground | `#7B6CBD30` | accent + 19% alpha | See Unmapped Values |
| list.activeSelectionForeground | `#E8E0D0` | foreground | |

### neovim.lua (4 values)

| Lua Key | Value | colors.toml Key | Notes |
|---------|-------|----------------|-------|
| colors.bg | `#000000` | background | |
| colors.bg_dark | `#000000` | background | |
| colors.bg_float | `#0a0a12` | UNMAPPED | See Unmapped Values |
| colors.bg_sidebar | `#0a0a12` | UNMAPPED | See Unmapped Values |

### chromium.theme (1 value)

| Value | colors.toml Key | Notes |
|-------|----------------|-------|
| `0,0,0` | background | RGB decimal triplet (R,G,B format) |

This file cannot contain comments. The Omarchy script `omarchy-theme-set-browser` reads
it with `$(<file)` which captures the entire file content as a string. Any comments or
extra lines would break the RGB parsing. Color source documentation is provided here only.

## Unmapped Values

These color values do NOT map directly to a colors.toml key:

| Value | File | Context | Rationale |
|-------|------|---------|-----------|
| `#0a0a12` | neovim.lua | bg_float, bg_sidebar | Intentional tokyonight-specific dark surface; distinct from color0 (`#111118`) |
| `#7B6CBD40` | vscode.json | selection.background | Derived: accent + 25% alpha (hex `40` = 64/255 = 25%) |
| `#7B6CBD30` | vscode.json | list.activeSelectionBackground | Derived: accent + 19% alpha (hex `30` = 48/255 = 19%) |
| `#000000FF` | mako.ini | background-color | Format variant: background + FF alpha (mako requires `#RRGGBBAA`) |
| `rgba(0,0,0,0.45)` | hyprlock.conf | wallpaper dimming overlay | Derived: background + 45% opacity (design choice for dimming) |
| `rgba(00000088)` | hyprland.conf | shadow color | Derived: background + 53% alpha (hex `88` = 136/255 = 53%) |

No new colors.toml keys are recommended. All unmapped values are either intentional design
choices, derived values (base color + alpha modifier), or format variants of existing palette
colors.
