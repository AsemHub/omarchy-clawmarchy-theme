---
phase: 04-accent-variants-and-wallpapers
plan: 02
subsystem: ui
tags: [shell-script, wallpaper, imagemagick, gemini-pro, variant-switching]

# Dependency graph
requires:
  - phase: 04-01
    provides: "6 variant config directories under variants/"
provides:
  - "clawmarchy-variant switching script for all 6 accent variants"
  - "5 dark atmospheric anime wallpapers paired to accent variants"
  - "5 QHD downscaled wallpapers in backgrounds/qhd/"
affects: [05-documentation-and-polish]

# Tech tracking
tech-stack:
  added: [imagemagick]
  patterns: [variant-switching-via-script, dual-resolution-wallpapers]

key-files:
  created:
    - clawmarchy-variant
    - backgrounds/1-sakura-cherry-blossoms.png
    - backgrounds/2-ocean-midnight-harbor.png
    - backgrounds/3-tide-underwater-shrine.png
    - backgrounds/4-ember-lantern-festival.png
    - backgrounds/5-moss-forest-shrine.png
    - backgrounds/qhd/1-sakura-cherry-blossoms.png
    - backgrounds/qhd/2-ocean-midnight-harbor.png
    - backgrounds/qhd/3-tide-underwater-shrine.png
    - backgrounds/qhd/4-ember-lantern-festival.png
    - backgrounds/qhd/5-moss-forest-shrine.png
  modified: []

key-decisions:
  - "Wallpaper replacement instead of addition -- user replaced original 5 wallpapers with 5 variant-paired anime scenes (total: 5, not 10)"
  - "Aspect-preserving downscale to 2560x1396 instead of forced 2560x1440 to avoid distortion (source was 2816x1536, not 16:9)"
  - "Wallpapers numbered 1-5 (replacing originals) instead of 6-10 (additive)"

patterns-established:
  - "backgrounds/qhd/ subdirectory for QHD downscales, not read by Omarchy wallpaper cycler"
  - "clawmarchy-variant script copies variant dir to theme root then runs omarchy-theme-set"

requirements-completed: [VAR-05, ASST-01, ASST-02]

# Metrics
duration: 4min
completed: 2026-02-19
---

# Phase 4 Plan 2: Variant Switching and Wallpapers Summary

**Variant switching script with 5 Gemini-generated dark anime wallpapers and QHD downscales via ImageMagick**

## Performance

- **Duration:** 4 min
- **Started:** 2026-02-19T19:53:30Z
- **Completed:** 2026-02-19T19:57:31Z
- **Tasks:** 3
- **Files modified:** 11

## Accomplishments
- Executable `clawmarchy-variant` script supporting all 6 variants (yoru, sakura, ocean, tide, ember, moss) with input validation, list mode, and automatic theme application
- 5 dark atmospheric anime wallpapers generated via Gemini Pro, each paired to an accent variant color
- 5 QHD downscales in backgrounds/qhd/ for dual-resolution shipping

## Task Commits

Each task was committed atomically:

1. **Task 1: Create clawmarchy-variant switching script** - `ce316f1` (feat)
2. **Task 2: Generate wallpapers using Gemini Pro** - `80bfbe3` (feat)
3. **Task 3: Downscale 4K wallpapers to QHD** - `1719985` (feat)

**Plan metadata:** (pending) (docs: complete plan)

## Files Created/Modified
- `clawmarchy-variant` - Shell script for switching between 6 accent variants
- `backgrounds/1-sakura-cherry-blossoms.png` - Sakura variant wallpaper (2816x1536)
- `backgrounds/2-ocean-midnight-harbor.png` - Ocean variant wallpaper (2816x1536)
- `backgrounds/3-tide-underwater-shrine.png` - Tide variant wallpaper (2816x1536)
- `backgrounds/4-ember-lantern-festival.png` - Ember variant wallpaper (2816x1536)
- `backgrounds/5-moss-forest-shrine.png` - Moss variant wallpaper (2816x1536)
- `backgrounds/qhd/1-sakura-cherry-blossoms.png` - Sakura QHD downscale (2560x1396)
- `backgrounds/qhd/2-ocean-midnight-harbor.png` - Ocean QHD downscale (2560x1396)
- `backgrounds/qhd/3-tide-underwater-shrine.png` - Tide QHD downscale (2560x1396)
- `backgrounds/qhd/4-ember-lantern-festival.png` - Ember QHD downscale (2560x1396)
- `backgrounds/qhd/5-moss-forest-shrine.png` - Moss QHD downscale (2560x1396)

## Decisions Made
- **Wallpaper replacement strategy:** User replaced original 5 wallpapers with 5 new Gemini-generated variant-paired anime scenes instead of adding alongside them. Total count is 5, not the planned 10. This was the user's deliberate choice and produces a more cohesive collection where every wallpaper matches a variant.
- **Aspect-preserving downscale:** QHD downscales are 2560x1396 instead of 2560x1440 because Gemini output was 2816x1536 (not strict 16:9). Forcing 2560x1440 would distort the images. Omarchy scales wallpapers to fit regardless.
- **Numbering 1-5:** Wallpapers numbered 1-5 (replacing originals) instead of the planned 6-10 (additive). This is simpler and avoids gaps.

## Deviations from Plan

### User-Directed Changes

**1. Wallpaper replacement instead of addition**
- **Plan specified:** Add 5 new wallpapers numbered 6-10 alongside existing 5, for total of 10
- **Actual:** User replaced all 5 original wallpapers with 5 new ones, numbered 1-5, total of 5
- **Impact:** "Wallpaper collection contains at least 10 images" must-have not met (5 instead of 10), but all 5 wallpapers are variant-paired dark anime scenes as specified
- **Rationale:** User's deliberate creative decision for a more cohesive collection

**2. Resolution below 4K**
- **Plan specified:** Target 3840x2160 wallpapers
- **Actual:** Gemini Pro output at 2816x1536 (native generation limit)
- **Impact:** Minimal -- plan already noted "lower than 4K is still acceptable, Omarchy scales wallpapers"

**3. QHD dimensions adjusted**
- **Plan specified:** Downscale to 2560x1440
- **Actual:** Aspect-preserving downscale to 2560x1396
- **Impact:** None -- avoids distortion, Omarchy fills screen regardless

---

**Total deviations:** 3 (1 user-directed scope change, 2 technical adaptations)
**Impact on plan:** Core deliverables met -- variant switching script works, wallpapers are variant-paired anime scenes, QHD downscales exist. Only the total wallpaper count differs from plan (5 vs 10).

## Issues Encountered
None -- execution was straightforward after the human-action checkpoint.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Phase 4 complete: All 6 accent variants have config directories and a switching script
- 5 variant-paired wallpapers with QHD downscales ready
- Ready for Phase 5: Documentation and Polish

## Self-Check: PASSED

All 11 files verified present. All 3 task commits verified in git log.

---
*Phase: 04-accent-variants-and-wallpapers*
*Completed: 2026-02-19*
