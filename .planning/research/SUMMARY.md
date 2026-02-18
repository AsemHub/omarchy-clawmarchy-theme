# Project Research Summary

**Project:** Clawmarchy — Omarchy Theme Expansion
**Domain:** Hyprland/Omarchy desktop theme with multi-component coverage and accent color customization
**Researched:** 2026-02-18
**Confidence:** HIGH

## Executive Summary

Clawmarchy is an Omarchy desktop theme targeting true AMOLED black (#000000) with a muted purple accent palette, currently incomplete because it lacks coverage for Waybar, Walker, Mako, SwayOSD, Hyprlock, and Chromium. Every polished community theme (Cobalt2, Ash, Dracula) ships custom CSS/config files for these components — their absence makes Clawmarchy feel amateur despite its strong visual identity in btop, Neovim, and Hyprland. The recommended approach is to add these missing components using Omarchy's built-in two-track system: let the existing template engine generate configs from colors.toml for standard color-only components, and ship static override files only where richer customization is needed (urgency-specific Mako colors, accent-colored Walker border, semantic Waybar variables).

The architecture is simpler than it appears because Omarchy v3.3.0 already has a template engine (`omarchy-theme-set-templates`) that reads colors.toml and generates application configs via sed substitution. Clawmarchy should exploit this rather than fight it. The core decision for each component is binary: does the generated output from colors.toml suffice, or does the theme need a static override? For most new components (Waybar, Walker, Mako, SwayOSD, Hyprlock, Chromium), the generated output is close enough to start with, and static overrides can be added selectively for AMOLED-specific customizations. The longer-term accent color CLI tool follows naturally: modify colors.toml, update any static override files that hardcode hex values, then call `omarchy-theme-set` to regenerate everything else.

The two critical risks are existing technical debt and deferred complexity. The current `hyprland.conf` uses a global opacity catch-all (`match:class .*`) that breaks transparency for layer surfaces like Waybar and Mako — this must be fixed in Phase 1 before expanding component coverage. Color drift is the other major risk: the same hex values are hardcoded in 5+ files with no traceability. Adding accent variants or a CLI tool without first establishing the colors.toml-as-source-of-truth principle will create cascading inconsistencies. The CLI tool and accent variants are legitimate differentiators but should be deferred to v1.x/v2+ until the foundational coverage is stable.

## Key Findings

### Recommended Stack

Omarchy is 100% Bash — every `omarchy-*` script, the template engine, and the config management layer. The CLI accent tool should follow this convention using Bash + sed, not Python or Node. The config formats differ by component: Waybar and SwayOSD use GTK3 CSS with `@define-color`, Walker uses GTK4 CSS with the same syntax but different layout primitives, Mako uses INI format, and Hyprland uses its own `rgb()` color format (not `#hex`). The template engine provides three variable formats for each colors.toml key: `{{ key }}` (full hex with #), `{{ key_strip }}` (hex without #), and `{{ key_rgb }}` (decimal RGB) — these cover all format requirements across components.

**Core technologies:**
- `colors.toml`: Single source of truth for 24 palette values — all component configs derive from here
- `omarchy-theme-set-templates`: Omarchy's built-in template engine — reuse, do not reinvent
- Bash + sed: CLI tool implementation — matches Omarchy ecosystem, zero additional dependencies
- Static override files: For components needing more than color substitution (btop gradients, Hyprland effects, Neovim plugin callbacks)
- GTK3/GTK4 CSS `@define-color`: Color variable syntax for Waybar/Walker/SwayOSD — no CSS custom properties, no `var()`

### Expected Features

The Omarchy theme community has established clear conventions. Themes without Waybar/Walker/Mako coverage are considered incomplete. Clawmarchy's AMOLED true black is a genuine differentiator — no other popular theme uses `#000000`; even matte-black uses `#121212`.

**Must have (table stakes):**
- `waybar.css` custom override — all polished community themes ship this; auto-gen only provides 2 CSS variables
- `walker.css` custom override — color definitions for the launcher, accent-colored border as AMOLED differentiator
- `mako.ini` custom override — urgency-level color rules require static override; auto-gen only supports 3 colors
- `hyprlock.conf` custom override — lock screen is a daily touchpoint; verify auto-gen produces AMOLED black
- `swayosd.css` custom override — volume/brightness popups need consistency with the theme
- `chromium.theme` — single RGB line; trivially simple
- Opacity window rule refinement — replace global `match:class .*` with targeted rules
- Semantic Waybar color variables (`@theme-red`, `@theme-yellow`, `@theme-green`) — Omarchy PR #2808 added these

**Should have (competitive):**
- Pre-built accent variants (3-5 colors: blue, teal, red, amber) — no existing Omarchy theme offers this
- Expanded wallpaper collection (10-15 curated anime wallpapers) — distinct aesthetic niche
- Full VS Code workspace color customizations — extension reference alone does not guarantee AMOLED black
- Comprehensive documentation with troubleshooting guide and per-variant screenshots

**Defer (v2+):**
- CLI accent customization tool (`clawmarchy-accent`) — high complexity, requires build system; users can edit colors.toml manually
- Single-source generation from colors.toml for btop.theme and neovim.lua — worth building only when CLI tool is needed
- Theme hook integration via `omarchy-theme-hook` — runtime accent switching without reinstall; requires deeper integration research

### Architecture Approach

The architecture is a two-track config resolution system: Omarchy's template engine generates configs from colors.toml for standard color-application components, while the theme ships static override files for components needing custom behavior. The key insight is that `omarchy-theme-set` already orchestrates this — themes do not need their own build pipeline for v1. The CLI accent tool (when built) is a thin wrapper: modify `colors.toml` + update static override files via sed + call `omarchy-theme-set` to trigger template regeneration.

**Major components:**
1. `colors.toml` — palette authority; 24 color values; source for all template-generated configs
2. Omarchy Template Engine (`omarchy-theme-set-templates`) — generates Waybar/Walker/Mako/terminal/Chromium configs; theme passively benefits
3. Static Override Files (`hyprland.conf`, `btop.theme`, `neovim.lua`, `vscode.json`) — theme-specific configs requiring gradients, plugin callbacks, or non-color settings
4. New Static Overrides (`waybar.css`, `walker.css`, `mako.ini`, `swayosd.css`) — optional but recommended for AMOLED-specific styling beyond template defaults
5. CLI Tool (`clawmarchy-accent`, v2+) — thin Bash wrapper that patches `colors.toml` + static files + delegates to `omarchy-theme-set`

### Critical Pitfalls

1. **Global opacity catch-all breaks Waybar/Walker/Mako** — The current `windowrule = opacity 1.0 1.0, match:class .*` in `hyprland.conf` forces full opacity on all windows including layer surfaces. Waybar is a layer surface, not a window — use `layerrule` not `windowrule` for it. Replace the catch-all with targeted rules: `windowrule = opacity 1.0 override 1.0 override, match:class ^(ghostty|kitty|Alacritty|btop|neovide)$`

2. **Color drift across static override files** — The same hex values (`#7B6CBD`, `#000000`, `#E8E0D0`) are hardcoded in 5+ files. Adding accent variants or a CLI tool without fixing this first will cause cascading inconsistencies. Add source comments to all static files documenting which values map to colors.toml keys. The CLI tool must update static override files alongside colors.toml.

3. **Shipping static overrides for Omarchy-generated components** — If a theme ships `waybar.css` as a static file, Omarchy's template skips generation for that component. This is intentional when custom styling is needed, but creates a maintenance trap if done reflexively. Only ship static overrides where the generated output is genuinely insufficient; let colors.toml drive everything else.

4. **Accent color variants with insufficient contrast** — Different hues at the same HSL lightness have wildly different perceived brightness. A "teal" at the same lightness as the purple accent may be unreadable on `#000000`. Verify each variant against WCAG 4.5:1 contrast ratio using a perceptually uniform color space (Oklch preferred).

5. **Neovim plugin version brittleness** — The `on_colors` callback in `neovim.lua` modifies tokyonight.nvim's internal color table, which has no stability guarantee. Add `vim.cmd("highlight Normal guibg=#000000")` as a fallback so the AMOLED identity survives plugin updates.

## Implications for Roadmap

Based on combined research, the suggested phase structure has clear dependency ordering: fix the opacity regression first (it affects everything), then add missing component coverage (high value, low effort), then improve color system traceability (prerequisite for CLI and variants), then add differentiating features.

### Phase 1: Foundation Fix — Opacity and Hyprland Rules

**Rationale:** The global opacity catch-all is a regression that will break every new component added in subsequent phases. Waybar and Mako are layer surfaces that require `layerrule` not `windowrule`. This must be fixed before any other work proceeds. It is also the lowest-effort fix with the highest impact — one `hyprland.conf` change.

**Delivers:** AMOLED black that works correctly with layer surfaces and transparency-dependent apps; targeted window rules instead of sledgehammer catch-all

**Addresses:** Complete theme coverage prerequisite; FEATURES.md "Refine opacity window rule" (P1)

**Avoids:** PITFALLS.md Pitfall 1 (global opacity breaks layer surfaces), Pitfall 2 (Hyprland syntax correctness)

### Phase 2: Component Coverage — Waybar, Walker, Mako, SwayOSD, Hyprlock, Chromium

**Rationale:** These 6 missing components are the gap between "incomplete theme" and "polished community theme." All are low complexity (CSS color definitions or INI configs). They unblock the theme from being recommended to the Omarchy community. The correct approach per component: verify what Omarchy's template generates from current colors.toml, then decide if a static override is needed for AMOLED-specific enhancement.

**Delivers:** Full desktop component coverage matching the Cobalt2/Ash/Dracula reference themes; AMOLED black across all visible surfaces

**Uses:** GTK3 CSS `@define-color` for Waybar/SwayOSD, GTK4 CSS for Walker, INI for Mako; Omarchy's template engine for baseline generation

**Implements:** Architecture "Template-First, Override When Needed" pattern; semantic waybar color variables from FEATURES.md

**Avoids:** PITFALLS.md Pitfall 4 (don't ship redundant static overrides for things Omarchy generates adequately)

### Phase 3: Color System Traceability

**Rationale:** Currently the same hex values appear in 5+ files with no documented relationship to colors.toml. This is acceptable for the current fixed palette but becomes unmanageable with accent variants or a CLI tool. Before building either, establish which files are Omarchy-generated (no maintenance needed) versus which are static overrides (must be updated when accent changes). This phase is primarily documentation and comment additions to existing files, not new code.

**Delivers:** Clear audit of which files contain hardcoded hex values and why; source comments in all static overrides mapping values to colors.toml keys; foundation for CLI tool

**Uses:** Bash grep to find all hex occurrences; ARCHITECTURE.md Pattern 3 (Static Override With Source Comments)

**Implements:** "Single source of truth" principle from ARCHITECTURE.md

**Avoids:** PITFALLS.md Pitfall 3 (color drift), which blocks both CLI tool and accent variants

### Phase 4: Accent Color Variants (v1.x)

**Rationale:** Pre-built accent variants are Clawmarchy's primary competitive differentiator — no other Omarchy theme offers multiple accent options on a consistent AMOLED black base. Each variant requires a separate colors.toml with a different accent + adjusted selection_background, plus a re-crafted btop.theme gradient that maintains the cyan-to-magenta aesthetic with the new hue anchor. Start with 3 variants (blue, teal, rose) that have clear aesthetic rationale.

**Delivers:** 3-5 installable accent variant packages; expanded wallpaper collection (wallpapers chosen to work across accent variants, not tied to purple specifically)

**Uses:** STACK.md accent variant approach (predefined hex values, not HSL rotation)

**Implements:** FEATURES.md "Pre-built accent variants" and "Expanded wallpaper collection"

**Avoids:** PITFALLS.md Pitfall 5 (contrast verification with WCAG 4.5:1 against `#000000` for each variant)

### Phase 5: CLI Accent Tool (v2+)

**Rationale:** The CLI tool is a genuine differentiator but high complexity — it requires knowing which static files to update, handling the Hyprland `rgb()` format conversion, and calling `omarchy-theme-set` to regenerate everything else. Phase 3 (color traceability) must be complete first so the CLI knows exactly which files to patch. This is correctly deferred to v2+ until the community validates demand.

**Delivers:** `clawmarchy-accent` Bash script; named preset support (purple/teal/blue/rose/gold/green); hex validation; reload-all command for applying changes without logout

**Uses:** STACK.md CLI tool pattern (Bash + sed, named preset map, thin wrapper delegating to `omarchy-theme-set`)

**Implements:** ARCHITECTURE.md Pattern 2 (Thin CLI Wrapper) and Pattern 4 (Named Color Presets)

**Avoids:** PITFALLS.md UX pitfalls (backup before modification, --dry-run flag, reload command)

### Phase Ordering Rationale

- Phase 1 must precede Phase 2 because the opacity catch-all interferes with Waybar/Mako layer surfaces
- Phase 2 must precede Phase 3 because the traceability audit needs to know which new static override files were added
- Phase 3 must precede Phase 4 because accent variants require knowing which files to update per-variant
- Phase 3 must precede Phase 5 because the CLI tool's file update map comes from the traceability audit
- Phase 4 can precede Phase 5 because manual variants validate the demand before building automation

### Research Flags

Phases likely needing deeper research during planning:
- **Phase 5 (CLI tool):** The exact mechanism for icon theme switching per accent (Yaru-purple-dark vs Yaru-blue-dark) needs verification — does `omarchy-theme-set` handle this or does the CLI need to modify icons.theme?
- **Phase 4 (accent variants):** Need to verify whether variants should be separate git repositories (like community themes) or branches of the main repo — Omarchy's theme discovery mechanism determines this

Phases with well-documented patterns (can skip research-phase):
- **Phase 1 (opacity fix):** Hyprland window rule syntax is well-documented; the fix is straightforward
- **Phase 2 (component coverage):** Template generation is fully understood; CSS color definitions are trivial
- **Phase 3 (color traceability):** Grep + comment writing; no technical unknowns

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | All stack decisions verified against live Omarchy scripts on local system, official manual, and GitHub source. Template variable format confirmed from source code. |
| Features | HIGH | Feature landscape derived from direct inspection of 5+ community themes and official Omarchy template system. Competitor matrix based on actual file inspection. |
| Architecture | HIGH | Two-track system verified from omarchy-theme-set-templates source code. Static override precedence verified via existing hyprland.conf comment. One MEDIUM area: whether `.tpl` user overrides in `~/.config/omarchy/themed/` take precedence over theme-level static files needs testing. |
| Pitfalls | HIGH | All critical pitfalls verified against Omarchy GitHub issues, Hyprland wiki, and codebase analysis. The opacity + layer surface issue was confirmed by checking Hyprland's `layerrule` documentation. |

**Overall confidence:** HIGH

### Gaps to Address

- **Walker static override decision:** Research recommends starting with template generation for Walker, then adding a static override if AMOLED-specific styling (e.g., accent-colored border) is needed. The exact CSS selector for border color in Walker's default theme needs confirmation during Phase 2 implementation.
- **User-level `.tpl` override precedence:** Architecture research notes uncertainty about whether user-level `.tpl` files in `~/.config/omarchy/themed/` override theme-level static files or vice versa. Not blocking for Phases 1-3 (we use static overrides, not `.tpl` files), but relevant for future theme hook integration.
- **Icon theme per accent variant:** Whether accent variants need manual `icons.theme` updates (Yaru-purple-dark -> Yaru-blue-dark) or if this can be automated through Omarchy's theme system is unresolved. Address during Phase 4 planning.
- **VS Code workspace color completeness:** The full set of VS Code color tokens needed for AMOLED compliance (~20 tokens) was not enumerated in research. Requires manual testing during Phase 2.

## Sources

### Primary (HIGH confidence)
- Omarchy `omarchy-theme-set` and `omarchy-theme-set-templates` scripts — live system inspection; template engine mechanics and override precedence
- Omarchy default templates at `~/.local/share/omarchy/default/themed/*.tpl` — confirmed variable format and generated output
- Omarchy base configs (`~/.config/waybar/style.css`, `~/.config/walker/config.toml`, `~/.local/share/omarchy/default/mako/core.ini`) — confirmed import structure and CSS selectors
- Omarchy v3.3.0 release notes — template system introduction and windowrule migration warnings
- Omarchy GitHub Issue #327 — DHH's decision to keep component CSS files separate for theme flexibility
- Omarchy PR #2808 — semantic waybar color variables (`@theme-red`, `@theme-yellow`, `@theme-green`)
- Omarchy Issue #4237 — color drift problem documented in built-in themes during template refactor
- Omarchy Theme Manual (learn.omacom.io) — official theme creation conventions and file naming
- Hyprland Window Rules Wiki — `layerrule` vs `windowrule`, `override` keyword, opacity multiplication behavior
- WCAG 2.1 contrast requirements — accent variant contrast validation standard

### Secondary (MEDIUM confidence)
- Cobalt2 Theme (hoblin/omarchy-cobalt2-theme) — reference comprehensive community theme for feature completeness comparison
- Ash Theme (bjarneo/omarchy-ash-theme) — reference community theme
- Dracula Theme (guibes/omarchy-dracula-theme) — reference community theme
- Omarchy Theme Management DeepWiki — architecture overview (community documentation, not official)
- Hyprland 0.53 syntax change community reports — windowrule format migration evidence
- Walker theming wiki — Walker CSS theming documentation
- HANCORE Sapphire Theme and RetroPC Theme — community themes demonstrating full static override approach

### Tertiary (LOW confidence)
- Omarchy theme-hook system (breakshit.blog) — runtime theme application; relevant only for Phase 5+ features

---
*Research completed: 2026-02-18*
*Ready for roadmap: yes*
