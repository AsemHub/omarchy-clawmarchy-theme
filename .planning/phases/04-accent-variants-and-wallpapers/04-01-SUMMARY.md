---
phase: 04-accent-variants-and-wallpapers
plan: 01
subsystem: ui
tags: [color-variants, wcag, accent-swap, config-generation]

# Dependency graph
requires:
  - phase: 03-color-system-traceability
    provides: "COLORS.md traceability reference and inline annotations identifying all accent locations"
provides:
  - "6 variant directories (sakura, ocean, tide, ember, moss, yoru) with 9 config files each"
  - "WCAG 4.5:1 verified accent colors across all variants"
  - "Yoru restore-point directory with identical root file copies"
affects: [04-02, variant-switching-script]

# Tech tracking
tech-stack:
  added: []
  patterns: [accent-substitution-in-4-formats, moss-temp-mid-gradient-exception]

key-files:
  created:
    - variants/sakura/ (9 config files)
    - variants/ocean/ (9 config files)
    - variants/tide/ (9 config files)
    - variants/ember/ (9 config files)
    - variants/moss/ (9 config files)
    - variants/yoru/ (9 config files)
  modified: []

key-decisions:
  - "Moss btop.theme temp_mid reset to default purple -- hue 153 below cyan 189 breaks cool-to-warm gradient"
  - "Generation script deleted after run -- one-time tool not shipped as artifact"
  - "Replacement order: alpha-appended first, then hex, then strip, then decimal RGB to prevent partial matches"

patterns-established:
  - "4-format accent substitution: hex (#RRGGBB), strip (RRGGBB), decimal RGB (R,G,B), alpha-appended (#RRGGBBAA)"
  - "Variant directory structure: variants/<name>/ containing 9 accent-dependent config files"

requirements-completed: [VAR-01, VAR-02, VAR-03, VAR-04]

# Metrics
duration: 3min
completed: 2026-02-19
---

# Phase 4 Plan 1: Accent Variant Config Generation Summary

**6 WCAG-verified accent variants (sakura, ocean, tide, ember, moss) plus yoru restore point, each with 9 config files across 4 accent formats**

## Performance

- **Duration:** 3 min
- **Started:** 2026-02-19T19:00:00Z
- **Completed:** 2026-02-19T19:03:20Z
- **Tasks:** 2
- **Files created:** 54

## Accomplishments
- Generated 54 config files (6 variants x 9 files) with correct accent substitution in all 4 formats
- All 6 accent colors pass WCAG 4.5:1 contrast against #000000 (ratios: 4.72 to 8.71)
- Zero leftover default purple in non-purple variants (Moss btop.theme temp_mid is the documented exception)
- Yoru directory contains byte-identical copies of root config files for variant restore
- Cross-variant consistency verified: accent hex appears in all expected locations across all 9 files per variant

## Task Commits

Each task was committed atomically:

1. **Task 1: Generate all variant config files via Python substitution script** - `01dadac` (feat)
2. **Task 2: WCAG contrast verification and comprehensive accent audit** - verification only, no file changes

## Files Created/Modified
- `variants/sakura/` - Pink accent (#D4839B) variant, 9 config files
- `variants/ocean/` - Blue accent (#5B8EC9) variant, 9 config files
- `variants/tide/` - Teal accent (#5AB5B5) variant, 9 config files
- `variants/ember/` - Orange accent (#D4895A) variant, 9 config files
- `variants/moss/` - Green accent (#6EA88E) variant, 9 config files
- `variants/yoru/` - Default purple (#7B6CBD) restore point, 9 config files

## Decisions Made
- Moss btop.theme temp_mid reset to default purple (#7B6CBD) after global accent replacement -- Moss hue (153) sits below cyan start (189) on the hue wheel, breaking the cool-to-warm temperature gradient
- Generation and verification scripts deleted after execution -- one-time tools, not shipped artifacts
- Replacement order: alpha-appended strings first (#7B6CBD40, #7B6CBD30), then hash-prefixed (#7B6CBD), then strip (7B6CBD), then decimal RGB (123,108,189) to prevent partial match corruption
- vscode.json _comment_accent updated per variant to reflect the new accent hex and alpha values

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- All 6 variant directories ready for the variant-switching script (Plan 04-02)
- Yoru restore point enables `clawmarchy-variant yoru` to restore defaults
- WCAG verification confirms all accents are accessible

## Self-Check: PASSED

All 6 variant directories found with 9 files each. Commit 01dadac verified. SUMMARY.md exists.

---
*Phase: 04-accent-variants-and-wallpapers*
*Completed: 2026-02-19*
