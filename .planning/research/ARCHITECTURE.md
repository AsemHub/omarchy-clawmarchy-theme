# Architecture Patterns

**Domain:** Multi-tool desktop theme with color generation system
**Researched:** 2026-02-18

## Recommended Architecture

### The Critical Discovery: Omarchy Already Has a Template Engine

Omarchy v3.3.0 (released early 2025) introduced a built-in template generation system. The `omarchy-theme-set-templates` bash script reads `colors.toml`, extracts key-value pairs, and performs `sed` substitution on `.tpl` template files stored in `~/.local/share/omarchy/default/themed/`. This means Clawmarchy does NOT need to build its own template engine -- it needs to decide, for each target application, whether to (a) let Omarchy's built-in templates generate the config from `colors.toml`, or (b) ship a static override file that bypasses templates.

**Confidence: HIGH** -- Verified via Omarchy GitHub source (bin/omarchy-theme-set-templates), DeepWiki analysis, official manual at learn.omacom.io, and the existing `hyprland.conf` comment "Static override -- bypasses template generation" already in this repo.

### Architecture: Two-Track Config Resolution

```
colors.toml (source of truth)
     |
     +---> Omarchy Template Engine (omarchy-theme-set-templates)
     |         |
     |         +---> default/themed/waybar.css.tpl ----> waybar.css (generated)
     |         +---> default/themed/mako.ini.tpl -----> mako.ini (generated)
     |         +---> default/themed/walker.css.tpl ----> walker.css (generated)
     |         +---> default/themed/hyprland.conf.tpl -> hyprland.conf (generated)
     |         +---> default/themed/btop.theme.tpl ----> btop.theme (generated)
     |         +---> default/themed/*.tpl ------------> [13 app configs]
     |
     +---> Static Override (theme ships its own file)
               |
               +---> hyprland.conf (in theme repo) ----> OVERRIDES generated version
               +---> btop.theme (in theme repo) -------> OVERRIDES generated version
               +---> neovim.lua (in theme repo) -------> NOT templated by Omarchy
               +---> vscode.json (in theme repo) ------> NOT templated by Omarchy
```

**How it works:** When `omarchy-theme-set` activates a theme, it runs `omarchy-theme-set-templates` to generate configs from `.tpl` files. If the theme ships a static file with the same name (e.g., `waybar.css`), the static file takes precedence over the generated one. The generated files go to `~/.config/omarchy/current/next-theme/`, and the theme's own static files are also placed there via the atomic swap.

### Component Boundaries

| Component | Responsibility | Communicates With |
|-----------|---------------|-------------------|
| `colors.toml` | Single source of truth for palette. 24 color values: accent, cursor, foreground, background, selection_foreground, selection_background, color0-color15 | Read by Omarchy template engine; read by CLI tool |
| Omarchy Template Engine | Reads `colors.toml`, performs `{{ variable }}` substitution on `.tpl` files, outputs application configs | Reads `colors.toml`, writes to `next-theme/` dir |
| Static Override Files | Theme-specific configs that need more than color substitution (custom gradients, animations, non-color settings) | Placed in theme repo root, copied to `next-theme/` |
| CLI Tool (`clawmarchy-accent`) | Modifies `accent` value in `colors.toml`, then triggers `omarchy-theme-set` to regenerate | Writes `colors.toml`, calls `omarchy-theme-set` |
| Variant Generator | Creates color variant repos (blue, teal, red accent on same AMOLED base) | Reads `colors.toml`, writes modified copies |

### Data Flow

**Theme Application Flow (existing Omarchy pipeline):**

```
1. User runs: omarchy-theme-set clawmarchy
2. Omarchy normalizes theme name, locates theme directory
3. omarchy-theme-set-templates runs:
   a. Reads ~/.config/omarchy/themes/clawmarchy/colors.toml
   b. Extracts key=value pairs (while IFS='=' read -r key value)
   c. For each key, creates sed substitutions:
      - {{ key }}       -> "#RRGGBB" (full hex with #)
      - {{ key_strip }} -> "RRGGBB"  (without #)
      - {{ key_rgb }}   -> "R, G, B" (decimal RGB)
   d. Processes each .tpl file through sed pipeline
   e. Writes output to next-theme/ directory
4. Static files from theme repo are also placed in next-theme/
5. Atomic swap: next-theme/ -> current/theme/
6. Component restart scripts execute (waybar, mako, hyprctl reload, etc.)
```

**Accent Change Flow (new CLI tool):**

```
1. User runs: clawmarchy-accent "#5AA8B5" (or "teal")
2. CLI tool:
   a. Validates hex color (or maps named color to hex)
   b. Updates accent= line in colors.toml via sed
   c. Optionally updates selection_background= to match accent
   d. Runs: omarchy-theme-set clawmarchy
3. Omarchy's existing pipeline regenerates all configs
4. All apps reload with new accent color
```

**Key insight:** The CLI tool does not need to know how to generate Waybar CSS or Mako config. It only modifies `colors.toml` and delegates to Omarchy's existing template engine. This is architecturally clean -- the CLI is a thin wrapper around `colors.toml` editing + `omarchy-theme-set`.

## Template Variable Reference

Omarchy's template engine provides three formats for each `colors.toml` key:

| Template Variable | Output | Example for `accent = "#7B6CBD"` |
|-------------------|--------|----------------------------------|
| `{{ accent }}` | Full hex with # | `#7B6CBD` |
| `{{ accent_strip }}` | Hex without # | `7B6CBD` |
| `{{ accent_rgb }}` | Decimal RGB | `123, 108, 189` |

These work for ALL keys in `colors.toml`: accent, foreground, background, cursor, selection_foreground, selection_background, color0 through color15.

**Confidence: HIGH** -- Verified from omarchy-theme-set-templates source code analysis.

## Per-Application Architecture Decision

For each application Clawmarchy needs to theme, the decision is: **use Omarchy's template (let it generate) or ship a static override?**

### Applications That Should Use Omarchy Templates (generated from colors.toml)

| Application | Template File | Rationale |
|-------------|--------------|-----------|
| **Waybar** | `waybar.css.tpl` | Standard color application. Template handles CSS variable injection. No custom structure needed beyond colors. |
| **Walker** | `walker.css.tpl` | Standard color application. CSS with theme colors. |
| **Mako** | `mako.ini.tpl` | Simple INI format with background/foreground/border colors. Template handles it cleanly. |
| **SwayOSD** | `swayosd.css.tpl` | Standard CSS with color variables. |
| **Hyprlock** | `hyprlock.conf.tpl` | Lock screen colors. Template generation sufficient. |
| **Terminal configs** | `ghostty.conf.tpl`, `alacritty.toml.tpl`, `kitty.conf.tpl` | Direct color mapping. Templates handle perfectly. |
| **Chromium** | `chromium.theme.tpl` | Browser theme colors from palette. |

### Applications That MUST Ship Static Overrides

| Application | Static File | Rationale |
|-------------|------------|-----------|
| **btop** | `btop.theme` | Clawmarchy uses custom gradient mappings (cyan->blue->magenta) that go beyond simple color substitution. The template would use flat colors; Clawmarchy's aesthetic requires deliberate gradient design across 24 gradient endpoints. |
| **Hyprland** | `hyprland.conf` | Contains non-color config: blur settings (size=6, passes=2, noise=0.02), shadow settings, animation bezier curves, opacity override rule. Template only handles border color. |
| **Neovim** | `neovim.lua` | References external plugin (tokyonight.nvim) with Lua callback for AMOLED override. No Omarchy template exists for this. |
| **VS Code** | `vscode.json` | References extension by name. Will need expansion for workspace color customizations. No Omarchy template exists. |
| **Icons** | `icons.theme` | Simple text file, no template needed. |

### Applications That Could Go Either Way

| Application | Recommendation | Rationale |
|-------------|---------------|-----------|
| **Waybar** | Start with template, then static override if custom styling needed | If Clawmarchy needs custom module styling (specific opacity, custom fonts, gradient backgrounds), ship static `waybar.css`. If standard color application is sufficient, let template handle it. |
| **Walker** | Start with template | Color-only customization is likely sufficient for an app launcher. |

**Confidence: MEDIUM** -- The template-vs-override decision for Waybar/Walker depends on how much custom CSS Clawmarchy needs beyond color substitution. If Clawmarchy wants a distinctive visual style (not just recolored defaults), static overrides are needed.

## Patterns to Follow

### Pattern 1: Template-First, Override When Needed

**What:** Start by letting Omarchy's templates generate configs from colors.toml. Only ship a static override file when the template output is insufficient (custom gradients, non-color settings, external plugin references).

**When:** For every new application config added to the theme.

**Example decision process:**
```
Q: Does this app need only color substitution?
   YES -> Let Omarchy template handle it (no file in theme repo)
   NO  -> Ship static override file in theme repo

Q: Does this app need custom non-color settings?
   (blur, animations, gradients, plugin refs, module layout)
   YES -> Ship static override file
   NO  -> Let template handle it
```

### Pattern 2: Thin CLI Wrapper

**What:** The CLI tool only modifies `colors.toml` and calls `omarchy-theme-set`. It does NOT directly generate application configs.

**When:** Always. The CLI should never contain application-specific config generation logic.

**Example:**
```bash
#!/bin/bash
# clawmarchy-accent - Change accent color

NEW_ACCENT="$1"

# Validate
if [[ ! "$NEW_ACCENT" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
    echo "Usage: clawmarchy-accent '#RRGGBB'"
    exit 1
fi

# Update colors.toml
THEME_DIR="$HOME/.config/omarchy/themes/clawmarchy"
sed -i "s/^accent = .*/accent = \"$NEW_ACCENT\"/" "$THEME_DIR/colors.toml"

# Also update selection_background to match accent
sed -i "s/^selection_background = .*/selection_background = \"$NEW_ACCENT\"/" "$THEME_DIR/colors.toml"

# Regenerate all configs via Omarchy's pipeline
omarchy-theme-set clawmarchy
```

### Pattern 3: Static Override With Source Comments

**What:** Every static override file should document which colors reference `colors.toml` values and which are custom.

**When:** For all static override files (btop.theme, hyprland.conf).

**Example:**
```bash
# btop.theme - Clawmarchy static override
# Colors from colors.toml: main_bg (background), main_fg (foreground),
#   hi_fg (accent), selected_bg (color8)
# Custom gradients: NOT from colors.toml -- designed for AMOLED aesthetic
theme[main_bg]="#000000"        # = colors.toml background
theme[main_fg]="#E8E0D0"        # = colors.toml foreground
theme[hi_fg]="#7B6CBD"          # = colors.toml accent
theme[cpu_start]="#5AA8B5"      # = colors.toml color6 (custom gradient)
theme[cpu_mid]="#6E8EC4"        # = colors.toml color4 (custom gradient)
theme[cpu_end]="#9B7BC8"        # = colors.toml color5 (custom gradient)
```

### Pattern 4: Named Color Presets in CLI

**What:** The CLI tool should accept both hex codes and named presets for common accent colors.

**When:** For user-facing accent color changes.

**Example:**
```bash
# Named presets map to hex values
declare -A PRESETS=(
    [purple]="#7B6CBD"
    [teal]="#5AA8B5"
    [blue]="#6E8EC4"
    [rose]="#C45B6E"
    [gold]="#C49B5A"
    [green]="#6EA88E"
    [pink]="#B595DA"
    [cyan]="#72C4CE"
)
```

## Anti-Patterns to Avoid

### Anti-Pattern 1: Building a Custom Template Engine

**What:** Creating a bespoke template system (Jinja2, mustache, custom string replacement) to generate configs from colors.toml.
**Why bad:** Omarchy ALREADY has `omarchy-theme-set-templates` that does exactly this. Building a second engine creates maintenance burden, inconsistency with Omarchy ecosystem, and duplicated logic that can drift.
**Instead:** Use Omarchy's built-in template engine. For configs it cannot handle (custom gradients, non-color settings), ship static override files.

### Anti-Pattern 2: CLI Tool That Generates Configs Directly

**What:** Having the CLI accent-change tool directly write to waybar.css, mako.ini, etc.
**Why bad:** Couples the CLI to every application's config format. When Omarchy adds new template targets, the CLI would not benefit. When configs change format, the CLI breaks.
**Instead:** CLI modifies `colors.toml` only, then delegates to `omarchy-theme-set` for regeneration.

### Anti-Pattern 3: Duplicating Colors Across Static Files Without Cross-Reference

**What:** Hardcoding hex values in btop.theme, hyprland.conf without documenting which values come from colors.toml.
**Why bad:** This is the current state of the repo -- the same hex `#7B6CBD` appears in 5+ files with no traceability. When accent changes, static override files must be manually updated.
**Instead:** Document the mapping in comments. For the accent-change CLI, add sed commands that update static override files too.

### Anti-Pattern 4: Shipping Template Files (.tpl) in the Theme Repo

**What:** Putting custom `.tpl` files in the theme repo to override Omarchy's default templates.
**Why bad:** Omarchy's template engine looks for `.tpl` files in `~/.config/omarchy/themed/` and `$OMARCHY_PATH/default/themed/`, not in the theme directory itself. Shipping `.tpl` files in the theme repo has no effect unless copied to the right location.
**Instead:** Ship static output files (e.g., `waybar.css` not `waybar.css.tpl`) for overrides.

**Confidence: MEDIUM** -- The `.tpl` override mechanism needs verification. User-level `.tpl` overrides in `~/.config/omarchy/themed/` are referenced in the source but the exact precedence with theme-level static files needs testing.

## Static Override Files and the Accent Problem

The key architectural tension: static override files contain hardcoded hex values that do NOT update when `colors.toml` changes. For configs that need static overrides (btop.theme, hyprland.conf), the CLI tool must also update these files when accent changes.

### Solution: CLI Updates Both colors.toml AND Static Overrides

```
clawmarchy-accent "#5AA8B5"
  |
  +-> Update colors.toml accent= line
  +-> Update hyprland.conf: $activeBorderColor = rgb(ACCENT_STRIP)
  +-> Update btop.theme: theme[hi_fg], theme[*_box], etc.
  +-> Update selection_background in colors.toml
  +-> Run omarchy-theme-set clawmarchy (regenerates template-based configs)
```

This is the one place where the CLI needs application-specific knowledge. Keep it minimal: sed replacements targeting known patterns in known files.

### File Update Map for Accent Change

| File | Values to Update | Update Method |
|------|-----------------|---------------|
| `colors.toml` | `accent`, `selection_background` | sed on key= lines |
| `hyprland.conf` | `$activeBorderColor` | sed on rgb() value |
| `btop.theme` | `hi_fg`, `selected_fg`, `proc_misc`, `*_box` (4 values) | sed on theme[key] patterns |
| Template-generated files | All `{{ accent }}` references | Automatic via omarchy-theme-set |

## Component Diagram

```
+---------------------------+
|      User Interface       |
|  clawmarchy-accent CLI    |
|  (modifies colors.toml    |
|   + static overrides)     |
+-----------+---------------+
            |
            v
+---------------------------+
|     colors.toml           |
|  (24 color definitions)   |
|  Single source of truth   |
+-----------+---------------+
            |
     +------+------+
     |             |
     v             v
+----------+  +-----------+
| Omarchy  |  | Static    |
| Template |  | Override  |
| Engine   |  | Files     |
| (.tpl)   |  | (in repo) |
+----+-----+  +-----+-----+
     |               |
     v               v
+---------------------------+
|   next-theme/ directory   |
|   (staging area)          |
+-----------+---------------+
            |
            v (atomic swap)
+---------------------------+
|   current/theme/          |
|   (active theme files)    |
+-----------+---------------+
            |
            v
+---------------------------+
|   Application Configs     |
|   (sourced/imported by    |
|    each application)      |
+---------------------------+
     |    |    |    |    |
     v    v    v    v    v
  Hypr Waybar Mako Walker btop
  land              ...
```

## Build Order (What Depends on What)

This is the recommended implementation order based on dependencies:

### Phase 1: Foundation -- Template-Generated Configs

**Depends on:** Nothing (colors.toml already exists)

1. Remove static `waybar.css` from theme repo (if it exists) -- let Omarchy template generate it
2. Remove static `mako.ini` from theme repo (if it exists) -- let Omarchy template generate it
3. Remove static `walker.css` from theme repo (if it exists) -- let Omarchy template generate it
4. Verify that `omarchy-theme-set clawmarchy` generates correct Waybar, Mako, Walker configs from colors.toml
5. If generated output is insufficient, create static override files with custom styling

**Outcome:** Waybar, Mako, Walker themed consistently from colors.toml without manual hex duplication.

### Phase 2: Static Override Audit

**Depends on:** Phase 1 (understanding which configs need static overrides)

1. Audit existing `hyprland.conf` -- document which values come from colors.toml vs custom
2. Audit existing `btop.theme` -- document which values come from colors.toml vs custom gradients
3. Add source comments to all static override files
4. Verify static overrides take precedence over generated configs

**Outcome:** Clear documentation of which hex values in static files correspond to colors.toml keys.

### Phase 3: CLI Accent Tool

**Depends on:** Phase 2 (must know which static files to update)

1. Create `clawmarchy-accent` bash script
2. Implement hex validation and named presets
3. Implement colors.toml update (sed on accent= and selection_background=)
4. Implement static override updates (sed on hyprland.conf, btop.theme)
5. Call `omarchy-theme-set clawmarchy` at end

**Outcome:** Single command changes accent color across entire desktop.

### Phase 4: VS Code Workspace Colors

**Depends on:** Phase 1 (colors.toml as established source of truth)

1. Expand `vscode.json` with full `workbench.colorCustomizations`
2. Map colors.toml values to VS Code settings
3. Add to CLI tool's static override update list

**Outcome:** VS Code gets true AMOLED black, not just extension reference.

### Phase 5: Hyprland Window Rules Refinement

**Depends on:** Phase 1 (theme functioning with template-generated configs)

1. Replace global opacity hack with targeted window rules
2. Test transparency-dependent applications
3. Update hyprland.conf static override

**Outcome:** AMOLED compliance without breaking transparent apps.

### Phase 6: Accent Variants

**Depends on:** Phase 3 (CLI tool working)

1. Use CLI tool to generate variant colors.toml files
2. Package as separate theme repos or branches
3. Test each variant across all applications

**Outcome:** Multiple accent color theme packages available.

## Scalability Considerations

| Concern | Now (1 theme) | 5 accent variants | Community themes |
|---------|--------------|-------------------|-----------------|
| Color sync | Manual hex duplication | CLI updates colors.toml + static files | Omarchy templates handle most; static overrides per theme |
| New app support | Add static file or let template generate | CLI must know about new static files | Template engine scales; static overrides are per-theme |
| Omarchy upgrades | May add new .tpl templates | Variants benefit automatically | Static overrides may need updating if template format changes |
| Testing | Manual visual check | Test each variant | Visual regression testing may become needed |

## Sources

- Omarchy `omarchy-theme-set-templates` source: https://github.com/basecamp/omarchy/blob/master/bin/omarchy-theme-set-templates (HIGH confidence)
- Omarchy v3.3.0 release notes: https://github.com/basecamp/omarchy/releases/tag/v3.3.0 (HIGH confidence)
- Omarchy theme manual: https://learn.omacom.io/2/the-omarchy-manual/92/making-your-own-theme (HIGH confidence)
- Omarchy default templates: https://github.com/basecamp/omarchy/tree/master/default/themed (HIGH confidence)
- Omarchy theme management architecture: https://deepwiki.com/basecamp/omarchy/6.1-theme-management-and-architecture (MEDIUM confidence -- community documentation)
- Cobalt2 theme structure (reference theme): https://github.com/hoblin/omarchy-cobalt2-theme (HIGH confidence -- concrete example)
- Template variable format ({{ key }}, {{ key_strip }}, {{ key_rgb }}): Derived from omarchy-theme-set-templates source analysis (HIGH confidence)
- Hyprland three-layer configuration: https://deepwiki.com/basecamp/omarchy/4.1-hyprland-configuration (MEDIUM confidence)
- Issue #4237 -- template refactor accent color breakage: https://github.com/basecamp/omarchy/issues/4237 (HIGH confidence -- demonstrates override precedence)
- wallust/pywal template architecture (reference pattern): https://codeberg.org/explosion-mental/wallust (MEDIUM confidence)
- Omarchy theme generator (reference implementation): https://github.com/maxberggren/omarchy-theme-generator (MEDIUM confidence)

---

*Architecture analysis: 2026-02-18*
