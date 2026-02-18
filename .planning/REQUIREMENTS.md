# Requirements: Clawmarchy Theme

**Defined:** 2026-02-18
**Core Value:** Every visible element on an Omarchy desktop is consistently themed with AMOLED true black and the user's chosen accent color — no gray wash, no mismatched apps, no manual config editing.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Foundation

- [x] **FNDTN-01**: Hyprland opacity uses targeted window class rules instead of global catch-all, so transparency-dependent apps and layer surfaces work correctly
- [x] **FNDTN-02**: Hyprland uses `layerrule` for layer surfaces (Waybar, notifications) instead of `windowrule`
- [x] **FNDTN-03**: Color hex values in all static override files have source comments mapping them to their colors.toml key names

### Component Coverage

- [x] **COMP-01**: Waybar status bar themed with AMOLED black background and accent colors via custom `waybar.css` override
- [x] **COMP-02**: Waybar includes semantic color variables (`@theme-red`, `@theme-yellow`, `@theme-green`) for status indicators
- [x] **COMP-03**: Walker app launcher themed with AMOLED black base and accent-colored selection via custom `walker.css` override
- [x] **COMP-04**: Mako notifications themed with AMOLED black background, accent border, and urgency-level color rules via custom `mako.ini` override
- [x] **COMP-05**: SwayOSD volume/brightness popups themed with AMOLED colors via custom `swayosd.css` override
- [x] **COMP-06**: Hyprlock lock screen themed with AMOLED black colors via custom `hyprlock.conf` override
- [x] **COMP-07**: Chromium browser themed with AMOLED black background via `chromium.theme` file

### VS Code

- [x] **VSCE-01**: VS Code vscode.json includes full `workbench.colorCustomizations` with AMOLED black editor, sidebar, terminal, and panel backgrounds
- [x] **VSCE-02**: VS Code workspace colors use accent color for active indicators, borders, and selections

### Color System

- [x] **CLR-01**: All static override files that hardcode hex values include comments documenting which colors.toml key each value corresponds to
- [x] **CLR-02**: Audit identifies which theme files are Omarchy-generated (no maintenance) vs static overrides (must be manually updated when accent changes)
- [ ] **CLR-03**: Audit results documented in a color traceability section in README or dedicated reference

### Accent Variants

- [ ] **VAR-01**: At least 3 pre-built accent color variants ship alongside the default purple (e.g., blue, teal, rose)
- [ ] **VAR-02**: Each variant includes modified colors.toml with different accent and selection_background values
- [ ] **VAR-03**: Each variant includes re-crafted btop.theme gradient mapping for the new accent hue
- [ ] **VAR-04**: Each variant's accent color passes WCAG 4.5:1 contrast ratio against #000000 background
- [ ] **VAR-05**: Variant installation is documented with clear instructions

### Assets

- [ ] **ASST-01**: Wallpaper collection expanded to at least 10 curated anime wallpapers
- [ ] **ASST-02**: New wallpapers are dark atmospheric scenes that work aesthetically with any accent color variant (not tied to purple)
- [ ] **ASST-03**: Preview screenshot (preview.png) updated to reflect full themed desktop with new components

### Documentation

- [ ] **DOC-01**: README documents all themed components with screenshots or descriptions
- [ ] **DOC-02**: README includes troubleshooting section for common issues (opacity, fonts, icon themes)
- [ ] **DOC-03**: README includes customization guide explaining how to change accent colors and wallpapers
- [ ] **DOC-04**: README documents compatibility requirements (Hyprland, Omarchy version, required packages)

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### CLI Tool

- **CLI-01**: `clawmarchy-accent` Bash script allows changing accent color across all configs with a single command
- **CLI-02**: CLI supports named presets (purple, blue, teal, rose, gold, green)
- **CLI-03**: CLI validates hex color input for custom accent values
- **CLI-04**: CLI creates backup before modifying files
- **CLI-05**: CLI includes `--dry-run` flag to preview changes without applying

### Generation System

- **GEN-01**: btop.theme can be generated from colors.toml palette values
- **GEN-02**: neovim.lua background overrides can be generated from colors.toml
- **GEN-03**: All static override files can be regenerated from a single source

### Integration

- **INTG-01**: Theme hook integration via `omarchy-theme-hook` for runtime accent switching without reinstall

## Out of Scope

Explicitly excluded. Documented to prevent scope creep.

| Feature | Reason |
|---------|--------|
| Full palette variants (Dracula, Gruvbox, Nord) | Each is effectively a new theme; dilutes AMOLED identity. Only accent swaps on black base. |
| Dynamic wallpaper-based theming | Aether and Tema already do this. Clawmarchy is a curated theme, not a theme engine. |
| GTK/Qt application theming | Massive rabbit hole with version fragmentation. Omarchy handles GTK via system settings. |
| Animated wallpapers | GPU/battery drain, conflicts with AMOLED power savings, massive repo size. |
| Custom Waybar layout/modules | Layout is personal preference. Theme only styles colors, not structure. |
| Ghostty terminal config | Omarchy auto-generates from colors.toml. No custom override needed. |
| X11/non-Wayland support | Omarchy targets Hyprland/Wayland exclusively. |
| Automated visual regression testing | Manual verification sufficient for theme work. |
| Obsidian.css override | Auto-generated version from colors.toml is already comprehensive. Override only if issues found. |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| FNDTN-01 | Phase 1 | Complete |
| FNDTN-02 | Phase 1 | Complete |
| FNDTN-03 | Phase 3 | Complete |
| COMP-01 | Phase 2 | Complete |
| COMP-02 | Phase 2 | Complete |
| COMP-03 | Phase 2 | Complete |
| COMP-04 | Phase 2 | Complete |
| COMP-05 | Phase 2 | Complete |
| COMP-06 | Phase 2 | Complete |
| COMP-07 | Phase 2 | Complete |
| VSCE-01 | Phase 2 | Complete |
| VSCE-02 | Phase 2 | Complete |
| CLR-01 | Phase 3 | Complete |
| CLR-02 | Phase 3 | Complete |
| CLR-03 | Phase 3 | Pending |
| VAR-01 | Phase 4 | Pending |
| VAR-02 | Phase 4 | Pending |
| VAR-03 | Phase 4 | Pending |
| VAR-04 | Phase 4 | Pending |
| VAR-05 | Phase 4 | Pending |
| ASST-01 | Phase 4 | Pending |
| ASST-02 | Phase 4 | Pending |
| ASST-03 | Phase 5 | Pending |
| DOC-01 | Phase 5 | Pending |
| DOC-02 | Phase 5 | Pending |
| DOC-03 | Phase 5 | Pending |
| DOC-04 | Phase 5 | Pending |

**Coverage:**
- v1 requirements: 27 total
- Mapped to phases: 27
- Unmapped: 0

---
*Requirements defined: 2026-02-18*
*Last updated: 2026-02-18 after roadmap creation*
