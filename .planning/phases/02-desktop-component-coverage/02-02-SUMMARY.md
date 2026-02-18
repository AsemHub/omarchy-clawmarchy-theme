---
phase: 02-desktop-component-coverage
plan: 02
subsystem: ui
tags: [mako, hyprlock, chromium, ini, hyprland-conf, notifications, lock-screen, browser]

# Dependency graph
requires:
  - phase: 01-hyprland-foundation-fix
    provides: layerrule directives ensuring no blur/opacity interference with component theming
provides:
  - Mako notification theme with AMOLED black and urgency-based border color differentiation
  - Hyprlock lock screen color variables and accent-colored clock widget with wallpaper dimming
  - Chromium AMOLED black RGB triplet for browser toolbar policy
affects: [03-traceability-and-variant-support, 05-documentation-and-polish]

# Tech tracking
tech-stack:
  added: []
  patterns: [mako-ini-urgency-criteria, hyprlock-variable-plus-widget, hyprlock-overlay-dimming, chromium-rgb-triplet]

key-files:
  created: [mako.ini, hyprlock.conf, chromium.theme]
  modified: []

key-decisions:
  - "Mako border-size=3 full border as closest approximation to left-edge stripe (mako limitation)"
  - "Hyprlock wallpaper dimming via additive background block with rgba(0,0,0,0.45) overlay"
  - "Clock widget at 120px font size positioned 200px above center for visual prominence"

patterns-established:
  - "Mako urgency criteria: [urgency=X] sections after global defaults for per-priority border colors"
  - "Hyprlock overlay dimming: additional background {} block with semi-transparent color and no path"
  - "Chromium theme: single-line RGB triplet consumed by omarchy-theme-set-browser"

requirements-completed: [COMP-04, COMP-06, COMP-07]

# Metrics
duration: 1min
completed: 2026-02-18
---

# Phase 2 Plan 2: Mako/Hyprlock/Chromium Theme Summary

**AMOLED black Mako notifications with urgency-differentiated borders, Hyprlock lock screen with accent clock and 45% wallpaper dimming, and Chromium true-black toolbar triplet**

## Performance

- **Duration:** 1 min
- **Started:** 2026-02-18T20:15:56Z
- **Completed:** 2026-02-18T20:17:25Z
- **Tasks:** 2
- **Files created:** 3

## Accomplishments
- Mako notification theme with AMOLED black background and three urgency levels (accent/yellow/red borders)
- Hyprlock lock screen with 5 color variables, semi-transparent overlay for ~45% wallpaper dimming, and large 120px accent-colored clock
- Chromium browser theme with AMOLED true black RGB triplet (0,0,0) for toolbar policy

## Task Commits

Each task was committed atomically:

1. **Task 1: Create Mako notification theme with urgency-based border colors** - `827d600` (feat)
2. **Task 2: Create Hyprlock lock screen theme and Chromium browser theme** - `9cd6b1e` (feat)

## Files Created/Modified
- `mako.ini` - Mako notification INI config with core.ini include, AMOLED black, and urgency criteria sections
- `hyprlock.conf` - Hyprlock color variables, dimming overlay background block, and accent clock label widget
- `chromium.theme` - Single-line AMOLED black RGB triplet (0,0,0) for Chromium browser policy

## Decisions Made
- Used `border-size=3` full border as closest mako-native approximation to locked left-edge stripe decision (mako does not support per-side borders)
- Documented mako text-color limitation: single `text-color` applies to all text elements, so accent-colored app name is not achievable natively
- Implemented Hyprlock wallpaper dimming via additive `background {}` block with `rgba(0,0,0, 0.45)` and no `path` directive (overlay only)
- Clock widget positioned at `0, 200` (centered horizontally, 200px above center) with 120px font and shadow for depth

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Three static override files complete and committed to theme repo root
- Mako urgency criteria pattern established for future notification customization
- Hyprlock overlay dimming pattern available if other components need similar approach
- Remaining Phase 2 plans (01: Waybar/Walker/SwayOSD CSS, 03: VS Code JSON) can proceed independently

## Self-Check: PASSED

All files verified present. All commits verified in git log.

---
*Phase: 02-desktop-component-coverage*
*Completed: 2026-02-18*
