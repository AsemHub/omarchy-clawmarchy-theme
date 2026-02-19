# Phase 5: Documentation and Preview - Research

**Researched:** 2026-02-19
**Domain:** Technical documentation (GitHub README), desktop screenshot staging
**Confidence:** HIGH

## Summary

Phase 5 is a documentation-and-screenshot phase with no code changes to theme config files. The README.md already has a working base structure from Phase 04-03 (Install, Features, Accent Variants, Palette, Credits, Switching Themes). This phase expands it with four new sections: component documentation with a full file tree, troubleshooting, customization guide, and compatibility requirements. Additionally, the existing preview.png (currently a placeholder from the repo's initial state) must be replaced with a screenshot showing the fully themed desktop in the Ember variant.

The Omarchy theme ecosystem has no formal README template or standard documentation requirements. Most community themes ship minimal READMEs (install command + preview image only). Clawmarchy's documentation will be significantly more comprehensive, which is appropriate given its complexity (11 config files, 6 variants, wallpaper collection, variant switching script).

**Primary recommendation:** Expand the existing README.md in-place (not rewrite), adding a Table of Contents at the top and four new sections (Themed Components, Troubleshooting, Customization, Compatibility) while preserving all existing sections. Provide detailed staging instructions for the user to take the Ember variant screenshot manually.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Component docs depth: Full file tree showing every config file in the theme (including variants/, backgrounds/)
- Customization guide scope: Pre-built variants only -- document clawmarchy-variant and the 6 options. Do NOT include manual hex editing for custom accent colors (that's v2 CLI-01 scope)
- Preview screenshot: Show the Ember (orange) variant -- warm and vibrant, stands out on GitHub. Full desktop spread: Waybar at top, btop in terminal, Neovim or VS Code open, Walker launcher visible -- show all themed surfaces. User will take the screenshot manually (Claude provides staging instructions in the plan)
- README structure and tone: Minimal and clean: short descriptions, tables over prose, let screenshots speak. Table of contents at the top with linked navigation
- Expand on existing README base rather than rewriting from scratch
- Keep the current Install section as-is (one-liner is perfect)
- The Accent Variants section from 04-03 is already solid -- may only need minor tweaks

### Claude's Discretion
- Component docs format (table vs grouped descriptions vs hybrid)
- Whether to mark each file as generated vs static override in the README
- Whether to reference COLORS.md for detailed color mapping or inline in README
- Wallpaper customization detail level (directory location, resolution guidance)
- Expand beyond the 3 required troubleshooting issues (opacity, fonts, icons) based on what's likely to trip users up
- Compatibility: list specific versions or just "requires Omarchy" based on what the theme actually needs
- Whether to keep wallpaper-preview.png as a separate banner or use only preview.png
- GitHub badges (if any)
- Whether to keep the existing Palette section with color swatch badges

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| ASST-03 | Preview screenshot (preview.png) updated to reflect full themed desktop with new components | Research provides screenshot staging instructions (Ember variant, full desktop spread with Waybar/btop/editor/Walker), file format guidance (PNG, 3840x2160 current), and compression recommendations |
| DOC-01 | README documents all themed components with screenshots or descriptions | Research provides full file inventory (11 root configs + 6 variant dirs + wallpapers), component descriptions, and recommends table format with file-per-row and "what it controls" column |
| DOC-02 | README includes troubleshooting section for common issues (opacity, fonts, icon themes) | Research documents 5 real-world issues from Omarchy GitHub issues/discussions with verified solutions |
| DOC-03 | README includes customization guide explaining how to change accent colors and wallpapers | Research confirms variant-only scope (clawmarchy-variant script + wallpaper directory), no manual hex editing |
| DOC-04 | README documents compatibility requirements (Hyprland, Omarchy version, required packages) | Research documents actual system: Omarchy 3.x+, Hyprland/Wayland (no specific version pinned), JetBrainsMono Nerd Font (used by hyprlock.conf), Yaru-purple-dark icons |
</phase_requirements>

## Standard Stack

### Core
| Tool | Version | Purpose | Why Standard |
|------|---------|---------|--------------|
| GitHub Flavored Markdown | N/A | README.md authoring | Standard for all GitHub repos; supports tables, TOC links, badges, image embeds |
| grim | 1.5.0 | Full-screen Wayland screenshot capture | Standard Wayland screenshot tool, already installed on this system |
| slurp | 1.5.0 | Region selection for screenshots | Companion to grim for area selection (not needed for full-screen) |

### Supporting
| Tool | Purpose | When to Use |
|------|---------|-------------|
| shields.io badges | Color swatch badges in README | Already used in Palette section; optional for new sections |
| `hyprctl dispatch exec` | Launch apps for screenshot staging | Positioning windows for the preview screenshot |
| `optipng` or similar | PNG compression | If preview.png file size needs reduction for GitHub |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Full-screen grim | Hyprshot wrapper | Hyprshot adds interactive selection; full-screen `grim` is simpler for a staged desktop |
| PNG format | WebP or JPEG | PNG is lossless and the repo convention; GitHub renders all three but PNG is standard for screenshots |

## Architecture Patterns

### Recommended README Structure

Based on the existing README base and the user's decisions:

```
README.md
├── wallpaper-preview.png banner (existing)
├── preview.png desktop screenshot (to be updated)
├── # Clawmarchy (title)
├── Table of Contents (NEW)
├── ## Install (existing, keep as-is)
├── ## Features (existing, keep as-is)
├── ## Themed Components (NEW -- DOC-01)
│   ├── File tree
│   └── Component table
├── ## Accent Variants (existing, minor tweaks only)
├── ## Customization (NEW -- DOC-03)
│   ├── Switching variants
│   └── Wallpapers
├── ## Troubleshooting (NEW -- DOC-02)
├── ## Compatibility (NEW -- DOC-04)
├── ## Palette (existing, keep or remove per discretion)
├── ## Credits (existing)
└── ## Switching Themes (existing)
```

### Pattern 1: Table of Contents with Anchor Links

GitHub Flavored Markdown auto-generates anchor IDs from headings. Use lowercase, hyphens for spaces.

```markdown
## Contents

- [Install](#install)
- [Features](#features)
- [Themed Components](#themed-components)
- [Accent Variants](#accent-variants)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Compatibility](#compatibility)
- [Credits](#credits)
```

### Pattern 2: Component Documentation as Table

User wants "tables over prose." A single table mapping file to purpose is clean:

```markdown
| File | Component | What It Controls |
|------|-----------|------------------|
| `colors.toml` | Color palette | Source of truth for all theme colors |
| `hyprland.conf` | Window manager | Borders, opacity, blur, shadows, animations |
| `waybar.css` | Status bar | AMOLED background, accent icons, semantic status colors |
| ... | ... | ... |
```

### Pattern 3: File Tree as Fenced Code Block

User explicitly wants "full file tree showing every config file":

```
clawmarchy/
├── colors.toml          # Color palette (source of truth)
├── hyprland.conf        # Window manager config
├── ...
├── backgrounds/
│   ├── 1-sakura-cherry-blossoms.png
│   └── qhd/             # QHD downscaled versions
├── variants/
│   ├── ember/            # 9 config files per variant
│   ├── moss/
│   └── ...
└── clawmarchy-variant   # Variant switching script
```

### Pattern 4: Troubleshooting as Problem/Solution Pairs

Clean format for troubleshooting -- heading per issue, symptom + fix:

```markdown
### Windows look slightly gray instead of true black
**Cause:** Omarchy's default opacity multiplier conflicts with theme override.
**Fix:** ...
```

### Anti-Patterns to Avoid
- **Wall of text:** User explicitly wants "minimal and clean" -- avoid paragraph-heavy prose
- **Redundant information:** Don't repeat what COLORS.md already covers in detail; link to it instead
- **Version pinning too tightly:** Don't pin to exact Hyprland version (e.g., 0.53.3) -- theme uses standard Hyprland features, not version-specific APIs
- **Screenshot instructions in README:** Staging instructions go in the PLAN only (for the user), not in the README itself

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Table of contents | Manual line-by-line TOC generation | GitHub anchor link convention (`#heading-text` -> lowercase, hyphens) | GitHub auto-generates anchors; manual IDs break |
| Color swatch previews | Inline HTML/SVG | shields.io badge URLs (already in use) | Consistent rendering across GitHub light/dark mode |
| Screenshot staging | Automated script | Manual user instructions | Screenshot requires visual judgment; no automation can verify aesthetics |

**Key insight:** This is a documentation phase. The "don't hand-roll" principle means: don't over-engineer the README with custom HTML, embedded SVGs, or complex layout hacks. GitHub Flavored Markdown tables and simple image embeds are sufficient and more maintainable.

## Common Pitfalls

### Pitfall 1: README Images Bloating Repository Size
**What goes wrong:** Large PNG screenshots (especially 4K) dramatically increase clone/fetch times. The current wallpaper-preview.png is 8.8MB.
**Why it happens:** 3840x2160 screenshots with many colors compress poorly in PNG format.
**How to avoid:** Keep preview.png reasonable. The current preview.png is 987KB at 3840x2160 which is good. For the new screenshot, aim for similar size. Use `optipng` or `pngquant` to compress if needed. Consider whether wallpaper-preview.png (8.8MB) should be kept, removed, or compressed.
**Warning signs:** `git clone` taking noticeably longer; GitHub preview not loading quickly.

### Pitfall 2: Broken Anchor Links in TOC
**What goes wrong:** Table of contents links don't work because anchor IDs don't match.
**Why it happens:** GitHub generates anchors by lowercasing headings and replacing spaces with hyphens. Special characters (parentheses, colons, dots) are stripped.
**How to avoid:** Use simple heading text. Test links locally or verify after push. `## VS Code` -> `#vs-code`. `## Accent Variants` -> `#accent-variants`.
**Warning signs:** Clicking TOC links scrolls to top of page instead of target section.

### Pitfall 3: Documenting Implementation Details Users Don't Need
**What goes wrong:** README becomes a developer reference instead of a user guide. Explaining Hyprland layerrule syntax, CSS @define-color patterns, or btop gradient formulas is noise for theme users.
**Why it happens:** Developers document what they built, not what users need.
**How to avoid:** Each section should answer a user question: "What does this do?" not "How was this built?" Reference COLORS.md for developer-level detail.
**Warning signs:** README exceeds ~200 lines; sections require technical knowledge to understand.

### Pitfall 4: Troubleshooting Section with Untested Solutions
**What goes wrong:** Documenting theoretical fixes that don't actually work.
**Why it happens:** Copying from web searches without verifying against this specific theme's configuration.
**How to avoid:** Every troubleshooting item should reference the actual Clawmarchy config pattern. The opacity fix references `windowrule = opacity 1.0 override 1.0 override` which is exactly what hyprland.conf already uses. Solutions should be specific to this theme's file structure.
**Warning signs:** Troubleshooting steps reference files/settings that don't exist in the theme.

### Pitfall 5: Screenshot Not Showing All Themed Components
**What goes wrong:** Preview screenshot only shows a terminal and wallpaper, missing Waybar, Walker, notifications, etc.
**Why it happens:** Taking a casual screenshot without staging all components.
**How to avoid:** Follow the staging checklist: switch to Ember variant, open btop in a terminal, open Neovim or VS Code, trigger Walker launcher (Super+Space), ensure Waybar is visible at top. All themed surfaces must be visible simultaneously.
**Warning signs:** Preview doesn't demonstrate theme value proposition (consistent theming across all apps).

## Code Examples

### README Table of Contents (GitHub Flavored Markdown)

```markdown
## Contents

- [Install](#install)
- [Features](#features)
- [Themed Components](#themed-components)
- [Accent Variants](#accent-variants)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Compatibility](#compatibility)
- [Credits](#credits)
```

### Component Documentation Table

```markdown
## Themed Components

| File | Component | What It Controls |
|------|-----------|------------------|
| `colors.toml` | Color palette | All theme colors; read by Omarchy's template engine |
| `hyprland.conf` | Hyprland | Window borders, opacity override, blur, shadows, animations |
| `waybar.css` | Waybar | Status bar colors, accent icons, battery/network status indicators |
| `walker.css` | Walker | App launcher AMOLED background and accent search border |
| `mako.ini` | Mako | Notification colors with urgency-based border differentiation |
| `swayosd.css` | SwayOSD | Volume/brightness popup colors |
| `hyprlock.conf` | Hyprlock | Lock screen colors, accent clock, wallpaper dimming overlay |
| `btop.theme` | btop | System monitor gradients (cyan-to-magenta load mapping) |
| `neovim.lua` | Neovim | tokyonight-night AMOLED black background overrides |
| `vscode.json` | VS Code | 30 workspace color customizations for AMOLED black surfaces |
| `chromium.theme` | Chromium | Browser toolbar background color |
| `icons.theme` | GTK icons | Yaru-purple-dark icon set |
```

### Troubleshooting Entry Pattern

```markdown
### Windows look slightly gray instead of true black

Clawmarchy sets full opacity override in `hyprland.conf` to prevent Omarchy's default 0.97 multiplier from creating a gray wash. If windows appear gray:

1. Verify `hyprland.conf` is loaded: `hyprctl keyword source` should list the theme's config
2. Reload Hyprland: `hyprctl reload`
3. Check for conflicting opacity rules: `hyprctl getoption decoration:active_opacity`
```

### Customization Section Pattern

```markdown
## Customization

### Accent Variants

Switch between 6 pre-built accent colors:

\`\`\`
clawmarchy-variant <name>
\`\`\`

This copies the variant's config files to the theme root and runs `omarchy-theme-set` to apply changes. Reload Waybar and reopen apps to see the new accent color everywhere.

### Wallpapers

Theme wallpapers are in `backgrounds/`:

| File | Scene | Paired Variant |
|------|-------|----------------|
| `1-sakura-cherry-blossoms.png` | Cherry blossom garden | sakura |
| ... | ... | ... |

QHD (2560x1440) versions are in `backgrounds/qhd/`. Replace or add wallpapers by placing PNG files in the `backgrounds/` directory.
```

### Screenshot Staging Commands

For the plan (user instructions), not for the README:

```bash
# 1. Switch to Ember variant
clawmarchy-variant ember

# 2. Open btop in a terminal
btop &

# 3. Open Neovim or VS Code in a second terminal/window
nvim &

# 4. Trigger Walker launcher (stays open briefly)
# Press Super+Space, then take screenshot while Walker is visible

# 5. Capture full-screen screenshot
grim ~/preview-ember.png

# 6. Move to repo
cp ~/preview-ember.png /path/to/repo/preview.png
```

## Troubleshooting Issues to Document

Based on research of Omarchy GitHub issues and the theme's actual configuration:

### 1. Opacity / Gray Wash (REQUIRED)
**Issue:** Windows appear slightly gray instead of true black
**Root cause:** Omarchy's default opacity multiplier (`0.97 * 0.9 = 0.873` effective opacity)
**Clawmarchy solution:** `hyprland.conf` uses `opacity 1.0 override 1.0 override` keyword
**User action:** Reload Hyprland (`hyprctl reload`), check no conflicting rules in personal config
**Source:** [Omarchy issue #2285](https://github.com/basecamp/omarchy/issues/2285), resolved Feb 2026

### 2. Missing Fonts / Broken Glyphs (REQUIRED)
**Issue:** Hyprlock clock or Waybar icons show boxes/missing characters
**Root cause:** JetBrainsMono Nerd Font not installed
**Clawmarchy dependency:** `hyprlock.conf` line 29 hardcodes `font_family = JetBrainsMono Nerd Font`
**User action:** Install via Omarchy menu (Install > Style > Font) or `pacman -S ttf-jetbrains-mono-nerd`
**Source:** [Omarchy fonts manual](https://learn.omacom.io/2/the-omarchy-manual/94/fonts)

### 3. Icon Theme Not Applying (REQUIRED)
**Issue:** Icons don't change after installing theme or switching variants
**Root cause:** Icon theme not installed on system, or incomplete download, or needs full restart (not just Hyprland reload)
**Clawmarchy config:** `icons.theme` contains `Yaru-purple-dark`
**User action:** Ensure Yaru icon theme package is installed; do a full logout/login (not just `hyprctl reload`)
**Source:** [Omarchy discussion #2264](https://github.com/basecamp/omarchy/discussions/2264)

### 4. VS Code Colors Not Applying (RECOMMENDED)
**Issue:** VS Code still shows default Tokyo Night colors after theme install
**Root cause:** Omarchy does NOT auto-apply vscode.json colorCustomizations. The framework limitation is documented in the file's `_comment` field.
**User action:** Manually copy the `[Tokyo Night]` colorCustomizations block into VS Code's `settings.json`
**Source:** Theme's `vscode.json` `_comment` field

### 5. Variant Switch Doesn't Fully Apply (RECOMMENDED)
**Issue:** After running `clawmarchy-variant`, some apps still show old accent color
**Root cause:** Running apps cache their config; Waybar, terminals, and editors need manual reload
**User action:** The script prints "Reload Waybar and reopen apps to see changes." Follow this instruction. For Waybar specifically: `killall waybar && waybar &`
**Source:** Theme's `clawmarchy-variant` script output

## Compatibility Research

### What Clawmarchy Actually Requires

| Dependency | Reason | Specificity |
|------------|--------|-------------|
| Omarchy | Theme framework (`omarchy-theme-install`, `omarchy-theme-set`, theme directory conventions) | Version 3.x+ (uses `match:class` syntax in Hyprland rules, introduced in Omarchy 3.3.x) |
| Hyprland | Window manager (`hyprland.conf` uses `windowrule`, `layerrule`, `decoration`, `animations`) | Any version supporting `match:class` and `match:namespace` syntax (v0.40+) |
| Waybar | Status bar (`waybar.css` uses `@define-color`, Omarchy's `style.css` imports theme CSS) | Standard Waybar with GTK CSS support |
| Walker | App launcher (`walker.css` uses `@define-color` variables) | Standard Walker |
| Mako | Notifications (`mako.ini` with urgency sections) | Standard Mako |
| SwayOSD | Volume/brightness OSD (`swayosd.css` uses `@define-color`) | Standard SwayOSD |
| Hyprlock | Lock screen (`hyprlock.conf` with color variables and label blocks) | Standard Hyprlock |
| btop | System monitor (`btop.theme` custom theme file) | Standard btop |
| JetBrainsMono Nerd Font | Used by `hyprlock.conf` for clock display | Must be installed; Omarchy provides it by default |
| Yaru-purple-dark icons | Referenced by `icons.theme` | Must be installed; Omarchy includes Yaru variants |

### Recommendation: Compatibility Section Content

Keep it simple. Don't pin to exact versions since the theme uses standard features that have been stable for 6+ months. The compatibility section should say:

- **Requires Omarchy** (v3.0 or later)
- **Hyprland/Wayland** (X11 not supported)
- **JetBrainsMono Nerd Font** (included with Omarchy, used by lock screen)
- **VS Code with Tokyo Night extension** (optional, for editor theming)

## Discretion Recommendations

Based on research, here are recommendations for areas left to Claude's discretion:

### Component docs format: Hybrid (file tree + table)
**Recommendation:** Show the file tree first (visual overview), then a table with per-file descriptions. The tree satisfies the "full file tree" requirement; the table satisfies "tables over prose."

### Mark files as generated vs static override: Yes, briefly
**Recommendation:** Add a one-line note after the file tree: "All files except `colors.toml` are static overrides. See [COLORS.md](COLORS.md) for detailed color mapping." This is useful information without cluttering the README.

### Reference COLORS.md vs inline: Reference
**Recommendation:** Link to COLORS.md for detailed color audit. The README component table gives what-it-controls summaries; COLORS.md has the per-value breakdown. Avoids README bloat.

### Wallpaper customization detail: Directory + resolution
**Recommendation:** Document the `backgrounds/` directory location, list the 5 wallpapers with their paired variants, mention `qhd/` subdirectory for QHD monitors, and note that wallpapers should be dark atmospheric PNG images. Brief -- 5-6 lines.

### Additional troubleshooting: Add VS Code and variant switch
**Recommendation:** Add items 4 and 5 from the troubleshooting research above. Both are real user pain points unique to this theme.

### Compatibility specificity: "Requires Omarchy" with brief notes
**Recommendation:** Don't pin exact versions. Say "Omarchy 3.0+" and list the font/icon requirements. The theme uses stable Hyprland/Wayland features, not bleeding-edge APIs.

### wallpaper-preview.png: Keep as separate banner
**Recommendation:** Keep it. The wallpaper banner (8.8MB) shows the aesthetic; preview.png (to be updated) shows the desktop. They serve different purposes. However, 8.8MB is large -- consider compressing it in a future pass. Not blocking for this phase.

### GitHub badges: Skip
**Recommendation:** No badges. The theme is not on a package registry, has no CI, and badges add visual noise for no information value. The Palette section's color swatch badges are sufficient visual flair.

### Keep Palette section: Yes
**Recommendation:** Keep it. The shields.io color swatches are a quick visual reference for the default palette. They're compact (7 badges, one line of rendered output).

## Open Questions

1. **wallpaper-preview.png size (8.8MB)**
   - What we know: It's a 3840x2160 PNG at 8.8MB, significantly larger than preview.png (987KB)
   - What's unclear: Whether this will cause GitHub rendering issues or slow page loads
   - Recommendation: Keep for now; compression is a separate optimization task outside Phase 5 scope

2. **Omarchy version floor**
   - What we know: Current system runs Omarchy 3.3.3. The theme uses `match:class` and `match:namespace` Hyprland rule syntax.
   - What's unclear: Exactly when `match:class` was introduced (appears to be Omarchy 3.3.x based on issue #2285 resolution)
   - Recommendation: Document as "Omarchy 3.0+" which is safe; the `match:` syntax may have been backported or is standard Hyprland. LOW risk of users on 3.0-3.2 hitting issues.

## Sources

### Primary (HIGH confidence)
- Project files: All 11 config files read directly from repository
- `COLORS.md` -- complete color audit with per-file breakdowns
- `clawmarchy-variant` script -- verified variant switching mechanism
- System inspection: `hyprctl version` (0.53.3), `pacman -Q` (all component versions), Omarchy version (3.3.3)

### Secondary (MEDIUM confidence)
- [Omarchy Theme Management - DeepWiki](https://deepwiki.com/basecamp/omarchy/6.1-theme-management) -- theme directory structure and activation flow
- [Omarchy Manual - Making Your Own Theme](https://learn.omacom.io/2/the-omarchy-manual/92/making-your-own-theme) -- `colors.toml` as core, optional overrides
- [Omarchy Manual - Fonts](https://learn.omacom.io/2/the-omarchy-manual/94/fonts) -- JetBrainsMono Nerd Font default
- [Omarchy issue #2285](https://github.com/basecamp/omarchy/issues/2285) -- opacity override fix
- [Omarchy discussion #2264](https://github.com/basecamp/omarchy/discussions/2264) -- icon theme troubleshooting
- [Omarchy issue #1096](https://github.com/basecamp/omarchy/issues/1096) -- theme not applied when nvim running

### Tertiary (LOW confidence)
- Omarchy version floor ("3.0+") -- based on feature availability inference, not explicit documentation

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- GitHub Markdown, grim, file inventory all directly verified
- Architecture: HIGH -- README structure follows user decisions from CONTEXT.md, file tree verified
- Pitfalls: HIGH -- All troubleshooting items sourced from real Omarchy issues and verified against theme config files
- Compatibility: MEDIUM -- Component versions verified locally, but minimum Omarchy version is inferred

**Research date:** 2026-02-19
**Valid until:** 2026-04-19 (60 days -- documentation patterns are stable)
