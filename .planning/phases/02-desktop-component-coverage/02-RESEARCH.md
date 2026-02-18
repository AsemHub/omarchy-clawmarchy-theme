# Phase 2: Desktop Component Coverage - Research

**Researched:** 2026-02-18
**Domain:** Omarchy desktop component theming (CSS, INI, Hyprland conf, JSON)
**Confidence:** HIGH

## Summary

Phase 2 themes seven desktop components (Waybar, Walker, Mako, SwayOSD, Hyprlock, Chromium, VS Code) with AMOLED true black backgrounds and accent color highlights. The Omarchy theme framework uses a **static override mechanism**: when a theme repo contains a file matching a template name (e.g., `waybar.css`), the static file is copied verbatim instead of generating from the template. This means our custom theme files replace the default template-generated versions entirely.

Each component has a specific integration pattern. Waybar, Walker, and SwayOSD use GTK CSS with `@define-color` variables that are imported by Omarchy's structural stylesheets. Mako uses an INI config with color directives and urgency criteria sections. Hyprlock uses Hyprland-style conf with `$variable` definitions and widget blocks. Chromium uses a raw RGB triplet in `chromium.theme`. VS Code uses a JSON file that Omarchy reads for theme name/extension only -- workspace `colorCustomizations` are NOT auto-applied by the framework.

**Primary recommendation:** Create seven static override files in the theme repo root. For CSS-based components (Waybar, Walker, SwayOSD), define `@define-color` variables using AMOLED black and accent colors, plus add additional CSS rules for accent highlights. For Mako, write a complete INI config with urgency criteria. For Hyprlock, define color variables plus a clock label widget. For Chromium, write the AMOLED black RGB triplet. For VS Code, include `workbench.colorCustomizations` in `vscode.json` as data -- but document that Omarchy does not auto-apply it (manual user step or future enhancement).

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

#### Waybar design
- Solid true black (#000000) background, no transparency or blur
- Accent color on active workspace indicator and module icons (battery, wifi, clock icons)
- Workspace indicators as numbers, active workspace highlighted with accent
- No separators between module groups -- spacing alone distinguishes groups
- Text remains white/light gray

#### Notification urgency (Mako)
- All notifications have AMOLED black background
- Urgency differentiated by left-edge border stripe only (like Slack/Discord style)
  - Normal: accent color border
  - Low: muted yellow border
  - Critical: red border
- App name displayed in accent color, summary and body text in white/gray
- Border is left-edge stripe, not full border

#### Lock screen (Hyprlock)
- Large clock display over wallpaper, no date or extra info
- Clock text in accent color
- Password input is a dark box with accent-colored border, dot characters for password
- Wallpaper dimmed ~40-50% so clock and input field stand out clearly

#### Accent balance (cross-component)
- Moderate presence philosophy: accent on active/interactive elements plus borders, icons, and highlights -- noticeable but not dominant
- Walker: accent border on search input field AND accent highlight on selected result
- VS Code: AMOLED black backgrounds everywhere, accent only on active tab indicator and focus borders -- minimal accent in editor
- SwayOSD: black popup background with accent-colored progress bar for volume/brightness
- Chromium: AMOLED black background (accent usage at Claude's discretion)

### Claude's Discretion
- Chromium accent treatment details (beyond AMOLED black background)
- Exact font sizes and spacing across all components
- Waybar module icon selection
- Mako notification animation/timeout behavior
- SwayOSD popup size and positioning
- Walker result list density and styling beyond accent highlights

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| COMP-01 | Waybar status bar themed with AMOLED black background and accent colors via custom `waybar.css` override | Static `waybar.css` overrides template-generated version. Use `@define-color` for colors plus CSS rules for accent highlights on active workspace and module icons. Omarchy's structural `style.css` imports theme CSS via `@import`. |
| COMP-02 | Waybar includes semantic color variables (`@theme-red`, `@theme-yellow`, `@theme-green`) for status indicators | Add `@define-color theme-red`, `@define-color theme-yellow`, `@define-color theme-green` in `waybar.css`. These can be used by Omarchy's `style.css` for battery warning/critical states. |
| COMP-03 | Walker app launcher themed with AMOLED black base and accent-colored selection via custom `walker.css` override | Static `walker.css` overrides template. Define `@define-color` variables for `selected-text`, `text`, `base`, `border`, `foreground`, `background`. Omarchy's Walker theme CSS imports via `@import`. Add accent border on `.search-container` and accent highlight on `child:selected`. |
| COMP-04 | Mako notifications themed with AMOLED black background, accent border, and urgency-level color rules via custom `mako.ini` override | Static `mako.ini` overrides template. Include `include=` for core.ini, set global colors, add `[urgency=low]`, `[urgency=normal]`, `[urgency=critical]` sections with per-urgency border colors. |
| COMP-05 | SwayOSD volume/brightness popups themed with AMOLED colors via custom `swayosd.css` override | Static `swayosd.css` overrides template. Define `@define-color` for background, border, label, image, progress. Omarchy's structural CSS imports theme CSS. |
| COMP-06 | Hyprlock lock screen themed with AMOLED black colors via custom `hyprlock.conf` override | Static `hyprlock.conf` overrides template. Define `$color`, `$inner_color`, `$outer_color`, `$font_color`, `$check_color` variables for AMOLED black + accent. Add `label {}` block for clock widget. |
| COMP-07 | Chromium browser themed with AMOLED black background via `chromium.theme` file | Static `chromium.theme` with RGB triplet `0,0,0` for true AMOLED black. Omarchy's `omarchy-theme-set-browser` reads this and sets `BrowserThemeColor` policy. |
| VSCE-01 | VS Code vscode.json includes full `workbench.colorCustomizations` with AMOLED black editor, sidebar, terminal, and panel backgrounds | Extend existing `vscode.json` to include `colorCustomizations` key. Omarchy does NOT auto-apply this -- only reads `name` and `extension`. Document manual application step. |
| VSCE-02 | VS Code workspace colors use accent color for active indicators, borders, and selections | Include accent color for `tab.activeBorderTop`, `focusBorder`, `selection.background`, etc. in the `colorCustomizations` within `vscode.json`. |
</phase_requirements>

## Standard Stack

### Core

This phase uses no external libraries. All components are themed via static configuration files in native formats.

| Tool | Config Format | Theme File | Purpose |
|------|--------------|------------|---------|
| Waybar | GTK CSS | `waybar.css` | Status bar color variables + accent rules |
| Walker | GTK CSS | `walker.css` | App launcher color variables |
| Mako | INI | `mako.ini` | Notification colors + urgency criteria |
| SwayOSD | GTK CSS | `swayosd.css` | Volume/brightness popup colors |
| Hyprlock | Hyprland conf | `hyprlock.conf` | Lock screen color variables + clock widget |
| Chromium | Raw RGB | `chromium.theme` | Browser toolbar color |
| VS Code | JSON | `vscode.json` | Editor color customizations |

### Supporting

| Tool | Version | Purpose |
|------|---------|---------|
| Hyprlock | v0.9.2 | Lock screen compositor; supports `label {}` widget blocks for clock |
| Mako | Current | Notification daemon; supports `[urgency=X]` criteria sections |
| `omarchy-theme-set` | Current | Theme installation pipeline; copies static files, then generates from templates |
| `omarchy-theme-set-browser` | Current | Reads `chromium.theme` RGB triplet, sets Chromium policy |
| `omarchy-theme-set-vscode` | Current | Reads `vscode.json` for `name` and `extension` only |

## Architecture Patterns

### Omarchy Theme Override Mechanism

**What:** When a theme repo contains a file matching a template name, the static file takes priority over template generation.

**How it works (verified from `omarchy-theme-set` and `omarchy-theme-set-templates` source code):**

1. `omarchy-theme-set` copies ALL files from theme repo to `~/.config/omarchy/current/next-theme/`
2. `omarchy-theme-set-templates` processes `.tpl` files, but SKIPS any where the output file already exists
3. The next-theme directory is atomically swapped into `~/.config/omarchy/current/theme/`
4. Component-specific scripts restart services (waybar, mako, swayosd, etc.)

**Critical insight:** Static files in the theme repo **completely replace** template output. You must include ALL necessary content (variables, rules) -- the template-generated defaults are gone.

**Template variables available (from `colors.toml`):**
- `{{ key }}` -- raw value (e.g., `#7B6CBD`)
- `{{ key_strip }}` -- value without `#` prefix (e.g., `7B6CBD`)
- `{{ key_rgb }}` -- decimal RGB (e.g., `123,108,189`)

### CSS Import Pattern (Waybar, Walker, SwayOSD)

**What:** Omarchy's structural stylesheets import the theme CSS via `@import`, then use `@define-color` variables.

**Example (Waybar):**

Omarchy's `~/.config/waybar/style.css` (managed by Omarchy, NOT by theme):
```css
@import "../omarchy/current/theme/waybar.css";

* {
  background-color: @background;
  color: @foreground;
  /* ... structural rules ... */
}
```

Theme's `waybar.css` (what we create):
```css
/* Color variable definitions -- imported by Omarchy's structural style.css */
@define-color foreground #E8E0D0;
@define-color background #000000;

/* Semantic status colors for battery/system indicators */
@define-color theme-red #C45B6E;
@define-color theme-yellow #C49B5A;
@define-color theme-green #6EA88E;

/* Additional accent rules applied on top of structural CSS */
#workspaces button.active {
  color: #7B6CBD;
}
```

**Key point:** The theme CSS is imported FIRST, so `@define-color` declarations are available to structural rules. Additional CSS rules in the theme file cascade normally -- they can override or extend structural rules.

### Mako INI Override Pattern

**What:** `~/.config/mako/config` is a symlink to the theme's `mako.ini`. The theme file IS the entire mako config.

**Structure:**
```ini
include=~/.local/share/omarchy/default/mako/core.ini

# Global color defaults
text-color=#E8E0D0
border-color=#7B6CBD
background-color=#000000

# Per-urgency overrides
[urgency=low]
border-color=#C49B5A

[urgency=critical]
border-color=#C45B6E
```

**Critical:** The `include=` line pulls in Omarchy's core settings (anchor, timeout, width, padding, font, app-specific rules). Our override adds color directives and urgency criteria sections AFTER the include.

### Hyprlock Variable + Widget Pattern

**What:** Omarchy's structural `hyprlock.conf` sources the theme file at the top. The theme defines `$variables` used by structural config AND can add extra widget blocks.

**Flow:**
```
~/.config/hypr/hyprlock.conf (Omarchy structural):
  source = ~/.config/omarchy/current/theme/hyprlock.conf  <-- our file
  background { color = $color; path = ...; blur_passes = 3 }
  input-field { inner_color = $inner_color; ... }
```

**Our `hyprlock.conf` defines variables AND adds a label widget:**
```
$color = rgba(0,0,0, 1.0)
$inner_color = rgba(0,0,0, 0.8)
$outer_color = rgba(123,108,189, 1.0)
$font_color = rgba(232,224,208, 1.0)
$check_color = rgba(123,108,189, 1.0)

# Clock widget (added by theme, not in Omarchy structural config)
label {
    monitor =
    text = cmd[update:1000] date "+%H:%M"
    color = rgba(123,108,189, 1.0)
    font_size = 120
    font_family = JetBrainsMono Nerd Font
    position = 0, 200
    halign = center
    valign = center
}
```

### Chromium Theme Pattern

**What:** `chromium.theme` contains a single line: RGB decimal triplet. Omarchy reads it and sets browser policy.

**From `omarchy-theme-set-browser` source:**
```bash
THEME_RGB_COLOR=$(<$CHROMIUM_THEME)
THEME_HEX_COLOR=$(printf '#%02x%02x%02x' ${THEME_RGB_COLOR//,/ })
echo "{\"BrowserThemeColor\": \"$THEME_HEX_COLOR\"}" | tee "/etc/chromium/policies/managed/color.json"
```

**Our file:** `0,0,0` (AMOLED true black)

### VS Code Theme Pattern

**What:** `vscode.json` currently holds `name` and `extension`. Omarchy reads ONLY these two keys.

**Current `omarchy-theme-set-vscode` behavior (verified from source):**
1. Reads `name` via `jq -r '.name'`
2. Reads `extension` via `jq -r '.extension'`
3. Installs extension if missing
4. Sets `workbench.colorTheme` in VS Code settings.json
5. Does NOT read or apply any other keys

**For VSCE-01/VSCE-02:** We include `colorCustomizations` in `vscode.json` as structured data. Users must manually add these to their VS Code settings. This is a known framework limitation.

### Anti-Patterns to Avoid

- **Modifying Omarchy structural files:** Never edit `~/.config/waybar/style.css` or `~/.local/share/omarchy/config/*`. These are Omarchy-managed and will be overwritten on refresh/update.
- **Using template syntax in static overrides:** Static files are copied verbatim -- `{{ accent }}` will NOT be interpolated. Use hardcoded hex values.
- **Assuming template defaults exist alongside overrides:** When you provide `waybar.css`, the template-generated version is SKIPPED entirely. Your file must define ALL needed `@define-color` variables.
- **Setting mako border-size per-side:** Mako's `border-size` is a single px value, NOT directional. Cannot do left-only border natively (see Pitfalls).

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Color variable injection | Custom preprocessing scripts | Hardcoded hex values in static files | Static files bypass template engine; Phase 3 adds source comments for traceability |
| Waybar layout changes | Custom config.jsonc | Omarchy's existing config.jsonc structure | Requirements explicitly exclude layout/module changes |
| Walker layout changes | Custom layout.xml | Omarchy's existing layout.xml | Theme only provides CSS colors, not structural changes |
| Browser theme distribution | Chrome extension / manifest.json | `chromium.theme` RGB triplet | Omarchy's policy-based approach handles Chromium, Brave, and Helium |
| VS Code extension | Custom VS Code theme extension | `workbench.colorCustomizations` in settings | Tokyo Night extension handles syntax highlighting; we only override workspace colors |

**Key insight:** Omarchy separates structure (layout, modules, behavior) from styling (colors, accents). Phase 2 only touches styling. Every structural file is Omarchy-managed and should not be modified.

## Common Pitfalls

### Pitfall 1: Mako Left-Edge-Only Border Not Natively Supported

**What goes wrong:** User wants Slack/Discord-style left-edge stripe for urgency differentiation, but mako's `border-size` applies uniformly to all four edges.
**Why it happens:** Mako's border system is not directional -- `border-size=px` sets all sides equally. Unlike CSS `border-left`, there is no `border-left-size` option.
**How to avoid:** Use a thin full border (2-3px) as the urgency indicator. The visual effect is similar -- colored border around the notification -- even though it's not left-edge only. Set `border-size=2` or `border-size=3` globally, then use per-urgency `border-color` in criteria sections. This is the closest mako-native approximation.
**Alternative:** Set `border-size=0` and use `padding=0,0,0,4` (directional: top, horizontal, bottom -- wait, mako uses top,right,bottom,left for 4-value) combined with `background-color` tricks, but this is fragile and hacky.
**Recommendation:** Use thin full border. Document the limitation. The urgency color differentiation (accent/yellow/red) is the important part, not the border geometry.

### Pitfall 2: Static Override Replaces ALL Template Variables

**What goes wrong:** Creating `waybar.css` with only accent-related additions, forgetting to define `@foreground` and `@background`. Waybar's structural CSS references these variables and they become undefined.
**Why it happens:** The template-generated `waybar.css` normally defines `@foreground` and `@background`. When overridden, those definitions disappear.
**How to avoid:** Always check the template file (`.tpl`) to see ALL variables it defines. Your static override MUST define every variable the structural CSS references.
**Warning signs:** Components showing default GTK colors or invisible elements after theme switch.

### Pitfall 3: Walker CSS Variables Must Match Exactly

**What goes wrong:** Walker's theme CSS is imported by a GTK CSS stylesheet that references specific `@define-color` names: `selected-text`, `text`, `base`, `border`, `foreground`, `background`.
**Why it happens:** Walker's structural CSS uses these exact names. Missing or renamed variables cause fallback to GTK defaults.
**How to avoid:** Copy the variable list from the template (`walker.css.tpl`) and redefine with AMOLED values. Then add additional rules.

### Pitfall 4: Hyprlock Label Block Placement

**What goes wrong:** Adding a `label {}` block in the theme's `hyprlock.conf` that conflicts with or is overridden by the structural config.
**Why it happens:** The theme file is `source`d at the TOP of Omarchy's `hyprlock.conf`. Variable definitions work fine (they're just assignments), but widget blocks (label, background, input-field) are additive in Hyprlock -- each `label {}` block creates a new widget.
**How to avoid:** This is actually safe. Each `label {}` block in Hyprlock creates a separate label widget. The theme can add clock labels without conflicting with the structural input-field or background blocks.
**Warning signs:** If you accidentally redefine `background {}` or `input-field {}` in the theme file, Hyprlock will show duplicate widgets.

### Pitfall 5: Hyprlock Wallpaper Dimming

**What goes wrong:** The user wants wallpaper dimmed 40-50% for lock screen contrast. The Omarchy structural config sets `blur_passes = 3` on the background but doesn't control dimming.
**Why it happens:** Hyprlock's `background {}` block supports `color` as an overlay on top of the wallpaper when `path` is also set. If `color` has alpha < 1.0, the wallpaper shows through with blending.
**How to avoid:** Do NOT override the `background {}` block in the theme file (that would create a duplicate). Instead, adjust the `$color` variable. However, `$color` is used by the structural `background { color = $color }` as a FALLBACK color (shown when wallpaper path is invalid), not as an overlay.
**Actual solution:** Hyprlock does not natively support wallpaper dimming as a simple config value. Options:
1. Set `blur_passes` high + low `brightness` (blur inherently dims) -- but this is Omarchy's config, not ours
2. Use a semi-transparent black overlay -- not directly available in hyprlock background config
3. Accept current blur-based approach (3 blur passes already reduce effective brightness)
**Recommendation:** The existing blur (3 passes) provides some visual softening. For explicit dimming, we would need to add a second `background {}` block with a semi-transparent black color and NO path (pure color overlay on top). Test whether Hyprlock layers multiple background blocks. If not, document this as a limitation where blur substitutes for dimming.

### Pitfall 6: VS Code colorCustomizations Not Auto-Applied

**What goes wrong:** Adding `workbench.colorCustomizations` to `vscode.json`, expecting Omarchy to apply them automatically.
**Why it happens:** `omarchy-theme-set-vscode` only reads `name` and `extension` from the JSON. It uses `jq -r '.name'` and `jq -r '.extension'` and ignores everything else.
**How to avoid:** Include the `colorCustomizations` as data in `vscode.json` for reference, but document that users must manually add these to their VS Code `settings.json`. Phase 5 documentation should include a copy-paste snippet.
**Warning signs:** VS Code shows Tokyo Night defaults but without AMOLED black overrides.

### Pitfall 7: SwayOSD Opacity in Structural CSS

**What goes wrong:** SwayOSD's Omarchy structural CSS includes `opacity: 0.97` on the window. This conflicts with AMOLED true black (any opacity < 1.0 causes gray wash if wallpaper shows through).
**Why it happens:** Omarchy's default `swayosd/style.css` sets `opacity: 0.97` for a subtle transparency effect.
**How to avoid:** Our `swayosd.css` theme file only defines `@define-color` variables -- it doesn't control the structural CSS's opacity rule. However, Phase 1 added `layerrule = blur off, match:namespace swayosd` which disables blur. Without blur, the 0.97 opacity will show a thin sliver of wallpaper/desktop content through the popup.
**Recommendation:** This is a structural CSS issue we cannot fix from the theme file alone. Options: (a) accept 0.97 opacity as close enough, (b) add an additional CSS rule in `swayosd.css` to override `window { opacity: 1.0; }` -- but since the import is at the TOP of the structural file, the structural `opacity: 0.97` would override ours. Need to test CSS cascade behavior. If `@import` CSS rules have lower specificity, we may need `!important` or a more specific selector.

## Code Examples

### waybar.css (Static Override)

```css
/* Clawmarchy AMOLED Dark Theme - Waybar
 * Static override -- replaces template-generated waybar.css
 * Source: colors.toml values hardcoded (Phase 3 adds source comments)
 */

/* === Color Variables (required by Omarchy structural style.css) === */
@define-color foreground #E8E0D0;      /* colors.toml: foreground */
@define-color background #000000;      /* colors.toml: background */

/* === Semantic Status Colors (COMP-02) === */
@define-color theme-red #C45B6E;       /* colors.toml: color1 */
@define-color theme-yellow #C49B5A;    /* colors.toml: color3 */
@define-color theme-green #6EA88E;     /* colors.toml: color2 */

/* === Accent Highlights === */

/* Active workspace number highlighted with accent */
#workspaces button.active {
  color: #7B6CBD;                       /* colors.toml: accent */
}

/* Module icons in accent color */
#battery,
#network,
#pulseaudio,
#bluetooth,
#cpu {
  color: #7B6CBD;                       /* colors.toml: accent */
}

/* Battery warning/critical states use semantic colors */
#battery.warning {
  color: @theme-yellow;
}

#battery.critical {
  color: @theme-red;
}

/* Clock text in foreground (no accent) */
#clock {
  color: @foreground;
}

/* Tooltip styling */
tooltip {
  background-color: #000000;
  color: #E8E0D0;
}
```

### walker.css (Static Override)

```css
/* Clawmarchy AMOLED Dark Theme - Walker
 * Static override -- replaces template-generated walker.css
 */

/* === Color Variables (required by Omarchy Walker theme CSS) === */
@define-color selected-text #7B6CBD;   /* colors.toml: accent */
@define-color text #E8E0D0;           /* colors.toml: foreground */
@define-color base #000000;            /* colors.toml: background */
@define-color border #7B6CBD;          /* colors.toml: accent (accent border on search) */
@define-color foreground #E8E0D0;      /* colors.toml: foreground */
@define-color background #000000;      /* colors.toml: background */
```

### mako.ini (Static Override)

```ini
# Clawmarchy AMOLED Dark Theme - Mako Notifications
# Static override -- replaces template-generated mako.ini

include=~/.local/share/omarchy/default/mako/core.ini

# Global defaults -- AMOLED black background
text-color=#E8E0D0
border-color=#7B6CBD
background-color=#000000FF
border-size=3

# Urgency: low -- muted yellow border
[urgency=low]
border-color=#C49B5A

# Urgency: normal -- accent color border (inherits global)
# (no override needed, global border-color is accent)

# Urgency: critical -- red border
[urgency=critical]
border-color=#C45B6E
default-timeout=0
```

### swayosd.css (Static Override)

```css
/* Clawmarchy AMOLED Dark Theme - SwayOSD
 * Static override -- replaces template-generated swayosd.css
 */

@define-color background-color #000000;  /* colors.toml: background */
@define-color border-color #E8E0D0;      /* colors.toml: foreground */
@define-color label #E8E0D0;             /* colors.toml: foreground */
@define-color image #E8E0D0;             /* colors.toml: foreground */
@define-color progress #7B6CBD;          /* colors.toml: accent */
```

### hyprlock.conf (Static Override)

```
# Clawmarchy AMOLED Dark Theme - Hyprlock
# Static override -- replaces template-generated hyprlock.conf

# Color variables used by Omarchy's structural hyprlock.conf
$color = rgba(0,0,0, 1.0)
$inner_color = rgba(0,0,0, 0.8)
$outer_color = rgba(123,108,189, 1.0)
$font_color = rgba(232,224,208, 1.0)
$check_color = rgba(123,108,189, 1.0)

# Large clock display (theme addition -- not in Omarchy structural config)
label {
    monitor =
    text = cmd[update:1000] date "+%H:%M"
    color = rgba(123,108,189, 1.0)
    font_size = 120
    font_family = JetBrainsMono Nerd Font
    position = 0, 200
    halign = center
    valign = center
    shadow_passes = 1
    shadow_size = 5
}
```

### chromium.theme (Static Override)

```
0,0,0
```

### vscode.json (Extended)

```json
{
  "name": "Tokyo Night",
  "extension": "enkia.tokyo-night",
  "colorCustomizations": {
    "[Tokyo Night]": {
      "editor.background": "#000000",
      "editor.foreground": "#E8E0D0",
      "sideBar.background": "#000000",
      "sideBar.foreground": "#E8E0D0",
      "sideBarTitle.foreground": "#E8E0D0",
      "activityBar.background": "#000000",
      "activityBar.foreground": "#E8E0D0",
      "panel.background": "#000000",
      "panel.border": "#111118",
      "terminal.background": "#000000",
      "terminal.foreground": "#E8E0D0",
      "titleBar.activeBackground": "#000000",
      "titleBar.activeForeground": "#E8E0D0",
      "statusBar.background": "#000000",
      "statusBar.foreground": "#E8E0D0",
      "tab.activeBackground": "#000000",
      "tab.activeBorderTop": "#7B6CBD",
      "tab.inactiveBackground": "#000000",
      "tab.inactiveForeground": "#8A8598",
      "editorGroupHeader.tabsBackground": "#000000",
      "focusBorder": "#7B6CBD",
      "selection.background": "#7B6CBD40",
      "list.activeSelectionBackground": "#7B6CBD30",
      "list.activeSelectionForeground": "#E8E0D0",
      "input.background": "#111118",
      "input.border": "#2A2835",
      "input.foreground": "#E8E0D0",
      "dropdown.background": "#000000",
      "breadcrumb.background": "#000000",
      "editorWidget.background": "#000000"
    }
  }
}
```

**NOTE:** The `colorCustomizations` key is NOT read by `omarchy-theme-set-vscode`. Users must manually add these to their VS Code `settings.json` as `workbench.colorCustomizations`. See Pitfall 6.

## State of the Art

| Component | Template Default | Clawmarchy Override | What Changes |
|-----------|-----------------|---------------------|--------------|
| waybar.css | 2 variables (foreground, background) | 2 variables + 3 semantic colors + accent rules | Adds `@theme-red/yellow/green`, active workspace accent, module icon accent |
| walker.css | 6 variables (basic colors) | 6 variables (AMOLED + accent) | Changes `base` to #000000, `border` and `selected-text` to accent |
| mako.ini | 3 colors + include | 3 colors + include + urgency criteria | Adds `[urgency=low]`, `[urgency=critical]` sections |
| swayosd.css | 5 variables | 5 variables (AMOLED + accent) | Changes background to #000000, progress to accent |
| hyprlock.conf | 5 variables | 5 variables + label widget | Adds clock `label {}` block with accent color |
| chromium.theme | Template RGB from background | Static `0,0,0` | AMOLED true black instead of theme background |
| vscode.json | name + extension | name + extension + colorCustomizations | Adds full workspace color override data |

## Open Questions

1. **Hyprlock wallpaper dimming mechanism**
   - What we know: User wants 40-50% dimming. Omarchy's structural config sets `blur_passes = 3` and uses wallpaper path. Hyprlock's `background { color }` is a fallback, not an overlay.
   - What's unclear: Whether multiple `background {}` blocks layer in Hyprlock (one with wallpaper, one with semi-transparent black overlay). Need runtime testing.
   - Recommendation: Start with the existing blur approach. If insufficient, test adding a second `background {}` block with `color = rgba(0,0,0,0.5)` and no `path`. If Hyprlock doesn't support layered backgrounds, accept blur as the dimming mechanism and document.

2. **Mako left-edge-only border stripe**
   - What we know: Mako `border-size` is uniform (all edges). No per-side border support verified in man page.
   - What's unclear: Whether future mako versions add directional borders (unlikely short-term).
   - Recommendation: Use thin full border (2-3px) with per-urgency color. Document as a compromise -- the color differentiation is the key UX element, not the geometry.

3. **SwayOSD opacity conflict**
   - What we know: Omarchy's structural `style.css` sets `opacity: 0.97` on SwayOSD window. Our theme CSS is imported before the structural rules.
   - What's unclear: Whether adding `window { opacity: 1.0 !important; }` in `swayosd.css` would override the structural rule (GTK CSS specificity).
   - Recommendation: Test at implementation time. If CSS cascade doesn't work, accept 0.97 (virtually indistinguishable from 1.0 on most displays).

4. **VS Code colorCustomizations application method**
   - What we know: Omarchy's `omarchy-theme-set-vscode` only handles `workbench.colorTheme`. It does not read or apply `colorCustomizations`.
   - What's unclear: Whether Omarchy will add this capability in the future. Whether a `theme-set` hook approach is appropriate.
   - Recommendation: Include settings in `vscode.json` as reference data. Document manual copy step. Consider a simple shell script or theme-set hook as optional enhancement (Claude's discretion for implementation detail).

5. **SwayOSD and Walker layer namespace verification**
   - What we know: Phase 1 added `layerrule = blur off` for namespaces `swayosd` and `walker` with "verify with hyprctl layers" comments.
   - What's unclear: Whether these exact namespace strings are correct at runtime.
   - Recommendation: Verify with `hyprctl layers` during implementation/testing. If namespaces differ, update `hyprland.conf` layerrules accordingly.

## Sources

### Primary (HIGH confidence)

- **Omarchy source code** (local filesystem) -- `omarchy-theme-set`, `omarchy-theme-set-templates`, `omarchy-theme-set-browser`, `omarchy-theme-set-vscode`, `omarchy-refresh-waybar`, `omarchy-refresh-walker`, `omarchy-refresh-swayosd`, `omarchy-refresh-hyprlock`, `omarchy-restart-mako` -- verified theme installation pipeline, override mechanism, and component integration patterns
- **Omarchy structural configs** (local filesystem) -- `~/.local/share/omarchy/config/waybar/style.css`, `~/.local/share/omarchy/config/swayosd/style.css`, `~/.local/share/omarchy/config/hypr/hyprlock.conf`, `~/.local/share/omarchy/default/walker/themes/omarchy-default/style.css`, `~/.local/share/omarchy/default/mako/core.ini` -- verified CSS import patterns, variable references, and config structures
- **Omarchy default templates** (local filesystem) -- `~/.local/share/omarchy/default/themed/*.tpl` -- verified all template variable names that must be replicated in static overrides
- **Mako man page** (`man 5 mako`) -- verified INI config format, urgency criteria syntax, border-size limitation (not directional), color format (#RRGGBB or #RRGGBBAA)
- **Hyprlock** (v0.9.2 installed) -- verified `label {}` widget support for clock display
- **Built-in Omarchy themes** (local filesystem) -- `~/.local/share/omarchy/themes/kanagawa/`, `~/.local/share/omarchy/themes/rose-pine/` -- verified theme file patterns and override examples

### Secondary (MEDIUM confidence)

- **Hyprlock label widget** -- `label {}` block with `text`, `color`, `font_size`, `font_family`, `position`, `halign`, `valign` fields. Based on Hyprland wiki patterns and similar configs observed in community themes. Needs runtime verification for exact positioning behavior.
- **GTK CSS `@define-color` cascade** -- Theme CSS imported via `@import` defines color variables used by subsequent rules. Based on GTK4 CSS specification behavior. Verified by Omarchy's working pattern (template-generated files work this way).

### Tertiary (LOW confidence)

- **Hyprlock multiple background blocks** -- Whether Hyprlock supports layering multiple `background {}` blocks (one wallpaper, one semi-transparent overlay) is unverified. Needs runtime testing.
- **SwayOSD CSS `!important` override** -- Whether `!important` in imported CSS can override structural CSS rules in GTK4 is unverified. Needs runtime testing.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- all tools, formats, and integration points verified from local Omarchy source code and man pages
- Architecture: HIGH -- override mechanism, CSS import pattern, and config flow verified from actual script source code
- Pitfalls: HIGH for framework-level issues (override completeness, VS Code limitation), MEDIUM for runtime behavior (Hyprlock dimming, SwayOSD opacity cascade)
- Code examples: MEDIUM -- based on verified patterns but need runtime testing for exact visual results

**Research date:** 2026-02-18
**Valid until:** 2026-03-18 (30 days -- stable configuration patterns, unlikely to change)
