# Roadmap: Clawmarchy Theme

## Overview

Clawmarchy expands from a partial theme (Hyprland, btop, Neovim, VS Code reference, icons) into a complete, community-ready Omarchy desktop theme with full component coverage, color system traceability, pre-built accent variants, and comprehensive documentation. The work proceeds from fixing a blocking Hyprland regression, through adding missing desktop components, establishing color system discipline, building accent color variants, and finishing with documentation and polish.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Hyprland Foundation Fix** - Replace global opacity catch-all with targeted window and layer rules (completed 2026-02-18)
- [ ] **Phase 2: Desktop Component Coverage** - Theme all visible desktop elements (Waybar, Walker, Mako, SwayOSD, Hyprlock, Chromium, VS Code)
- [x] **Phase 3: Color System Traceability** - Audit and document every hardcoded hex value across all config files (completed 2026-02-18)
- [x] **Phase 4: Accent Variants and Wallpapers** - Ship 3+ pre-built accent color variants and expand wallpaper collection (completed 2026-02-19)
- [ ] **Phase 5: Documentation and Preview** - Comprehensive README with component docs, troubleshooting, customization guide, and updated screenshots

## Phase Details

### Phase 1: Hyprland Foundation Fix
**Goal**: Hyprland opacity and transparency work correctly for all window types and layer surfaces, unblocking component theming in subsequent phases
**Depends on**: Nothing (first phase)
**Requirements**: FNDTN-01, FNDTN-02
**Success Criteria** (what must be TRUE):
  1. Terminals and known applications display at full opacity via targeted window class rules (not a global catch-all)
  2. Layer surfaces (Waybar, notification popups) are not affected by window opacity rules -- they use dedicated layerrule directives
  3. Transparency-dependent applications (file managers, image viewers) are not forced to full opacity by a blanket rule
**Plans**: 1 plan

Plans:
- [ ] 01-01-PLAN.md — Replace global opacity catch-all with override-based window rules and add dedicated layer surface rules

### Phase 2: Desktop Component Coverage
**Goal**: Every visible desktop surface -- status bar, launcher, notifications, volume/brightness popups, lock screen, browser, and editor -- is themed with AMOLED black and accent colors
**Depends on**: Phase 1
**Requirements**: COMP-01, COMP-02, COMP-03, COMP-04, COMP-05, COMP-06, COMP-07, VSCE-01, VSCE-02
**Success Criteria** (what must be TRUE):
  1. Waybar displays with true black background and accent-colored highlights, including semantic color variables for status indicators (red/yellow/green)
  2. Walker app launcher opens with AMOLED black background and accent-colored selection highlighting
  3. Mako notifications appear with AMOLED black background, accent-colored border, and distinct colors for low/normal/critical urgency levels
  4. SwayOSD volume and brightness popups, Hyprlock lock screen, and Chromium browser all display AMOLED black backgrounds consistent with the theme
  5. VS Code shows AMOLED black across editor, sidebar, terminal, and panel backgrounds with accent-colored active indicators and borders
**Plans**: 3 plans

Plans:
- [ ] 02-01-PLAN.md — Waybar, Walker, and SwayOSD GTK CSS theme overrides (AMOLED black + accent)
- [ ] 02-02-PLAN.md — Mako notifications, Hyprlock lock screen, and Chromium browser theme overrides
- [ ] 02-03-PLAN.md — VS Code workbench.colorCustomizations with AMOLED black and accent indicators

### Phase 3: Color System Traceability
**Goal**: Every hardcoded hex value in every theme file is documented with its colors.toml source key, and the boundary between Omarchy-generated and static override files is clearly established
**Depends on**: Phase 2
**Requirements**: FNDTN-03, CLR-01, CLR-02, CLR-03
**Success Criteria** (what must be TRUE):
  1. Every static override file that contains hardcoded hex values has inline comments identifying which colors.toml key each value corresponds to
  2. A documented audit distinguishes which theme files are Omarchy-generated (maintained by the template engine) versus static overrides (must be manually updated when accent changes)
  3. Audit results are published in a reference document accessible to users and future contributors
**Plans**: 2 plans

Plans:
- [ ] 03-01-PLAN.md — Inline color source annotations and file classification headers for all config files
- [ ] 03-02-PLAN.md — COLORS.md reference document with accent change guide and per-file audit

### Phase 4: Accent Variants and Wallpapers
**Goal**: Users can choose from at least 3 pre-built accent color alternatives beyond the default purple, each with verified contrast and consistent theming, alongside an expanded wallpaper collection
**Depends on**: Phase 3
**Requirements**: VAR-01, VAR-02, VAR-03, VAR-04, VAR-05, ASST-01, ASST-02
**Success Criteria** (what must be TRUE):
  1. At least 3 accent variants (e.g., blue, teal, rose) are installable alongside the default purple, each with its own colors.toml and btop.theme gradient mapping
  2. Every accent variant passes WCAG 4.5:1 contrast ratio against #000000 background
  3. Wallpaper collection contains at least 10 curated anime wallpapers that are dark atmospheric scenes working aesthetically with any accent color (not tied to purple)
  4. Variant installation follows a documented, straightforward process
**Plans**: 2 plans

Plans:
- [x] 04-01-PLAN.md — Generate variant config files (5 accents + yoru restore) with WCAG contrast verification
- [x] 04-02-PLAN.md — Variant switching script and wallpaper collection expansion

### Phase 5: Documentation and Preview
**Goal**: Users can understand, install, troubleshoot, and customize the theme through comprehensive documentation, and the preview screenshot reflects the fully themed desktop
**Depends on**: Phase 4
**Requirements**: ASST-03, DOC-01, DOC-02, DOC-03, DOC-04
**Success Criteria** (what must be TRUE):
  1. README documents every themed component with descriptions of what each config file controls
  2. README includes a troubleshooting section covering common issues (opacity problems, missing fonts, icon theme not applying)
  3. README includes a customization guide explaining how to change accent colors and swap wallpapers
  4. README documents compatibility requirements (Hyprland version, Omarchy version, required packages)
  5. Preview screenshot (preview.png) shows the full themed desktop with all new components visible
**Plans**: TBD

Plans:
- [ ] 05-01: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 -> 2 -> 3 -> 4 -> 5

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Hyprland Foundation Fix | 0/1 | Complete    | 2026-02-18 |
| 2. Desktop Component Coverage | 3/3 | Complete | 2026-02-18 |
| 3. Color System Traceability | 0/2 | Complete    | 2026-02-18 |
| 4. Accent Variants and Wallpapers | 2/2 | Complete | 2026-02-19 |
| 5. Documentation and Preview | 0/? | Not started | - |
