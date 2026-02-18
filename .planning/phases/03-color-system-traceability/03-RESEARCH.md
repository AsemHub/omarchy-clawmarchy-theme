# Phase 3: Color System Traceability - Research

**Researched:** 2026-02-18
**Domain:** Color audit, inline annotation, file classification, and reference documentation for an Omarchy theme
**Confidence:** HIGH

## Summary

Phase 3 is a documentation-only phase: audit every hardcoded color value across all 10 theme config files, annotate each with its colors.toml source key, classify files by their maintenance model (Omarchy-generated vs static override), and publish a reference document (`COLORS.md`) at the repo root. No color values are changed and no new functionality is added.

The codebase has 10 theme config files containing color values. Three CSS files (waybar.css, walker.css, swayosd.css) already have partial `/* colors.toml: keyname */` annotations from Phase 2 implementation. The remaining 7 files (hyprland.conf, hyprlock.conf, mako.ini, btop.theme, vscode.json, neovim.lua, chromium.theme) have no source mapping annotations. The complete audit identifies **~120 individual color value occurrences** across all files, mapping to 22 of the 24 colors.toml keys, plus 4 unmapped values (2 neovim-specific dark backgrounds, 2 VS Code transparency-modified accent values). Every file in this repo is a static override -- none are Omarchy-generated -- but the classification still matters because it tells maintainers which files need manual updates when the accent color changes versus which could theoretically be regenerated.

**Primary recommendation:** Execute in two plans -- Plan 1 annotates all config files with inline comments and header classifications, Plan 2 creates COLORS.md as the reference document. This order ensures the reference doc can be written from verified inline annotations rather than duplicating audit work.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

#### Annotation style
- Inline comments next to each hex value in the actual config file
- Comment format is Claude's discretion -- pick the clearest approach per file format
- Which color value formats to annotate (hex only vs rgba etc.) is Claude's discretion
- For files that don't support native comments (JSON), use `_comment` or `//` keys within the JSON where the format allows it (established pattern from 02-03 VS Code work)

#### Reference document structure
- Lives in repo root (e.g., `COLORS.md`) -- visible to users and contributors
- Organization approach is Claude's discretion -- pick what's most useful for maintainers
- Must prominently flag which files need manual updates when accent color changes -- clear callout per static file, not buried as metadata

#### File classification criteria
- Classification granularity (binary vs three-tier) is Claude's discretion based on what the codebase actually shows
- Classification surfaced in BOTH places: header comment in each file AND listed in the reference document
- Whether to annotate generated files is Claude's discretion -- based on whether it adds value per file
- Header comment format/wording is Claude's discretion -- balance consistency with format-appropriateness

#### Unmapped color handling
- Hex values that don't map directly to a colors.toml key should be flagged as unmapped -- clearly marked so they're visible during future audits
- Whether to also propose new colors.toml keys for unmapped values is Claude's discretion
- Whether some hardcoded values are intentional (e.g., pure black, urgency colors) vs accidentally untracked is Claude's discretion to determine
- Audit scope (this repo only vs template engine context) is Claude's discretion -- scope based on what's useful for theme maintainers

### Claude's Discretion
- Inline comment format per file type
- Which color value formats warrant annotation
- Reference document organization (by component, by role, or hybrid)
- File classification granularity
- Whether generated files get annotations
- Header comment format standardization
- Proposal of new colors.toml keys for unmapped values
- Distinguishing intentional hardcoded values from accidental ones
- Audit scope relative to Omarchy's template engine

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| FNDTN-03 | Color hex values in all static override files have source comments mapping them to their colors.toml key names | Complete audit of all 10 config files done. 3 CSS files have partial annotations; 7 files need full annotation. All hex, rgba, and rgb() values mapped to colors.toml keys. 4 unmapped values identified. |
| CLR-01 | All static override files that hardcode hex values include comments documenting which colors.toml key each value corresponds to | Same audit as FNDTN-03. Comment format varies by file type: `/* */` for CSS, `#` for conf/ini/theme/toml, `--` for Lua, `_comment` keys for JSON. |
| CLR-02 | Audit identifies which theme files are Omarchy-generated vs static overrides (must be manually updated when accent changes) | All 10 color-bearing files in this repo are static overrides. Classification uses binary model: "Static override (manual update)" vs "Omarchy-generated (auto-generated from colors.toml)". No Omarchy-generated files exist in this repo -- colors.toml IS the source that Omarchy reads, and all other files are static overrides. |
| CLR-03 | Audit results documented in a color traceability section in README or dedicated reference | Dedicated `COLORS.md` at repo root (per locked decision). Organized as hybrid: file-by-file audit with per-file "update required?" callout, plus a summary table of all colors.toml keys and where they appear. |
</phase_requirements>

## Standard Stack

### Core

This phase uses no external libraries. All work is editing existing config files (adding comments) and creating one new Markdown document.

| Tool | Purpose | Notes |
|------|---------|-------|
| Text editor | Add inline annotations to 10 config files | Each file has its own comment syntax |
| Markdown | Write COLORS.md reference document | Standard GitHub-flavored Markdown |

### Supporting

No supporting tools needed. This is a documentation-only phase.

## Architecture Patterns

### Complete Color Value Audit

**What:** A systematic extraction of every hardcoded color value from every theme config file, mapped to its colors.toml source key.

**Audit results (verified from codebase):**

The colors.toml palette has 24 keys:

| Key | Value | Category |
|-----|-------|----------|
| accent | #7B6CBD | Theme identity |
| cursor | #E8E0D0 | Terminal |
| foreground | #E8E0D0 | Text |
| background | #000000 | AMOLED base |
| selection_foreground | #E8E0D0 | Selection |
| selection_background | #7B6CBD | Selection |
| color0 | #111118 | ANSI black (dark surface) |
| color1 | #C45B6E | ANSI red |
| color2 | #6EA88E | ANSI green |
| color3 | #C49B5A | ANSI yellow |
| color4 | #6E8EC4 | ANSI blue |
| color5 | #9B7BC8 | ANSI magenta |
| color6 | #5AA8B5 | ANSI cyan |
| color7 | #8A8598 | ANSI white (muted) |
| color8 | #2A2835 | ANSI bright black (dark border) |
| color9 | #D47585 | ANSI bright red |
| color10 | #85C4A5 | ANSI bright green |
| color11 | #D4B572 | ANSI bright yellow |
| color12 | #85A5D4 | ANSI bright blue |
| color13 | #B595DA | ANSI bright magenta |
| color14 | #72C4CE | ANSI bright cyan |
| color15 | #E8E0D0 | ANSI bright white |

**Per-file hex occurrence counts:**

| File | Color Values | Already Annotated | Needs Annotation |
|------|-------------|-------------------|------------------|
| btop.theme | 33 hex values | 0 | 33 |
| vscode.json | 30 hex values | 0 (has `_comment` but not per-value) | 30 |
| waybar.css | 9 hex values | 7 (via `/* colors.toml: X */`) | 2 (tooltip section) |
| hyprlock.conf | 5 rgba + 2 inline rgba | 0 | 7 |
| hyprland.conf | 1 rgb() + 1 rgba() | 0 (has requirement tags like FX-02) | 2 |
| mako.ini | 5 hex values | 0 | 5 |
| walker.css | 6 hex values | 6 (via `/* colors.toml: X */`) | 0 (complete) |
| swayosd.css | 5 hex values | 5 (via `/* colors.toml: X */`) | 0 (complete) |
| neovim.lua | 4 hex values | 0 | 4 |
| chromium.theme | 1 RGB triplet | 0 | 1 |

**Totals:** ~120 color value occurrences. 18 already annotated, ~102 need annotation.

### Unmapped Color Values

Four color values in the codebase do NOT directly map to any colors.toml key:

| Value | File | Analysis | Recommendation |
|-------|------|----------|----------------|
| `#0a0a12` | neovim.lua (bg_float, bg_sidebar) | Intentional. A near-black dark surface for Neovim floating windows and sidebars. Slightly warmer than `#111118` (color0) to match tokyonight-night's native aesthetic. Not in colors.toml. | Flag as UNMAPPED -- intentional. Propose no new key; this is a neovim-specific design choice that should remain distinct from the palette. |
| `#7B6CBD40` | vscode.json (selection.background) | Derived from accent `#7B6CBD` with 25% alpha appended. This is a transparency-modified accent, not a new color. | Flag as DERIVED from accent -- annotate as `accent + 40 alpha`. |
| `#7B6CBD30` | vscode.json (list.activeSelectionBackground) | Derived from accent `#7B6CBD` with 19% alpha appended. Same pattern as above. | Flag as DERIVED from accent -- annotate as `accent + 30 alpha`. |
| `#000000FF` | mako.ini (background-color) | This is `#000000` (background) with explicit full alpha. Mako requires `#RRGGBBAA` format for background-color. Same color value, different format requirement. | Annotate as `background` (with format note). |

Additionally, `rgba(0,0,0,0.45)` in hyprlock.conf is a 45% opacity black overlay -- the base color maps to `background` but the alpha is a design choice for wallpaper dimming, not a palette value.

And `rgba(00000088)` in hyprland.conf shadow color is a semi-transparent black -- intentional for shadow rendering, not a palette color.

**Recommendation:** Do NOT propose new colors.toml keys. All unmapped values are either intentional design choices (neovim dark surfaces), derived values (accent + alpha), or format variants (hex + alpha suffix). Adding keys would bloat the palette without improving traceability.

### File Classification Model

**Recommendation: Binary classification (two tiers)**

After analyzing all files, every config file in this repo falls into one of two categories:

| Classification | Description | Files |
|----------------|-------------|-------|
| **Static override** | Hardcoded hex values; must be manually updated when accent/palette changes | hyprland.conf, hyprlock.conf, mako.ini, waybar.css, walker.css, swayosd.css, btop.theme, vscode.json, neovim.lua, chromium.theme |
| **Source of truth** | Defines the palette; read by Omarchy's template engine | colors.toml |

A three-tier model (adding "Omarchy-generated") is not applicable because this repo contains zero Omarchy-generated files. The template engine generates configs for components where the theme does NOT ship a static override -- those generated files live in `~/.config/omarchy/current/theme/` at runtime but are never committed to the theme repo. Every file in this repo is either the palette definition or a static override that replaces template output.

However, the classification is still valuable because it tells maintainers: "When you change the accent color in colors.toml, you must ALSO update all 10 static override files." This is the core message the reference document needs to convey.

**Maintenance impact per file when accent color changes:**

| File | Values Affected | Difficulty |
|------|----------------|------------|
| waybar.css | 2 accent values in CSS rules | Low |
| walker.css | 2 accent values in @define-color | Low |
| swayosd.css | 1 accent value in @define-color | Low |
| mako.ini | 1 accent border-color | Low |
| hyprland.conf | 1 rgb() border color | Low |
| hyprlock.conf | 4 rgba() values (outer_color, check_color, clock color, overlay might change) | Medium |
| btop.theme | 7 accent values (hi_fg, selected_fg, proc_misc, box outlines, temp_mid) | Medium |
| vscode.json | 5 accent values (activeBorderTop, focusBorder, selection.background, list.activeSelection) | Medium |
| neovim.lua | 0 accent values (only background overrides) | None |
| chromium.theme | 0 accent values (only background RGB) | None |

### Inline Comment Format Recommendations

**Per file type:**

| File Type | Comment Syntax | Annotation Format | Example |
|-----------|---------------|-------------------|---------|
| CSS (.css) | `/* */` | `/* colors.toml: keyname */` | Already established in waybar/walker/swayosd |
| Hyprland conf (.conf) | `#` | `# colors.toml: keyname` | `$activeBorderColor = rgb(7B6CBD)  # colors.toml: accent` |
| INI (.ini) | `#` | `# colors.toml: keyname` | `border-color=#7B6CBD  # colors.toml: accent` |
| btop theme (.theme) | `#` | `# colors.toml: keyname` | `theme[hi_fg]="#7B6CBD"  # colors.toml: accent` |
| Lua (.lua) | `--` | `-- colors.toml: keyname` | `colors.bg = "#000000"  -- colors.toml: background` |
| JSON (.json) | None (use `_comment` keys) | `"_comment_FIELD": "colors.toml: keyname"` | See JSON annotation pattern below |
| RGB triplet (.theme) | `#` (file is single-line, add above) | `# colors.toml: keyname` | `# colors.toml: background (RGB decimal format)` then `0,0,0` |

**Annotation syntax: `colors.toml: keyname`**

This format is already established in the three CSS files from Phase 2. Extending it consistently across all file types creates a greppable, uniform pattern. For derived/modified values, use: `colors.toml: keyname + modifier` (e.g., `colors.toml: accent + 40 alpha`). For unmapped values, use: `UNMAPPED -- reason`.

### JSON Annotation Pattern (vscode.json)

JSON does not support inline comments. The established pattern from Phase 2 uses a top-level `_comment` field. For per-value traceability, there are two options:

**Option A: Section-level `_comment` keys (recommended)**

Group annotations by semantic role rather than annotating every single key:

```json
{
  "_comment": "...",
  "_colors": "background=#000000 (colors.toml: background), foreground=#E8E0D0 (colors.toml: foreground), accent=#7B6CBD (colors.toml: accent), dark-surface=#111118 (colors.toml: color0), dark-border=#2A2835 (colors.toml: color8), muted=#8A8598 (colors.toml: color7), selection=#7B6CBD40 (colors.toml: accent + 40 alpha), list-selection=#7B6CBD30 (colors.toml: accent + 30 alpha)",
  "colorCustomizations": { ... }
}
```

**Option B: Per-group `_comment` inside colorCustomizations**

```json
{
  "colorCustomizations": {
    "[Tokyo Night]": {
      "_comment_backgrounds": "All #000000 values = colors.toml: background",
      "_comment_foregrounds": "All #E8E0D0 values = colors.toml: foreground",
      "_comment_accent": "#7B6CBD = colors.toml: accent; #7B6CBD40 = accent + 40 alpha; #7B6CBD30 = accent + 30 alpha",
      "_comment_surfaces": "#111118 = colors.toml: color0 (dark surface); #2A2835 = colors.toml: color8 (dark border); #8A8598 = colors.toml: color7 (muted text)",
      "editor.background": "#000000",
      ...
    }
  }
}
```

**Recommendation:** Option B. It places the annotations closest to the values they describe, inside the `[Tokyo Night]` scope where the color values live. It groups by semantic role (backgrounds, foregrounds, accent, surfaces) which matches how a maintainer would think about updating them. The `_comment_*` prefix pattern is valid JSON and self-documenting.

### Header Comment Format

Each config file should have a classification line in its header comment. The existing headers from Phase 2 already say "Static override -- replaces template-generated X". The annotation needed:

**Standard header addition:**

```
# Update: Manual -- when accent/palette changes, update hardcoded values below
```

or for files unaffected by accent changes:

```
# Update: Manual -- when background color changes (accent changes do not affect this file)
```

This should be added near the existing header, not replacing it. The exact wording adapts per file.

### Reference Document Organization (COLORS.md)

**Recommendation: Hybrid structure (practical guide first, detailed audit second)**

```
COLORS.md structure:

1. Quick Reference: "What to update when changing accent color"
   - Table listing each file, whether accent change affects it, and what to search/replace
   - This is the PRIMARY use case for this document

2. File Classification Table
   - Each file, its classification (static override / source of truth), and brief description

3. colors.toml Palette Reference
   - All 24 keys with hex values, organized by category (base, accent, ANSI 0-7, ANSI 8-15)

4. Per-File Color Audit
   - For each config file: list of every color value, its colors.toml mapping, and any notes
   - Unmapped values flagged clearly

5. Unmapped Values Summary
   - Consolidated list of values not in colors.toml, with rationale for each
```

This structure serves two audiences: maintainers who need the quick reference (section 1-2) and auditors/contributors who need the detailed mapping (sections 3-5).

### Annotation Scope Decision: What Formats to Annotate

**Recommendation: Annotate ALL color value formats, not just hex.**

The codebase uses four color formats:
1. `#RRGGBB` hex (most files)
2. `#RRGGBBAA` hex with alpha (mako.ini)
3. `rgba(R,G,B,A)` decimal (hyprlock.conf)
4. `rgb(RRGGBB)` hex without `#` (hyprland.conf)
5. `R,G,B` decimal triplet (chromium.theme)

All five formats encode the same palette colors. Annotating only hex would miss 8 values in hyprlock.conf and hyprland.conf. Annotating all formats ensures complete traceability.

### btop.theme Annotation Strategy

btop.theme is the most annotation-dense file (33 color values). Rather than putting the same `# colors.toml: accent` on 7 consecutive lines that all use `#7B6CBD`, use section comments:

```
# CPU, Memory, Network, Proc box outline colors
# All use accent color: colors.toml: accent
theme[cpu_box]="#7B6CBD"
theme[mem_box]="#7B6CBD"
theme[net_box]="#7B6CBD"
theme[proc_box]="#7B6CBD"
```

For gradient sequences, annotate each individually since they use different colors:

```
# CPU graph colors (cyan -> blue -> magenta)
theme[cpu_start]="#5AA8B5"  # colors.toml: color6 (cyan)
theme[cpu_mid]="#6E8EC4"    # colors.toml: color4 (blue)
theme[cpu_end]="#9B7BC8"    # colors.toml: color5 (magenta)
```

This balances completeness with readability -- grouping identical values and annotating distinct ones individually.

### Existing Annotation Coverage

Three files already have inline annotations from Phase 2:

**waybar.css** -- 7 of 9 values annotated. Missing annotations on lines 47-48 (tooltip section):
```css
tooltip {
  background-color: #000000;  /* missing: colors.toml: background */
  color: #E8E0D0;             /* missing: colors.toml: foreground */
}
```

**walker.css** -- 6 of 6 values annotated. COMPLETE. No changes needed to inline annotations.

**swayosd.css** -- 5 of 5 values annotated. COMPLETE. No changes needed to inline annotations.

These files still need the header classification line added.

### Anti-Patterns to Avoid

- **Over-annotating colors.toml itself:** colors.toml IS the source of truth. Adding `# colors.toml: accent` next to `accent = "#7B6CBD"` is circular and pointless. colors.toml gets a header comment explaining it is the source of truth, but individual values are not self-annotated.

- **Annotating CSS variable references:** Lines like `color: @theme-yellow;` in waybar.css use a CSS variable, not a hardcoded hex value. These do NOT need annotation because the variable definition (where the hex lives) is already annotated. Only annotate where hex values are hardcoded.

- **Creating a parallel data structure:** The annotation system should be comments in existing files, not a separate mapping file that could drift out of sync. COLORS.md is a reference document derived from the inline annotations, not a canonical source.

- **Breaking JSON validity:** vscode.json must remain valid JSON after annotations. All `_comment` fields must be proper JSON strings. No trailing commas, no `//` comments (which are not valid JSON despite VS Code accepting them).

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Color extraction | Custom script to parse all formats | Manual audit (already done in research) | Only ~120 values across 10 files; one-time audit is faster than building tooling |
| Annotation validation | Linter to verify annotations match values | Visual review during implementation | Comment correctness is trivially verifiable inline |
| Reference doc generation | Script that generates COLORS.md from annotations | Hand-written COLORS.md | The document needs narrative context (why unmapped, maintenance difficulty) that scripts cannot generate |

**Key insight:** This phase is a one-time documentation task, not an ongoing automated process. The number of files (10) and values (~120) is small enough that manual annotation is faster and more accurate than building tooling. The tooling investment becomes worthwhile only in Phase 4+ when the accent variant CLI needs to programmatically update values.

## Common Pitfalls

### Pitfall 1: Accidentally Modifying Color Values While Annotating

**What goes wrong:** While adding inline comments, a hex value is accidentally modified (e.g., copy-paste error changes `#7B6CBD` to `#7B6CB`).
**Why it happens:** The annotation task involves editing lines that contain color values. A slip in cursor position can change the value itself.
**How to avoid:** After annotating each file, verify that NO color values changed. Run `git diff` for each file and confirm only comments/whitespace were added. The diff should show only `+` lines (new comments) and modified lines where only the comment portion changed.
**Warning signs:** `git diff` shows hex value changes alongside comment additions.

### Pitfall 2: Invalid JSON After Adding _comment Keys

**What goes wrong:** Adding `_comment_*` keys to vscode.json breaks JSON parsing.
**Why it happens:** Missing commas, trailing commas, or misplaced keys in JSON structure.
**How to avoid:** Validate JSON after editing. Use `python3 -m json.tool vscode.json` or `jq . vscode.json` to verify validity. Ensure `_comment_*` keys do not conflict with keys that Omarchy scripts read (`name`, `extension`).
**Warning signs:** `jq` reports parse errors.

### Pitfall 3: Mako INI Comment Syntax Interference

**What goes wrong:** Inline comments on the same line as INI directives are not parsed correctly by mako.
**Why it happens:** Some INI parsers treat `#` as start of comment only at the beginning of a line, not inline. If mako's parser includes `#` in the value when it appears after text on the same line, the color value would be wrong (e.g., `border-color=#7B6CBD  # colors.toml: accent` might be parsed as value `#7B6CBD  # colors.toml: accent`).
**How to avoid:** Verify mako INI parsing behavior. The `man 5 mako` documentation should clarify. If inline comments are not supported, place annotations on the line above the directive instead:
```ini
# colors.toml: accent
border-color=#7B6CBD
```
**Warning signs:** mako displays wrong colors or fails to start after annotation.

### Pitfall 4: Chromium.theme Format Sensitivity

**What goes wrong:** Adding a comment to `chromium.theme` breaks `omarchy-theme-set-browser` parsing.
**Why it happens:** The Omarchy script reads chromium.theme with `$(<$CHROMIUM_THEME)` which captures the entire file content as a string. If the file contains anything besides the RGB triplet (including comments or newlines after the triplet), the `printf` conversion fails.
**How to avoid:** Do NOT add inline comments to chromium.theme on the same line as the RGB value. Instead, add comments ABOVE the RGB line. Verify that the file ends with the RGB triplet (or a newline after it) and nothing else on that line. The `$(<file)` Bash construct strips trailing newlines, so a comment on a separate line above should be safe -- but test: `echo "$(cat chromium.theme)"` should output exactly `0,0,0`.
**Alternative:** If adding any comment to chromium.theme risks breaking parsing, annotate ONLY in COLORS.md and note in the file header that the format is restrictive.
**Warning signs:** `omarchy-theme-set-browser` errors or Chromium shows wrong color.

### Pitfall 5: Hyprland Conf Inline Comment Position

**What goes wrong:** Hyprland config comments (`#`) must be preceded by whitespace when on the same line as a directive.
**Why it happens:** Hyprland's config parser has specific comment handling rules.
**How to avoid:** Always use two or more spaces before `#` when adding inline comments to hyprland.conf:
```
$activeBorderColor = rgb(7B6CBD)  # colors.toml: accent
```
The existing file already uses this pattern for section comments, so follow the same style.

## Code Examples

### btop.theme Annotation Pattern (Hash Comments)

```
# Clawmarchy btop theme
# Static override -- must be manually updated when accent/palette changes
# Cool-to-warm gradient: cyan/blue at low usage -> purple/magenta at high usage
# True black background blends with terminal

# Main background, empty for terminal default
theme[main_bg]="#000000"  # colors.toml: background

# Main text color
theme[main_fg]="#E8E0D0"  # colors.toml: foreground

...

# CPU graph colors (cyan -> blue -> magenta) -- CORE GRADIENT
theme[cpu_start]="#5AA8B5"  # colors.toml: color6
theme[cpu_mid]="#6E8EC4"    # colors.toml: color4
theme[cpu_end]="#9B7BC8"    # colors.toml: color5
```

### hyprlock.conf Annotation Pattern (Hash Comments with RGBA)

```
# Clawmarchy AMOLED Dark Theme - Hyprlock Lock Screen
# Static override -- must be manually updated when accent/palette changes
# Sourced at top of Omarchy's structural hyprlock.conf via source = directive

# Color variables used by Omarchy's structural hyprlock.conf
$color = rgba(0,0,0, 1.0)              # colors.toml: background (full opacity)
$inner_color = rgba(0,0,0, 0.8)        # colors.toml: background (80% opacity)
$outer_color = rgba(123,108,189, 1.0)  # colors.toml: accent (rgba decimal)
$font_color = rgba(232,224,208, 1.0)   # colors.toml: foreground (rgba decimal)
$check_color = rgba(123,108,189, 1.0)  # colors.toml: accent (rgba decimal)
```

### mako.ini Annotation Pattern (Line-Above if Inline Not Supported)

```ini
# Clawmarchy AMOLED Dark Theme - Mako Notifications
# Static override -- must be manually updated when accent/palette changes

include=~/.local/share/omarchy/default/mako/core.ini

# Global defaults -- AMOLED black background, accent border (normal urgency)
text-color=#E8E0D0
# ^ colors.toml: foreground
border-color=#7B6CBD
# ^ colors.toml: accent
background-color=#000000FF
# ^ colors.toml: background (with FF alpha suffix for mako)
```

OR if mako supports inline comments:

```ini
text-color=#E8E0D0  # colors.toml: foreground
border-color=#7B6CBD  # colors.toml: accent
background-color=#000000FF  # colors.toml: background (with FF alpha)
```

**Verification needed:** Test whether mako supports inline `#` comments or only line-start comments. This determines the annotation style for mako.ini.

### vscode.json Annotation Pattern (_comment Keys)

```json
{
  "name": "Tokyo Night",
  "extension": "enkia.tokyo-night",
  "_comment": "colorCustomizations are NOT auto-applied by Omarchy...",
  "colorCustomizations": {
    "[Tokyo Night]": {
      "_comment_backgrounds": "All #000000 values = colors.toml: background",
      "_comment_foregrounds": "All #E8E0D0 values = colors.toml: foreground",
      "_comment_accent": "#7B6CBD = colors.toml: accent; #7B6CBD40 = accent + 25% alpha; #7B6CBD30 = accent + 19% alpha",
      "_comment_surfaces": "#111118 = colors.toml: color0 (dark surface); #2A2835 = colors.toml: color8 (dark border); #8A8598 = colors.toml: color7 (muted text)",
      "editor.background": "#000000",
      ...
    }
  }
}
```

### neovim.lua Annotation Pattern (Lua Comments)

```lua
return {
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        opts = {
            style = "night",
            on_colors = function(colors)
                colors.bg = "#000000"          -- colors.toml: background
                colors.bg_dark = "#000000"     -- colors.toml: background
                colors.bg_float = "#0a0a12"    -- UNMAPPED: tokyonight-specific dark surface
                colors.bg_sidebar = "#0a0a12"  -- UNMAPPED: tokyonight-specific dark surface
            end,
        },
    },
    ...
}
```

### COLORS.md Quick Reference Section

```markdown
## Quick Reference: What to Update When Changing Accent Color

When changing the accent color from `#7B6CBD` to a new value:

| File | Affected? | Values to Update | Search For |
|------|-----------|-----------------|------------|
| colors.toml | YES | accent, selection_background | `#7B6CBD` |
| waybar.css | YES | 2 inline accent values | `#7B6CBD` |
| walker.css | YES | 2 @define-color accent values | `#7B6CBD` |
| swayosd.css | YES | 1 @define-color accent value | `#7B6CBD` |
| mako.ini | YES | 1 border-color | `#7B6CBD` |
| hyprland.conf | YES | 1 rgb() border color | `rgb(7B6CBD)` |
| hyprlock.conf | YES | 3 rgba() accent values | `rgba(123,108,189` |
| btop.theme | YES | 7 accent-role values | `#7B6CBD` |
| vscode.json | YES | 5 accent + derived values | `#7B6CBD` |
| neovim.lua | NO | Only background overrides | -- |
| chromium.theme | NO | Only background RGB | -- |
```

## State of the Art

| Before Phase 3 | After Phase 3 | Impact |
|----------------|---------------|--------|
| 3 CSS files have partial annotations | All 10 files have complete annotations | Every color value traceable to palette source |
| No file classification | Every file has header classification | Maintainers know what needs manual update |
| No reference document | COLORS.md at repo root | Single-page guide for accent changes |
| 4 unmapped values undiscovered | All unmapped values flagged and rationalized | Future audits start from known baseline |

## Open Questions

1. **Mako inline comment support**
   - What we know: Mako uses INI-style config. Standard INI supports `#` and `;` as line-start comments. Inline comment support varies by parser.
   - What's unclear: Whether mako's parser treats `#` after a value as a comment or as part of the value string.
   - Recommendation: Test at implementation time. Try `border-color=#7B6CBD  # test` and verify mako parses the color correctly. If inline comments work, use them. If not, use line-above annotation (`# ^ colors.toml: accent` on the line below the value, or comment on the line above).

2. **Chromium.theme comment safety**
   - What we know: `omarchy-theme-set-browser` reads the file with `$(<$CHROMIUM_THEME)` and feeds it to `printf`. The file currently contains exactly `0,0,0`.
   - What's unclear: Whether a `#` comment line above the RGB triplet would cause the script to fail (it would include the comment line in `THEME_RGB_COLOR`).
   - Recommendation: Test at implementation time. If unsafe, annotate chromium.theme ONLY in COLORS.md and add a single-line note to the file itself that it cannot contain comments due to format constraints. Alternatively, if the Bash `$(<file)` reads the entire file including comment lines, the safest approach is no comments in the file at all.

3. **btop.theme inline comment support**
   - What we know: btop.theme uses `theme[key]="value"` format with `#` comments on their own lines (existing file has this pattern).
   - What's unclear: Whether btop supports `#` comments after a value on the same line.
   - Recommendation: The existing btop.theme already has comment-only lines (e.g., `# Main background...`). Inline comments after values should work (btop's theme format is documented as supporting `#` for comments). Verify during implementation.

## Sources

### Primary (HIGH confidence)

- **Codebase inspection** -- All 10 theme config files read and every color value extracted. Mapping to colors.toml keys verified by exact hex value comparison.
- **Phase 2 research (02-RESEARCH.md)** -- Omarchy theme override mechanism, template engine behavior, and `omarchy-theme-set-browser` script behavior (reads `$(<$CHROMIUM_THEME)`) verified from source code.
- **Phase 2 implementation (02-01 through 02-03 SUMMARY.md)** -- Confirmed which files already have annotations and what patterns were established (CSS `/* colors.toml: X */` format, JSON `_comment` field pattern).
- **Existing annotation pattern** -- waybar.css, walker.css, swayosd.css already use `/* colors.toml: keyname */` inline comments -- this is the established convention to extend.
- **colors.toml** -- Direct inspection of all 24 palette keys and values.

### Secondary (MEDIUM confidence)

- **Mako man page (man 5 mako)** -- Confirms INI config format and `#RRGGBBAA` color format. Inline comment support needs runtime verification.
- **btop theme format** -- Based on observed file patterns and btop documentation. Inline comment support needs runtime verification.

### Tertiary (LOW confidence)

- **chromium.theme comment safety** -- Untested assumption that `$(<file)` reading a multi-line file with comments would break the RGB parsing. Needs runtime verification.

## Metadata

**Confidence breakdown:**
- Color audit completeness: HIGH -- every color value in every file extracted and mapped via direct codebase inspection
- Annotation format recommendations: HIGH -- extends established pattern from Phase 2 CSS files; JSON `_comment` pattern from Phase 2 vscode.json
- File classification: HIGH -- binary model directly observed from codebase (all files are static overrides)
- Comment syntax per file type: MEDIUM -- most are standard (CSS, Lua, hash-comment); mako inline and chromium.theme restrictions need runtime verification
- Reference document structure: HIGH -- organization driven by practical use case (accent color changes) per locked decision

**Research date:** 2026-02-18
**Valid until:** 2026-03-18 (30 days -- documentation patterns are stable; no external dependency changes expected)
