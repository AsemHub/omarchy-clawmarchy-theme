# Phase 4: Accent Variants and Wallpapers - Research

**Researched:** 2026-02-19
**Domain:** Color system variant packaging, WCAG contrast verification, AI wallpaper generation
**Confidence:** HIGH

## Summary

Phase 4 ships 5-6 accent color variants (including the default purple) alongside an expanded wallpaper collection of 10+ images. The core technical challenge is well-bounded: since Phase 3 established complete color traceability, we know exactly which 23 accent-dependent values across 9 files must change per variant, and which files (neovim.lua, chromium.theme) are accent-independent and can be shared.

The accent-swap-only constraint (locked decision: ANSI palette stays constant, only accent changes) dramatically simplifies the work. Each variant is a set of 9 config files with accent hex values swapped, plus a paired wallpaper. WCAG 4.5:1 contrast against `#000000` is trivially achievable for any color with sufficient lightness -- all 6 candidate accents pass with significant margin (range: 4.72:1 to 8.71:1).

The wallpaper requirement (10 total, AI-generated via Gemini Pro) is fulfilled by adding 5 new variant-paired wallpapers to the existing 5. Gemini Pro supports 16:9 aspect ratio at 4K resolution natively, making the dual-resolution requirement (4K + QHD) achievable through generation at 4K and downscale to QHD.

**Primary recommendation:** Ship each variant as a self-contained subdirectory under `variants/` containing all 9 accent-dependent config files. Keep the default purple in the repo root (Omarchy reads from root). Provide a `clawmarchy-variant` shell script that copies variant files to root and runs `omarchy-theme-set`. Keep btop core gradients fixed on ANSI palette colors; only accent-role values (box outlines, highlights, temp_mid) change per variant.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

#### Accent color selection
- 5-6 total variants including the default purple (4-5 new accents)
- Claude selects specific hex values that pass WCAG 4.5:1 contrast against #000000
- Claude balances muted and vibrant tones across the set for range
- Each variant gets an evocative name (e.g., Sakura, Ocean, Ember) fitting the anime/aesthetic vibe

#### Wallpaper collection
- All wallpapers are AI-generated (no sourced/licensed art)
- User generates wallpapers using Gemini Pro with prompts/specs provided in the plan
- Anime/manga aesthetic only -- consistent with current collection
- One wallpaper per variant, color-matched to the variant's accent tones
- Ship at both 3840x2160 (4K) and 2560x1440 (QHD) resolutions

### Claude's Discretion

#### Variant packaging
- File structure (subdirectories vs flat)
- Whether default purple stays in root or moves to variant directory
- Whether variants include full file copies or only changed files
- Switching mechanism (manual copy vs script)

#### btop gradient mapping
- Whether core gradients (cpu, mem, network, process) adapt per variant or stay fixed on palette colors
- Whether temp_mid uses the new accent or stays semantic
- Whether box outlines always match accent or use a variant-specific contrasting shade

### Deferred Ideas (OUT OF SCOPE)
- **AI wallpaper generation CLI integration** -- deferred
- **Music generation integration** -- deferred
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| VAR-01 | At least 3 pre-built accent color variants ship alongside the default purple | 5 new variants selected (Sakura, Ocean, Tide, Ember, Moss) for 6 total including default; hex values verified, hue distribution analyzed |
| VAR-02 | Each variant includes modified colors.toml with different accent and selection_background values | Full accent format mapping computed per variant (hex, strip, RGB decimal, alpha-derived); 2 values change in colors.toml |
| VAR-03 | Each variant includes re-crafted btop.theme gradient mapping for the new accent hue | btop gradient analysis complete: 7 accent-role values change, core gradients stay fixed on ANSI palette; temp_mid recommendation provided |
| VAR-04 | Each variant's accent color passes WCAG 4.5:1 contrast ratio against #000000 | All 6 variants verified with computed contrast ratios ranging from 4.72:1 (Yoru) to 8.71:1 (Tide) |
| VAR-05 | Variant installation is documented with clear instructions | Switching mechanism researched: shell script approach recommended; Omarchy theme-set integration verified |
| ASST-01 | Wallpaper collection expanded to at least 10 curated anime wallpapers | 5 existing + 5 new variant-paired wallpapers = 10 total; Gemini Pro capabilities verified for 16:9 4K generation |
| ASST-02 | New wallpapers are dark atmospheric scenes that work aesthetically with any accent color variant | Wallpaper generation prompts designed for dark atmospheric scenes with accent-complementary (not accent-saturated) tones |
</phase_requirements>

## Standard Stack

### Core

This phase uses no external libraries. All work is configuration file creation and image generation.

| Tool | Version | Purpose | Why Standard |
|------|---------|---------|--------------|
| Gemini Pro (Nano Banana) | 3 Pro Image | AI wallpaper generation at 4K/16:9 | User's existing subscription; supports required resolution and aspect ratio |
| WCAG 2.1 AA | -- | Contrast ratio standard (4.5:1 minimum) | Industry standard for text contrast accessibility |
| Python 3 (local) | System | Contrast ratio computation and verification | Available on system for mathematical verification |

### Supporting

| Tool | Purpose | When to Use |
|------|---------|-------------|
| `omarchy-theme-set` | Apply theme after variant switch | After copying variant files to root |
| `grep -rn` | Verify accent hex propagation | After creating variant files, confirm all values updated |
| ImageMagick (`convert`) | Downscale 4K wallpapers to QHD | If Gemini cannot generate QHD directly |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Gemini Pro image gen | Stable Diffusion / DALL-E | Gemini is user's existing tool; no additional cost or setup |
| Python contrast calc | Online WCAG checker | Python allows batch verification of all variants programmatically |
| Shell script switcher | Full CLI tool (clawmarchy-accent) | CLI tool is v2 scope; shell script is minimal and sufficient for v1 |

## Architecture Patterns

### Recommended Project Structure

```
omarchy-clawmarchy-theme/
├── colors.toml              # Default variant (Yoru/purple) -- Omarchy reads from root
├── btop.theme               # Default btop theme
├── hyprland.conf            # Default hyprland config
├── hyprlock.conf            # Default hyprlock config
├── mako.ini                 # Default mako config
├── waybar.css               # Default waybar styles
├── walker.css               # Default walker styles
├── swayosd.css              # Default swayosd styles
├── vscode.json              # Default vscode overrides
├── neovim.lua               # Accent-independent (shared)
├── chromium.theme            # Accent-independent (shared)
├── icons.theme              # Accent-independent (shared)
├── backgrounds/             # All wallpapers (all variants)
│   ├── 1-cyberpunk-neon-city.png       # Existing
│   ├── 2-dark-atmospheric-shrine.png   # Existing
│   ├── 3-character-silhouette.png      # Existing
│   ├── 4-neon-rain-street.png          # Existing
│   ├── 5-moonlit-landscape.png         # Existing
│   ├── 6-sakura-cherry-blossoms.png    # New (Sakura variant)
│   ├── 7-ocean-deep-harbor.png         # New (Ocean variant)
│   ├── 8-tide-coral-reef.png           # New (Tide variant)
│   ├── 9-ember-lantern-festival.png    # New (Ember variant)
│   └── 10-moss-forest-shrine.png       # New (Moss variant)
├── variants/
│   ├── sakura/              # Pink accent variant
│   │   ├── colors.toml
│   │   ├── btop.theme
│   │   ├── hyprland.conf
│   │   ├── hyprlock.conf
│   │   ├── mako.ini
│   │   ├── waybar.css
│   │   ├── walker.css
│   │   ├── swayosd.css
│   │   └── vscode.json
│   ├── ocean/               # Blue accent variant
│   │   └── ... (same 9 files)
│   ├── tide/                # Teal accent variant
│   │   └── ...
│   ├── ember/               # Orange accent variant
│   │   └── ...
│   └── moss/                # Green accent variant
│       └── ...
├── clawmarchy-variant       # Variant switching script
├── COLORS.md
└── README.md
```

### Pattern 1: Full-Copy Variant Directories

**What:** Each variant directory contains complete copies of all 9 accent-dependent config files, with accent values replaced throughout.

**When to use:** Always for this project, because all themed config files are static overrides with hardcoded hex values. There is no mechanism to "inherit" unchanged values from a parent -- every file must be complete and self-contained.

**Why not delta/patch approach:** Omarchy's theme system copies files wholesale from the theme directory. It does not merge or patch. A variant directory with only a `colors.toml` would leave the root's btop.theme, waybar.css, etc. with the old accent values in the static overrides. Template-generated configs would pick up the new accent from colors.toml, but the 9 static override files would not.

**File count per variant:** 9 files (colors.toml, btop.theme, hyprland.conf, hyprlock.conf, mako.ini, waybar.css, walker.css, swayosd.css, vscode.json).

### Pattern 2: Accent-Only Substitution

**What:** When creating variant files, only accent-role values change. Everything else (background, foreground, ANSI palette, gradients, animations, blur settings) remains identical to the default.

**When to use:** For every file in every variant. This is the definition of "accent swap variant" (locked decision).

**Values that change per file:**

| File | Values Changed | Count |
|------|---------------|-------|
| colors.toml | `accent`, `selection_background` | 2 |
| btop.theme | `hi_fg`, `selected_fg`, `proc_misc`, `cpu_box`, `mem_box`, `net_box`, `proc_box`, `temp_mid` | 8 |
| hyprland.conf | `$activeBorderColor` rgb() value | 1 |
| hyprlock.conf | `$outer_color`, `$check_color`, clock label `color` | 3 |
| mako.ini | `border-color` (global) | 1 |
| waybar.css | `#workspaces button.active color`, module icons `color` | 2 |
| walker.css | `@define-color selected-text`, `@define-color border` | 2 |
| swayosd.css | `@define-color progress` | 1 |
| vscode.json | `tab.activeBorderTop`, `focusBorder`, `selection.background` (+40 alpha), `list.activeSelectionBackground` (+30 alpha) | 4 |
| **Total** | | **24** |

### Pattern 3: Variant Switching Script

**What:** A simple shell script (`clawmarchy-variant`) that copies variant files to root and triggers `omarchy-theme-set`.

**When to use:** When users want to switch accent variants.

**Example:**
```bash
#!/bin/bash
# clawmarchy-variant - Switch accent color variant
# Usage: clawmarchy-variant <name>
# Available: yoru (default), sakura, ocean, tide, ember, moss

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VARIANT="${1:-}"

# List available variants
if [ -z "$VARIANT" ] || [ "$VARIANT" = "--list" ]; then
    echo "Available variants:"
    echo "  yoru    - Muted blue-violet (default)"
    for dir in "$SCRIPT_DIR"/variants/*/; do
        name=$(basename "$dir")
        echo "  $name"
    done
    [ -z "$VARIANT" ] && echo "" && echo "Usage: clawmarchy-variant <name>"
    exit 0
fi

# Handle default
if [ "$VARIANT" = "yoru" ]; then
    echo "Yoru is the default variant (already in root files)."
    echo "Run: omarchy-theme-set clawmarchy"
    exit 0
fi

# Validate variant exists
VARIANT_DIR="$SCRIPT_DIR/variants/$VARIANT"
if [ ! -d "$VARIANT_DIR" ]; then
    echo "Error: Variant '$VARIANT' not found."
    echo "Run: clawmarchy-variant --list"
    exit 1
fi

# Copy variant files to root
cp "$VARIANT_DIR"/* "$SCRIPT_DIR/"
echo "Switched to variant: $VARIANT"
echo "Run: omarchy-theme-set clawmarchy"
```

### Anti-Patterns to Avoid

- **Delta/patch files:** Do not ship only the changed values per variant. Omarchy expects complete files. A partial colors.toml would break the template engine.
- **Moving default to variants/:** Do not move the default purple out of root. Omarchy reads from the theme root directory; moving root files would break `omarchy-theme-set`.
- **Accent-matching wallpapers that only work with one variant:** Wallpapers should be dark atmospheric scenes where the accent color is a subtle complementary tone, not the dominant color. A wallpaper saturated in pink would look wrong with the Ocean (blue) variant.
- **Changing ANSI palette per variant:** The 16-color palette (color0-color15) is locked constant. Only accent and selection_background change. This is a locked decision from CONTEXT.md.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| WCAG contrast ratio | Manual visual check | Python relative luminance calculation | Mathematical certainty vs subjective judgment; formula is 5 lines |
| Accent hex format conversion | Manual hex-to-decimal conversion | Python/bash computation | hyprlock needs decimal RGB; manual conversion is error-prone |
| Wallpaper downscale 4K to QHD | Manual resize in image editor | ImageMagick `convert -resize 2560x1440` | Batch-processable, consistent quality, scriptable |
| Config file generation per variant | Manual editing of 9 files x 5 variants = 45 files | sed/python substitution script | 45 files with accent replacement is mechanical and error-prone by hand |

**Key insight:** The variant file generation is the most automation-worthy task. A simple script that reads the default files, replaces the accent hex in all its formats (hex, strip, decimal RGB, alpha-appended), and writes the variant files eliminates the primary source of manual error.

## Common Pitfalls

### Pitfall 1: Incomplete Accent Format Replacement

**What goes wrong:** A variant file is created but one of the accent formats (hex `#7B6CBD`, strip `7B6CBD`, decimal `123,108,189`, alpha `#7B6CBD40`) is missed, leaving a purple accent value in a non-purple variant.

**Why it happens:** The accent color appears in 4 different formats across the config files:
- `#7B6CBD` -- hex with hash (most files)
- `7B6CBD` -- hex without hash (hyprland.conf `rgb()`)
- `123,108,189` -- decimal RGB (hyprlock.conf `rgba()`)
- `#7B6CBD40`, `#7B6CBD30` -- hex with alpha suffix (vscode.json)

**How to avoid:** After generating variant files, run `grep -rn '7B6CBD' variants/<name>/` AND `grep -rn '123,108,189' variants/<name>/` to verify zero leftover default accent values. The generation script must handle all 4 formats.

**Warning signs:** Purple border color appearing when using a non-purple variant; purple clock on hyprlock.

### Pitfall 2: btop Gradient Continuity Break

**What goes wrong:** If `temp_mid` is changed to the new accent but the accent hue doesn't sit between cyan (temp_start, hue 189) and red (temp_end, hue 349) on the color wheel, the temperature gradient has a visual discontinuity.

**Why it happens:** The temperature gradient is semantically meaningful: cool -> warm -> hot. The default purple (hue 251) sits naturally between cyan (189) and red (349) on the hue wheel. But some accents (e.g., Moss at hue 153, which is greener than cyan) would create a non-monotonic hue progression.

**How to avoid:** For variants where the accent hue does not sit between 189 (cyan) and 349 (red) on the color wheel, keep `temp_mid` at the default purple `#7B6CBD` or use a palette color that fits the gradient semantically. Only use the variant accent as `temp_mid` when it naturally fits the cool-to-warm progression.

**Warning signs:** Temperature gradient that looks like it "jumps" between two unrelated colors rather than smoothly transitioning.

### Pitfall 3: Wallpaper Too Accent-Saturated

**What goes wrong:** A variant wallpaper is so heavily colored in the accent tone that it looks wrong when the user switches to a different variant but keeps the wallpaper.

**Why it happens:** AI image generation tends to over-saturate requested color tones. A "pink cherry blossom scene" might come back as intensely pink, which clashes with the Ocean (blue) or Ember (orange) accent.

**How to avoid:** Wallpaper generation prompts should emphasize: dark atmospheric scene, predominantly black/dark tones, with subtle accent-complementary hues in specific elements (lanterns, foliage, water reflections). The accent color should be a supporting element, not the dominant color. Target 70-80% dark/black with 20-30% accent-tinted elements.

**Warning signs:** Wallpaper looks like a single-color wash rather than a dark atmospheric scene.

### Pitfall 4: Variant Script Path Assumptions

**What goes wrong:** The `clawmarchy-variant` script assumes it is run from the theme directory, but the theme is installed at `~/.config/omarchy/themes/clawmarchy/` and the script might be run from anywhere.

**Why it happens:** Using relative paths or `$PWD` instead of resolving the script's own location.

**How to avoid:** Use `SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"` to resolve the script's directory regardless of where it is called from. All file operations use `$SCRIPT_DIR` as the base.

**Warning signs:** "File not found" errors when running the script from home directory.

### Pitfall 5: Wallpaper Resolution Naming Confusion

**What goes wrong:** Two resolution versions of the same wallpaper create confusion about which to use, or Omarchy's wallpaper cycler picks up both resolutions as separate wallpapers.

**Why it happens:** Putting both 4K and QHD versions in the same `backgrounds/` directory means the cycler sees 20 wallpapers instead of 10.

**How to avoid:** Ship only 4K wallpapers in the main `backgrounds/` directory. QHD versions can live in a `backgrounds/qhd/` subdirectory that Omarchy's cycler does not scan (it only reads the immediate directory). Or, if Omarchy scans subdirectories, ship only 4K and let users downscale themselves (document this). Since the existing 5 wallpapers have no resolution indicator, maintaining a single-resolution approach in `backgrounds/` is simpler.

**Warning signs:** Wallpaper cycler showing "duplicate" wallpapers.

## Code Examples

### WCAG 4.5:1 Contrast Verification (Python)

```python
def relative_luminance(hex_color):
    """Calculate WCAG 2.1 relative luminance from hex color."""
    hex_color = hex_color.lstrip('#')
    r, g, b = int(hex_color[0:2], 16)/255.0, int(hex_color[2:4], 16)/255.0, int(hex_color[4:6], 16)/255.0
    def linearize(c):
        return c/12.92 if c <= 0.04045 else ((c + 0.055)/1.055)**2.4
    return 0.2126 * linearize(r) + 0.7152 * linearize(g) + 0.0722 * linearize(b)

def contrast_ratio(hex1, hex2):
    """Calculate WCAG contrast ratio between two hex colors."""
    l1 = relative_luminance(hex1)
    l2 = relative_luminance(hex2)
    lighter, darker = max(l1, l2), min(l1, l2)
    return (lighter + 0.05) / (darker + 0.05)

# Verify all variants
bg = '#000000'
variants = {
    'Yoru':   '#7B6CBD',  # 4.72:1
    'Sakura': '#D4839B',  # 7.52:1
    'Ocean':  '#5B8EC9',  # 6.16:1
    'Tide':   '#5AB5B5',  # 8.71:1
    'Ember':  '#D4895A',  # 7.53:1
    'Moss':   '#6EA88E',  # 7.65:1
}
for name, accent in variants.items():
    ratio = contrast_ratio(accent, bg)
    assert ratio >= 4.5, f"{name} fails WCAG: {ratio:.2f}:1"
```

### Accent Format Conversion (for variant file generation)

```python
def accent_formats(hex_color):
    """Return all format variants needed for config file generation."""
    stripped = hex_color.lstrip('#')
    r, g, b = int(stripped[0:2], 16), int(stripped[2:4], 16), int(stripped[4:6], 16)
    return {
        'hex':       hex_color,           # #D4839B  (most files)
        'strip':     stripped,             # D4839B   (hyprland.conf rgb())
        'rgb':       f'{r},{g},{b}',       # 212,131,155 (hyprlock.conf rgba())
        'hex_40':    f'#{stripped}40',     # #D4839B40 (vscode.json selection.background)
        'hex_30':    f'#{stripped}30',     # #D4839B30 (vscode.json list.activeSelectionBackground)
    }
```

### Variant File Generation (sed approach)

```bash
# Generate variant files by replacing accent in all formats
OLD_ACCENT="#7B6CBD"
OLD_STRIP="7B6CBD"
OLD_RGB="123,108,189"
NEW_ACCENT="#D4839B"
NEW_STRIP="D4839B"
NEW_RGB="212,131,155"

for file in colors.toml btop.theme hyprland.conf hyprlock.conf mako.ini \
            waybar.css walker.css swayosd.css vscode.json; do
    sed -e "s/$OLD_ACCENT/$NEW_ACCENT/g" \
        -e "s/$OLD_STRIP/$NEW_STRIP/g" \
        -e "s/$OLD_RGB/$NEW_RGB/g" \
        "$file" > "variants/sakura/$file"
done
```

### Gemini Pro Wallpaper Generation Prompt Template

```
Generate a dark atmospheric anime/manga illustration at 16:9 aspect ratio, 4K resolution.

Scene: [SCENE_DESCRIPTION]

Style requirements:
- Dark atmospheric anime art style, consistent with dark desktop wallpaper aesthetic
- Predominantly dark/black tones (70-80% of the image should be very dark)
- Subtle [ACCENT_COLOR_DESCRIPTION] tones in [SPECIFIC_ELEMENTS] as accent highlights
- No text, watermarks, or UI elements
- Cinematic composition with depth and atmosphere
- Detailed anime art quality, not photorealistic

Color guidance:
- Background: deep blacks and very dark grays
- Accent elements: muted [COLOR_FAMILY] tones (not oversaturated)
- The accent color should complement the scene, not dominate it
- The wallpaper should still look good with different colored UI overlays
```

## Accent Color Selection (Verified)

### Selected Variants

| Name | Hex | Hue | Contrast vs #000 | Tone | Vibe |
|------|-----|-----|-------------------|------|------|
| Yoru (default) | `#7B6CBD` | 251 | 4.72:1 | Muted | Night/purple -- existing default |
| Sakura | `#D4839B` | 342 | 7.52:1 | Muted | Cherry blossom pink |
| Ocean | `#5B8EC9` | 212 | 6.16:1 | Muted | Deep sea blue |
| Tide | `#5AB5B5` | 180 | 8.71:1 | Muted | Coastal teal |
| Ember | `#D4895A` | 23 | 7.53:1 | Vibrant | Lantern warm orange |
| Moss | `#6EA88E` | 153 | 7.65:1 | Muted | Forest green |

**Hue distribution:** 23 (Ember) -- 153 (Moss) -- 180 (Tide) -- 212 (Ocean) -- 251 (Yoru) -- 342 (Sakura). Six well-spaced hues covering the color wheel with no clustering.

**Contrast range:** All pass WCAG 4.5:1. Lowest is Yoru at 4.72:1 (the existing default, already verified in production). Highest is Tide at 8.71:1.

**Tone balance:** 5 muted, 1 vibrant (Ember). This matches the muted aesthetic of the existing palette. Ember provides warm contrast as the single vibrant option.

### Format Reference Per Variant

| Variant | Hex | Strip | Decimal RGB | +40 Alpha | +30 Alpha |
|---------|-----|-------|-------------|-----------|-----------|
| Yoru | `#7B6CBD` | `7B6CBD` | `123,108,189` | `#7B6CBD40` | `#7B6CBD30` |
| Sakura | `#D4839B` | `D4839B` | `212,131,155` | `#D4839B40` | `#D4839B30` |
| Ocean | `#5B8EC9` | `5B8EC9` | `91,142,201` | `#5B8EC940` | `#5B8EC930` |
| Tide | `#5AB5B5` | `5AB5B5` | `90,181,181` | `#5AB5B540` | `#5AB5B530` |
| Ember | `#D4895A` | `D4895A` | `212,137,90` | `#D4895A40` | `#D4895A30` |
| Moss | `#6EA88E` | `6EA88E` | `110,168,142` | `#6EA88E40` | `#6EA88E30` |

## Discretionary Recommendations

### File Structure: Subdirectories with Full File Copies

**Recommendation:** `variants/<name>/` subdirectories, each containing all 9 accent-dependent files.

**Rationale:**
- All 9 config files in this theme are static overrides with hardcoded hex values. There is no mechanism to inherit unchanged values from a parent config. Each file must be complete.
- A delta/patch approach is not viable because Omarchy copies files wholesale -- it does not merge configs.
- Full copies are mechanically generated via sed substitution, so the "duplication" has no maintenance cost (regenerate from defaults when needed).
- Subdirectories provide clear visual organization and allow the switching script to `cp variants/<name>/* .` cleanly.

### Default Purple Location: Stay in Root

**Recommendation:** Keep the default purple (Yoru) files in the repo root. Do not move them to `variants/yoru/`.

**Rationale:**
- Omarchy's `omarchy-theme-set` reads config files from the theme root directory (`~/.config/omarchy/themes/clawmarchy/`).
- Moving root files to a subdirectory would break theme installation for users who just run `omarchy-theme-install` without any variant switching.
- The default experience should work without any extra steps.
- The asymmetry (default in root, alternatives in variants/) is intentional and matches how Omarchy themes work.

### Switching Mechanism: Shell Script

**Recommendation:** Ship a `clawmarchy-variant` shell script in the theme root.

**Rationale:**
- Simpler and less error-prone than documenting manual `cp` commands
- Lists available variants with `--list`
- Validates variant name before copying
- Single clear command: `clawmarchy-variant sakura && omarchy-theme-set clawmarchy`
- Not a v2 CLI tool -- just a thin convenience script with no accent validation, backup, or dry-run features
- The script copies files and prints instructions; the user runs `omarchy-theme-set` separately (or the script can do it automatically)

### btop Core Gradients: Stay Fixed on Palette Colors

**Recommendation:** Keep cpu, mem, network, process, download, upload, free, cached, available gradients fixed on their current ANSI palette colors (color4, color5, color6, color12, color13, color14). Do not adapt them per variant.

**Rationale:**
- The ANSI palette (color0-color15) is constant across all variants (locked decision).
- Core gradients use palette colors for semantic data visualization: cool (low usage) to warm (high usage).
- Changing gradients per variant would break this semantic consistency.
- The cool-to-warm progression (cyan -> blue -> magenta) works aesthetically with all 6 accent colors because it is independent of the accent.
- This also dramatically reduces per-variant btop.theme complexity: instead of redesigning 24 gradient endpoints per variant, only 8 accent-role values change.

### btop temp_mid: Use Variant Accent (with exceptions)

**Recommendation:** Set `temp_mid` to the variant's accent color for variants where the accent hue fits naturally between cyan (hue 189) and red (hue 349). For Moss (hue 153, below cyan), keep `temp_mid` at the default purple `#7B6CBD` since green is cooler than cyan and breaks the cool-to-warm progression.

**Analysis per variant:**

| Variant | Accent Hue | Between 189-349? | temp_mid Recommendation |
|---------|-----------|-------------------|------------------------|
| Yoru | 251 | YES | Use accent `#7B6CBD` (current default) |
| Sakura | 342 | YES | Use accent `#D4839B` (pink, near warm end) |
| Ocean | 212 | YES | Use accent `#5B8EC9` (blue, between cyan and purple) |
| Tide | 180 | BORDERLINE | Use accent `#5AB5B5` (teal, very close to cyan start) |
| Ember | 23 | YES (wraps past 0) | Use accent `#D4895A` (orange, between purple and red on warm side) |
| Moss | 153 | NO | Keep `#7B6CBD` (green is cooler than cyan; breaks progression) |

### btop Box Outlines: Always Match Accent

**Recommendation:** All 4 box outlines (`cpu_box`, `mem_box`, `net_box`, `proc_box`) should always use the variant's accent color.

**Rationale:**
- Box outlines are the most visible UI branding element in btop.
- They visually communicate "this is the Sakura variant" or "this is the Ocean variant."
- Using a different color for box outlines would be confusing -- the accent color is the variant's identity.
- This matches the current behavior where all 4 box colors are set to `#7B6CBD` (accent).

## Wallpaper Generation Specifications

### Gemini Pro Configuration

**API parameters for wallpaper generation:**
- `aspect_ratio`: `"16:9"`
- `image_size`: `"4K"` (must be uppercase K)
- Model: Gemini 3 Pro Image (via Nano Banana interface or API)

**QHD versions:** Generate at 4K, then downscale to 2560x1440 using ImageMagick:
```bash
convert input-4k.png -resize 2560x1440 -quality 95 output-qhd.png
```

### Wallpaper Storage

**Recommendation:** Ship only 4K wallpapers in `backgrounds/` directory. Provide QHD versions in a `backgrounds/qhd/` subdirectory or document the downscale command.

**Rationale:**
- Current wallpapers have no resolution suffix -- adding one would be a naming convention break.
- Omarchy's wallpaper cycler reads from `backgrounds/` -- putting both resolutions in flat directory doubles the cycle count.
- Most users will have 4K or QHD displays; 4K downscales cleanly to QHD.
- The existing 5 wallpapers appear to be single-resolution -- maintaining consistency.

### Wallpaper Prompt Specifications

Each wallpaper should be generated with a prompt following this structure, customized per variant:

**Sakura (pink) -- Cherry Blossom Night:**
```
Generate a dark atmospheric anime illustration, 16:9 aspect ratio, 4K resolution.

Scene: A moonlit Japanese garden at night with cherry blossom trees. Petals drift
through the air. A stone lantern glows softly. A traditional wooden bridge crosses
a dark reflective pond.

Style: Dark atmospheric anime art, desktop wallpaper aesthetic. 70-80% deep
blacks and very dark tones. Subtle pink and soft rose tones only in cherry blossoms
and lantern glow. No text, no UI elements, no watermarks. Cinematic depth,
detailed anime quality.
```

**Ocean (blue) -- Harbor at Midnight:**
```
Generate a dark atmospheric anime illustration, 16:9 aspect ratio, 4K resolution.

Scene: A quiet harbor town at midnight viewed from a cliff. Fishing boats rest on
dark water reflecting starlight. Distant lighthouse beam cuts through sea mist.
Moonlight illuminates waves.

Style: Dark atmospheric anime art, desktop wallpaper aesthetic. 70-80% deep
blacks and very dark tones. Subtle deep blue and steel blue tones in water
reflections and moonlight. No text, no UI elements, no watermarks. Cinematic
composition with depth.
```

**Tide (teal) -- Underwater Shrine:**
```
Generate a dark atmospheric anime illustration, 16:9 aspect ratio, 4K resolution.

Scene: A partially submerged ancient shrine visible through dark ocean water.
Bioluminescent sea life provides subtle teal-cyan light. Coral formations and
swaying kelp surround the structure. Light filtering down from distant surface.

Style: Dark atmospheric anime art, desktop wallpaper aesthetic. 70-80% deep
blacks and very dark ocean tones. Subtle teal and aqua tones in bioluminescence
and water light. No text, no UI elements, no watermarks. Mysterious atmosphere
with depth.
```

**Ember (orange) -- Lantern Festival:**
```
Generate a dark atmospheric anime illustration, 16:9 aspect ratio, 4K resolution.

Scene: A narrow traditional Japanese alleyway during a lantern festival at night.
Paper lanterns with warm amber glow line the path. A lone figure in traditional
clothing walks away from viewer. Steam rises from a ramen stall.

Style: Dark atmospheric anime art, desktop wallpaper aesthetic. 70-80% deep
blacks and dark shadows. Warm orange and amber tones only in lantern glow and
steam highlights. No text, no UI elements, no watermarks. Cinematic atmosphere
with bokeh-like depth.
```

**Moss (green) -- Forest Shrine Path:**
```
Generate a dark atmospheric anime illustration, 16:9 aspect ratio, 4K resolution.

Scene: A moss-covered stone stairway leading to a small forest shrine at dusk.
Ancient trees with thick trunks form a canopy. Fireflies provide subtle green-gold
light. Moss and ferns cover every surface.

Style: Dark atmospheric anime art, desktop wallpaper aesthetic. 70-80% deep
blacks and very dark forest tones. Subtle muted green and forest tones in moss,
ferns, and firefly light. No text, no UI elements, no watermarks. Mysterious
atmosphere with depth and detail.
```

### Wallpaper Quality Checklist

After generation, each wallpaper should be verified for:
1. **Dark enough:** Background areas are close to black (not gray or mid-tone)
2. **Accent is subtle:** Color accent is present but not overwhelming (20-30% of visual area)
3. **Works with other variants:** Would this wallpaper look acceptable paired with a non-matching accent color?
4. **Anime aesthetic:** Consistent with the existing 5 wallpapers in style
5. **Resolution:** 3840x2160 for 4K output
6. **No artifacts:** No text, watermarks, distorted features, or AI generation artifacts
7. **Composition:** Visually balanced, good as a desktop background (not too busy, focal point not centered where UI elements will overlay)

## Accent-Dependent File Map (Complete Reference)

This is the definitive list of every value that changes per variant, organized by file. The planner should use this as the specification for variant file generation tasks.

### colors.toml (2 changes)

| Key | Default (Yoru) | Changes To |
|-----|---------------|------------|
| `accent` | `"#7B6CBD"` | Variant accent hex |
| `selection_background` | `"#7B6CBD"` | Variant accent hex |

### btop.theme (8 changes)

| Key | Default | Changes To | Role |
|-----|---------|------------|------|
| `theme[hi_fg]` | `"#7B6CBD"` | Variant accent hex | Keyboard shortcut highlight |
| `theme[selected_fg]` | `"#7B6CBD"` | Variant accent hex | Selected item foreground |
| `theme[proc_misc]` | `"#7B6CBD"` | Variant accent hex | Process box misc colors |
| `theme[cpu_box]` | `"#7B6CBD"` | Variant accent hex | CPU box outline |
| `theme[mem_box]` | `"#7B6CBD"` | Variant accent hex | Memory box outline |
| `theme[net_box]` | `"#7B6CBD"` | Variant accent hex | Network box outline |
| `theme[proc_box]` | `"#7B6CBD"` | Variant accent hex | Process box outline |
| `theme[temp_mid]` | `"#7B6CBD"` | Variant accent hex (see exceptions) | Temperature gradient midpoint |

### hyprland.conf (1 change)

| Key | Default | Changes To | Format |
|-----|---------|------------|--------|
| `$activeBorderColor` | `rgb(7B6CBD)` | `rgb(<STRIP>)` | Hex without # prefix |

### hyprlock.conf (3 changes)

| Key | Default | Changes To | Format |
|-----|---------|------------|--------|
| `$outer_color` | `rgba(123,108,189, 1.0)` | `rgba(<R>,<G>,<B>, 1.0)` | Decimal RGB |
| `$check_color` | `rgba(123,108,189, 1.0)` | `rgba(<R>,<G>,<B>, 1.0)` | Decimal RGB |
| label `color` | `rgba(123,108,189, 1.0)` | `rgba(<R>,<G>,<B>, 1.0)` | Decimal RGB |

### mako.ini (1 change)

| Key | Default | Changes To |
|-----|---------|------------|
| `border-color` (global) | `#7B6CBD` | Variant accent hex |

### waybar.css (2 changes)

| Selector | Default | Changes To |
|----------|---------|------------|
| `#workspaces button.active { color }` | `#7B6CBD` | Variant accent hex |
| Module icons `{ color }` | `#7B6CBD` | Variant accent hex |

### walker.css (2 changes)

| Variable | Default | Changes To |
|----------|---------|------------|
| `@define-color selected-text` | `#7B6CBD` | Variant accent hex |
| `@define-color border` | `#7B6CBD` | Variant accent hex |

### swayosd.css (1 change)

| Variable | Default | Changes To |
|----------|---------|------------|
| `@define-color progress` | `#7B6CBD` | Variant accent hex |

### vscode.json (4 changes)

| Key | Default | Changes To | Format |
|-----|---------|------------|--------|
| `tab.activeBorderTop` | `#7B6CBD` | Variant accent hex | Standard hex |
| `focusBorder` | `#7B6CBD` | Variant accent hex | Standard hex |
| `selection.background` | `#7B6CBD40` | `<HEX>40` | Hex + 25% alpha suffix |
| `list.activeSelectionBackground` | `#7B6CBD30` | `<HEX>30` | Hex + 19% alpha suffix |

**Also update `_comment_accent` in vscode.json** to reflect the new accent hex value.

## Open Questions

1. **Wallpaper-only delivery for QHD**
   - What we know: CONTEXT.md specifies shipping at both 4K and QHD resolutions
   - What's unclear: Whether both resolutions should live in `backgrounds/` (Omarchy cycler may show duplicates) or if QHD should be in a subdirectory
   - Recommendation: Ship 4K in `backgrounds/`, QHD in `backgrounds/qhd/`. Document the QHD option for users who need lower resolution. If Omarchy's cycler scans subdirectories, ship only 4K and document the ImageMagick downscale command instead.

2. **Variant switching and omarchy-theme-set integration**
   - What we know: The script copies variant files to root, then the user (or script) runs `omarchy-theme-set clawmarchy`
   - What's unclear: Whether `clawmarchy-variant` should automatically run `omarchy-theme-set` or leave it to the user
   - Recommendation: Have the script automatically run `omarchy-theme-set clawmarchy` after copying, with a `--no-apply` flag to skip. This matches user expectation that "switch variant" means "I want to see the change now."

3. **Restoring default variant**
   - What we know: The default (Yoru) files are in root; variant switching overwrites them
   - What's unclear: How to restore the default after switching to a variant (the original root files are overwritten)
   - Recommendation: Include a `variants/yoru/` directory containing the default files as well, so `clawmarchy-variant yoru` restores the default. This makes the system symmetric: every variant (including default) has a subdirectory. The root files are the initial state; variant directories are the restore points.

## Sources

### Primary (HIGH confidence)
- COLORS.md in this repo -- complete per-file color audit with accent-dependent values mapped
- colors.toml in this repo -- source of truth palette definition
- All 9 config files read directly from repo -- exact accent hex occurrences verified
- WCAG 2.1 contrast ratio formula -- standard mathematical specification (W3C)
- Python contrast ratio calculations -- computed and verified in this research session

### Secondary (MEDIUM confidence)
- Gemini Pro image generation docs: https://ai.google.dev/gemini-api/docs/image-generation -- aspect ratio (16:9) and resolution (4K) support verified
- Omarchy theme manual: https://learn.omacom.io/2/the-omarchy-manual/92/making-your-own-theme -- theme file structure and installation
- Omarchy theme management: https://deepwiki.com/basecamp/omarchy/6.1-theme-management -- atomic swap mechanism and symlink architecture
- Omarchy backgrounds: https://learn.omacom.io/2/the-omarchy-manual/89/backgrounds -- wallpaper directory convention
- Reference themes (omarchy-aura-theme, omarchy-cobalt2-theme) -- flat backgrounds directory structure confirmed

### Tertiary (LOW confidence)
- Wallpaper file size estimates -- based on existing wallpapers in repo (2.3-9.6 MB range)
- Omarchy wallpaper cycler subdirectory behavior -- not verified; assumed flat-only based on reference themes

## Metadata

**Confidence breakdown:**
- Accent color selection: HIGH -- WCAG contrast computed mathematically; hex values verified across all file formats
- Variant packaging: HIGH -- Omarchy architecture verified via docs and reference themes; file map derived from COLORS.md audit
- btop gradient mapping: HIGH -- every gradient endpoint analyzed; hue progression logic verified
- Wallpaper generation: MEDIUM -- Gemini Pro 4K/16:9 capability verified; prompt quality depends on Gemini output (not controllable)
- Switching mechanism: MEDIUM -- Omarchy's theme-set behavior verified; script-based switching is standard but untested in this theme

**Research date:** 2026-02-19
**Valid until:** 2026-03-19 (30 days -- stable domain, no fast-moving dependencies)
