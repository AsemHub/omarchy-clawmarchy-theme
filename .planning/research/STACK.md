# Stack Research

**Domain:** Hyprland desktop theme expansion (Waybar, Walker, Mako, CLI tool, accent variants)
**Researched:** 2026-02-18
**Confidence:** HIGH

## How Omarchy Theme Generation Works

This is the foundational knowledge for every decision below. Omarchy has a two-stage theme system:

1. **Static files** -- the theme ships files like `waybar.css`, `mako.ini`, `walker.css`, `btop.theme` in its directory
2. **Template generation** -- `omarchy-theme-set-templates` reads `colors.toml` and runs `sed` substitution on `.tpl` template files to generate configs

**Critical rule**: Static files take priority. The template generator checks `if [[ ! -f $output_path ]]` before writing. If a theme ships its own `waybar.css`, the template `waybar.css.tpl` is skipped entirely. This is how Clawmarchy already overrides `btop.theme` and `hyprland.conf`.

**Template variables available from colors.toml:**
- `{{ key }}` -- raw value (e.g., `#7B6CBD`)
- `{{ key_strip }}` -- value without `#` prefix (e.g., `7B6CBD`)
- `{{ key_rgb }}` -- decimal RGB (e.g., `123,108,189`)

All 24 keys from colors.toml are available: `accent`, `cursor`, `foreground`, `background`, `selection_foreground`, `selection_background`, `color0` through `color15`.

## Recommended Stack

### Component Config Formats

| Component | Config File | Format | CSS Engine | Theme Variables |
|-----------|-------------|--------|------------|-----------------|
| Waybar | `waybar.css` | GTK3 CSS | `@define-color name value;` | `@foreground`, `@background` |
| Walker | `walker.css` | GTK4 CSS | `@define-color name value;` | `@selected-text`, `@text`, `@base`, `@border`, `@foreground`, `@background` |
| Mako | `mako.ini` | INI (key=value) | N/A | `text-color`, `border-color`, `background-color` |
| SwayOSD | `swayosd.css` | GTK3 CSS | `@define-color name value;` | `@background-color`, `@border-color`, `@label`, `@image`, `@progress` |

### CLI Tool

| Technology | Purpose | Why Recommended |
|------------|---------|-----------------|
| Bash script | CLI accent swap tool | Omarchy itself is 100% Bash scripts. Same `sed`-based substitution pattern as `omarchy-theme-set-templates`. Zero dependencies beyond what Omarchy already requires. |
| `sed` | TOML value replacement | Already proven in `omarchy-theme-set-templates`. The colors.toml format is simple enough (key = "value" lines) that full TOML parsing is unnecessary. |

### Color Generation

| Technology | Purpose | Why Recommended |
|------------|---------|-----------------|
| Bash + sed | Generate configs from colors.toml | The existing Omarchy template system already does this. Our tool just needs to modify `colors.toml` and re-trigger generation. |
| `omarchy-theme-set-templates` | Template expansion | Reuse Omarchy's own script rather than reimplementing. After modifying colors.toml, call this to regenerate all configs. |

## Detailed Technical Reference

### Waybar CSS Theming

**How it works in Omarchy:**

The user's `~/.config/waybar/style.css` imports the theme:
```css
@import "../omarchy/current/theme/waybar.css";
```

The default template (`waybar.css.tpl`) generates only two color definitions:
```css
@define-color foreground {{ foreground }};
@define-color background {{ background }};
```

These are consumed by the base `style.css` via `@foreground` and `@background`. All structural CSS (padding, layout, selectors) lives in the base `style.css`, not the theme file.

**What a custom theme can do:**

A theme can ship its own `waybar.css` with additional `@define-color` declarations and even structural CSS overrides. DHH explicitly decided to keep per-component CSS files separate (GitHub issue #327, July 2025) to give themes "the power to radically change the look of waybar/walker/sway."

**Available Waybar CSS selectors** (from Omarchy's base style.css):
```
window#waybar          -- main bar container
.modules-left          -- left module group
.modules-center        -- center module group
.modules-right         -- right module group
#workspaces button     -- workspace buttons
#workspaces button.empty -- empty workspace
#cpu, #battery, #pulseaudio, #custom-omarchy -- individual modules
#clock                 -- clock module
#network, #bluetooth   -- connectivity modules
#tray                  -- system tray
tooltip                -- tooltip popups
```

**GTK3 CSS constraints:**
- Only subset of CSS (no flexbox, no CSS custom properties `var()`)
- Use `@define-color` for color variables, reference with `@name`
- Supports `shade()`, `mix()`, `alpha()` color functions
- Supports `:hover`, `:focus-visible`, `:not()` pseudo-classes
- Debug with `env GTK_DEBUG=interactive waybar`

**Recommended waybar.css for Clawmarchy:**
```css
@define-color foreground #E8E0D0;
@define-color background #000000;
@define-color accent #7B6CBD;
```

Adding `@accent` goes beyond the default template but the base style.css does not reference it. To use accent colors in Waybar, we either:
- (a) Ship a custom `waybar.css` with the extra color definitions (static override), or
- (b) The accent color is only useful if we also override structural CSS to reference it

For AMOLED consistency, the minimal static `waybar.css` ensures true black background. The accent color can be used for active workspace buttons or hover states if desired.

### Walker CSS Theming

**How it works in Omarchy:**

Walker uses GTK4 CSS (not GTK3 like Waybar). The config at `~/.config/walker/config.toml` sets `theme = "omarchy-default"` pointing to `~/.local/share/omarchy/default/walker/themes/omarchy-default/`.

The default Walker theme's `style.css` imports from the theme:
```css
@import "../../../../../../../.config/omarchy/current/theme/walker.css";
```

The template (`walker.css.tpl`) generates six color definitions:
```css
@define-color selected-text {{ accent }};
@define-color text {{ foreground }};
@define-color base {{ background }};
@define-color border {{ foreground }};
@define-color foreground {{ foreground }};
@define-color background {{ background }};
```

**Available Walker CSS selectors** (from default theme style.css):
```
.box-wrapper           -- outer container (background, padding, border)
.search-container      -- search input area
.input                 -- search text input
.content-container     -- results area
.list                  -- results list
.item-box              -- individual result item
.item-text-box         -- text within item
.item-text             -- main text
.item-subtext          -- subtitle
.item-image            -- app icon
child:selected .item-box * -- selected item styling
.keybind-hints         -- keyboard shortcut hints
.preview               -- preview pane
```

**Key difference from Waybar:** Walker uses GTK4, which has slightly different CSS support. The layout is defined by XML (`layout.xml`), not CSS. A theme can override both `style.css` and `layout.xml`.

**Recommended walker.css for Clawmarchy:**
```css
@define-color selected-text #7B6CBD;
@define-color text #E8E0D0;
@define-color base #000000;
@define-color border #7B6CBD;
@define-color foreground #E8E0D0;
@define-color background #000000;
```

Note: Setting `@border` to accent color instead of foreground makes the launcher border match the AMOLED purple theme. This is a deliberate design choice.

### Mako Notification Theming

**How it works in Omarchy:**

Mako's config at `~/.config/mako/config` is a symlink to `~/.config/omarchy/current/theme/mako.ini`.

The template (`mako.ini.tpl`) generates:
```ini
include=~/.local/share/omarchy/default/mako/core.ini

text-color={{ foreground }}
border-color={{ accent }}
background-color={{ background }}
```

The `core.ini` defines structural settings:
```ini
anchor=top-right
default-timeout=5000
width=420
outer-margin=20
padding=10,15
border-size=2
max-icon-size=32
font=sans-serif 14px
```

Plus criteria-based overrides for Spotify, DND mode, urgency levels, and notification actions.

**Available Mako style options:**
```
text-color=<hex>           -- notification text
background-color=<hex>     -- notification background
border-color=<hex>         -- notification border
border-size=<int>          -- border width in pixels
border-radius=<int>        -- corner rounding
width=<int>                -- notification width
padding=<int>,<int>        -- vertical,horizontal padding
font=<family> <size>       -- notification font
max-icon-size=<int>        -- icon size limit
progress-color=<hex>       -- progress bar color
```

Criteria sections allow per-urgency theming:
```ini
[urgency=low]
border-color=#2A2835

[urgency=critical]
border-color=#C45B6E
background-color=#111118
```

**Recommended mako.ini for Clawmarchy:**
```ini
include=~/.local/share/omarchy/default/mako/core.ini

text-color=#E8E0D0
border-color=#7B6CBD
background-color=#000000

[urgency=low]
border-color=#2A2835

[urgency=critical]
border-color=#C45B6E
```

Adding urgency-based border colors gives visual distinction using palette colors already in colors.toml.

### CLI Tool for Accent Customization

**Approach: Bash script that modifies colors.toml and regenerates configs.**

The tool should:
1. Accept a new accent color as argument
2. Update `accent` (and optionally `selection_background`) in colors.toml
3. Update any static override files that hardcode accent values (btop.theme, hyprland.conf, waybar.css, walker.css, mako.ini)
4. Optionally call `omarchy-theme-set` to apply changes

**Why Bash, not Python or Node:**
- Omarchy's entire toolchain is Bash. Every `omarchy-*` script is Bash.
- The existing template system uses `sed` for substitution. Same pattern works for the CLI tool.
- Zero additional dependencies. Python would require ensuring python3 + toml library are installed. Node would require npm.
- The colors.toml format is trivially parseable with Bash: each line is `key = "value"`. No nested tables, no arrays, no complex TOML features.

**Pattern for colors.toml manipulation:**
```bash
# Read current accent
current_accent=$(grep '^accent' colors.toml | sed 's/.*"\(.*\)"/\1/')

# Set new accent
sed -i "s/^accent = .*/accent = \"$new_accent\"/" colors.toml
```

**Pattern for static file updates:**
```bash
# Replace old accent in all static override files
for file in waybar.css walker.css mako.ini hyprland.conf; do
  if [[ -f "$THEME_DIR/$file" ]]; then
    sed -i "s/$old_accent/$new_accent/g" "$THEME_DIR/$file"
  fi
done
```

**Accent variant generation:**
Pre-defined variants can be stored as simple mappings:
```bash
declare -A VARIANTS=(
  [purple]="#7B6CBD"
  [blue]="#6E8EC4"
  [teal]="#5AA8B5"
  [red]="#C45B6E"
  [green]="#6EA88E"
  [gold]="#C49B5A"
)
```

Each variant only changes `accent` and `selection_background` in colors.toml. The AMOLED black base, foreground, and ANSI palette remain constant.

### Color Generation Strategy

**Two-tier approach:**

1. **Template-generated files** (Omarchy handles these): When the theme has colors.toml but no static file for a component, Omarchy's `omarchy-theme-set-templates` generates it using `sed` on `.tpl` files. This covers: alacritty, kitty, ghostty, chromium, hyprlock, obsidian.

2. **Static override files** (theme ships these): For components where we want richer theming than the template provides. Clawmarchy already does this for btop.theme (custom gradients) and hyprland.conf (blur, animations). The new files -- waybar.css, walker.css, mako.ini -- should also be static overrides because:
   - We want urgency-based mako colors (template only supports 3 colors)
   - We may want accent-colored borders in Walker (template uses foreground for border)
   - We want AMOLED-specific Waybar styling beyond just colors

**The CLI tool bridges both tiers:** It updates colors.toml (for template-generated files) AND updates static override files (for custom-themed components). This ensures a single accent change propagates everywhere.

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| Bash CLI tool | Python CLI tool | If complex color manipulation is needed (HSL shifting, contrast checking, palette generation from a single color). Python has better color math libraries. For Clawmarchy's scope (predefined variants + manual hex input), Bash suffices. |
| Static override files | Template-only (colors.toml only) | If you want the simplest possible theme (just a colors.toml and backgrounds). Good for minimal themes. Not suitable for Clawmarchy because we need custom gradients (btop), urgency colors (mako), and AMOLED-specific CSS. |
| sed-based TOML editing | `toml-cli` or `stoml` | If colors.toml grows to include nested tables or arrays. Currently it is flat key-value pairs, making sed perfectly adequate. |
| Predefined accent variants | HSL-based auto-generation | If you wanted to generate variants algorithmically (rotate hue, keep saturation/lightness). More complex, more fragile, less control over exact colors. Predefined variants give curated, tested results. |

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| Python/Node for CLI | Adds dependency not present in Omarchy ecosystem | Bash + sed |
| CSS custom properties (`var()`) | Not supported in GTK3 CSS (Waybar) | `@define-color` + `@name` |
| JSON colors file | Not Omarchy convention | TOML (colors.toml) |
| Walker TOML theme config | Walker theming is CSS-based; its config.toml sets theme name only | walker.css for colors |
| Full TOML parser (stoml, etc.) | Overkill for flat key=value file | `grep` + `sed` |
| `mako.conf` filename | Omarchy uses `mako.ini` filename convention | `mako.ini` |

## Stack Patterns by Variant

**If adding a new accent variant:**
- Copy nothing. Modify colors.toml `accent` and `selection_background` values.
- Run CLI tool which updates colors.toml + static overrides.
- All template-generated files auto-update.

**If adding a new themed component (future):**
- Check if Omarchy has a `.tpl` template for it already.
- If yes and template is sufficient: just ensure colors.toml is correct, no static file needed.
- If yes but need more control: ship a static override file in theme directory.
- If no template exists: ship a static file and add it to CLI tool's update list.

**If Omarchy updates its templates:**
- Static overrides are immune to template changes (they skip generation).
- This is both a strength (stability) and a weakness (miss improvements).
- Periodically check if upstream templates have gained features worth adopting.

## Version Compatibility

| Component | Relevant Version | Notes |
|-----------|-----------------|-------|
| Waybar | Current Arch package | GTK3 CSS engine. `reload_style_on_change: true` in config.jsonc enables live reload. |
| Walker | Current Arch package | GTK4 CSS engine. Theme set via `config.toml`. Uses `@import` from theme directory. |
| Mako | Current Arch package | INI config format. `include=` directive for base config. Symlinked from `~/.config/mako/config`. |
| Omarchy | v3.x (current) | Template system uses `{{ key }}` / `{{ key_strip }}` / `{{ key_rgb }}` substitution. |
| Bash | 5.x | Required for associative arrays (accent variant map). Available on all Arch installs. |

## File Naming Convention

Omarchy expects specific filenames. Use these exactly:

| File | Purpose | Required |
|------|---------|----------|
| `colors.toml` | Color palette definition | Yes (enables template generation) |
| `waybar.css` | Waybar color overrides | Static override (skips template) |
| `walker.css` | Walker color overrides | Static override (skips template) |
| `mako.ini` | Mako notification config | Static override (skips template) |
| `swayosd.css` | SwayOSD overlay colors | Static override (skips template) |
| `hyprland.conf` | Hyprland WM overrides | Already exists in Clawmarchy |
| `btop.theme` | btop monitor theme | Already exists in Clawmarchy |
| `neovim.lua` | Neovim color scheme | Already exists in Clawmarchy |
| `vscode.json` | VS Code theme reference | Already exists in Clawmarchy |
| `icons.theme` | GTK icon theme name | Already exists in Clawmarchy |
| `backgrounds/` | Wallpaper images | Already exists in Clawmarchy |

## Sources

- Omarchy `omarchy-theme-set` script -- read from `$(which omarchy-theme-set)` on local system (HIGH confidence)
- Omarchy `omarchy-theme-set-templates` script -- read from `$(which omarchy-theme-set-templates)` on local system (HIGH confidence)
- Omarchy default templates at `~/.local/share/omarchy/default/themed/*.tpl` -- read from local system (HIGH confidence)
- Omarchy base configs: `~/.config/waybar/style.css`, `~/.config/walker/config.toml`, `~/.local/share/omarchy/default/mako/core.ini` -- read from local system (HIGH confidence)
- Walker default theme at `~/.local/share/omarchy/default/walker/themes/omarchy-default/` -- read from local system (HIGH confidence)
- [Waybar Wiki - Styling](https://github.com/Alexays/Waybar/wiki/Styling) -- GTK CSS reference (HIGH confidence)
- [Walker GitHub](https://github.com/abenz1267/walker) -- theme structure documentation (MEDIUM confidence)
- [Omarchy Theme Management DeepWiki](https://deepwiki.com/basecamp/omarchy/6.1-theme-management) -- architecture overview (MEDIUM confidence)
- [Omarchy GitHub Issue #327](https://github.com/basecamp/omarchy/issues/327) -- DHH decision to keep CSS files separate per component (HIGH confidence)
- [Omarchy Theme Manual](https://learn.omacom.io/2/the-omarchy-manual/92/making-your-own-theme) -- official theme creation guide (HIGH confidence)
- [HANCORE Sapphire Theme](https://github.com/HANCORE-linux/omarchy-sapphire-theme) -- community theme with full static overrides (MEDIUM confidence)
- [RetroPC Theme](https://github.com/rondilley/omarchy-retropc-theme) -- community theme shipping all static configs (MEDIUM confidence)

---
*Stack research for: Clawmarchy Omarchy theme expansion*
*Researched: 2026-02-18*
