---
phase: 01-hyprland-foundation-fix
plan: 01
subsystem: compositor
tags: [hyprland, opacity, layerrule, amoled, wayland]

# Dependency graph
requires: []
provides:
  - "Override-based window opacity catch-all (FNDTN-01) preventing gray wash"
  - "Layer surface blur-off rules for Waybar, Mako, SwayOSD, Walker (FNDTN-02)"
  - "Separation of window rules from layer rules at compositor level"
affects: [02-waybar-theming, 03-mako-theming, 04-swayosd-walker-theming]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "override keyword for absolute opacity (prevents multiplicative stacking)"
    - "layerrule with match:namespace for per-surface compositor control"

key-files:
  created: []
  modified:
    - "hyprland.conf"

key-decisions:
  - "Used catch-all with override instead of per-class rules -- covers all apps including future installs"
  - "Commented-out transparency exceptions only -- no active exceptions since all apps work at full opacity"
  - "blur off as sole layerrule action -- no opacity (unsupported) or no_anim (orthogonal to Phase 1 scope)"

patterns-established:
  - "Section comment blocks with requirement IDs (FNDTN-01, FNDTN-02) for traceability"
  - "Inline hyprctl verification commands in config comments for runtime debugging"

requirements-completed: [FNDTN-01, FNDTN-02]

# Metrics
duration: 1min
completed: 2026-02-18
---

# Phase 1 Plan 01: Hyprland Foundation Fix Summary

**Override-based window opacity catch-all and dedicated layerrule directives separating window control from layer surface control for AMOLED true black**

## Performance

- **Duration:** 1 min
- **Started:** 2026-02-18T19:12:32Z
- **Completed:** 2026-02-18T19:13:53Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Replaced global opacity catch-all with `override` keyword to prevent multiplicative stacking with Omarchy's 0.97/0.9 default -- all windows now render at absolute 1.0 opacity
- Added 4 dedicated `layerrule` directives (Waybar, Mako, SwayOSD, Walker) controlling compositor blur independently from window rules
- Included self-documenting transparency exception examples and runtime verification commands in config comments

## Task Commits

Each task was committed atomically:

1. **Task 1: Replace global opacity catch-all with override-based targeted rule and transparency exceptions** - `479bc7f` (feat)
2. **Task 2: Add layerrule directives for all layer surfaces** - `39b2cef` (feat)

## Files Created/Modified
- `hyprland.conf` - Hyprland compositor theme override with window opacity rules (FNDTN-01) and layer surface rules (FNDTN-02)

## Decisions Made
- Used catch-all `match:class .*` with `override` instead of per-class rules -- simpler, covers all current and future apps, matches user's "opaque by default" philosophy
- Transparency exceptions are commented-out examples only (hyprpicker, slurp) -- no active exceptions needed since these tools work at full opacity
- `blur off` is the only layerrule action -- `opacity` is not a valid layerrule action (Hyprland issue #4267), and `no_anim` is orthogonal to Phase 1's opacity/transparency scope
- SwayOSD and Walker namespaces are best-guess from documentation; config comments note to verify with `hyprctl layers`

## Deviations from Plan
None - plan executed exactly as written.

## Issues Encountered
None.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Window opacity foundation complete: all windows render at absolute 1.0 opacity on AMOLED black
- Layer surface compositor effects (blur) disabled: Waybar, Mako, SwayOSD, Walker ready for application-side theming in Phase 2+
- Layer surface opacity (making backgrounds solid #000000) requires Phase 2 CSS/INI changes -- `layerrule` cannot control this
- SwayOSD and Walker namespace strings should be verified on a running system with `hyprctl layers` before Phase 4

## Self-Check: PASSED

- hyprland.conf: FOUND
- 01-01-SUMMARY.md: FOUND
- Commit 479bc7f (Task 1): FOUND
- Commit 39b2cef (Task 2): FOUND

---
*Phase: 01-hyprland-foundation-fix*
*Completed: 2026-02-18*
