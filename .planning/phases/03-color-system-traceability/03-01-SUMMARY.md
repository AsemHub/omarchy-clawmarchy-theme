---
phase: 03-color-system-traceability
plan: 01
subsystem: theme-documentation
tags: [colors.toml, inline-annotations, traceability, AMOLED]

# Dependency graph
requires:
  - phase: 02-desktop-component-coverage
    provides: CSS annotation pattern (/* colors.toml: keyname */), vscode.json _comment pattern
provides:
  - Inline color source annotations on all 10 static override config files
  - Header classification lines identifying maintenance model per file
  - Source-of-truth header on colors.toml
  - Greppable colors.toml: keyname pattern across all file types
  - UNMAPPED flags on 2 neovim.lua values with rationale
affects: [03-02-PLAN, 04-accent-variant-tooling]

# Tech tracking
tech-stack:
  added: []
  patterns: [inline-annotation-per-file-type, line-above-annotation-for-INI, _comment-keys-for-JSON, UNMAPPED-flag-pattern]

key-files:
  created: []
  modified:
    - colors.toml
    - btop.theme
    - hyprland.conf
    - hyprlock.conf
    - mako.ini
    - neovim.lua
    - waybar.css
    - walker.css
    - swayosd.css
    - vscode.json

key-decisions:
  - "Line-above annotation for mako.ini (INI parsers may treat inline # as part of value)"
  - "No comments added to chromium.theme (format restriction: $(<file) captures entire content)"
  - "Section-level grouping for btop.theme box outline colors (4 identical accent values)"
  - "Per-group _comment keys in vscode.json [Tokyo Night] scope (Option B from research)"

patterns-established:
  - "colors.toml: keyname -- greppable annotation pattern for hash/Lua/CSS comment files"
  - "UNMAPPED: rationale -- flag pattern for intentionally unmapped color values"
  - "_comment_* JSON keys -- per-group color source documentation inside JSON objects"
  - "Line-above annotation -- safe annotation for INI files with uncertain inline comment support"

requirements-completed: [FNDTN-03, CLR-01, CLR-02]

# Metrics
duration: 4min
completed: 2026-02-18
---

# Phase 3 Plan 1: Inline Color Annotations Summary

**Inline `colors.toml: keyname` annotations added to all 10 static override files with per-file header classifications and UNMAPPED flags**

## Performance

- **Duration:** 4 min
- **Started:** 2026-02-18T21:00:45Z
- **Completed:** 2026-02-18T21:04:28Z
- **Tasks:** 2
- **Files modified:** 10

## Accomplishments
- 33 btop.theme color values annotated with colors.toml key mappings using section grouping for repeated values
- 7 hyprlock.conf rgba values, 2 hyprland.conf values, 5 mako.ini values, and 4 neovim.lua values annotated
- 2 missing waybar.css tooltip annotations completed; walker.css and swayosd.css headers added
- vscode.json enriched with 4 per-group _comment keys covering all 30 color values by semantic role
- colors.toml given source-of-truth header identifying it as the canonical palette definition
- 2 neovim.lua values flagged as UNMAPPED with rationale (tokyonight-specific dark surfaces)
- All 10 files now have header classification lines stating maintenance model and accent impact

## Task Commits

Each task was committed atomically:

1. **Task 1: Annotate hash-comment config files and colors.toml** - `e7145df` (feat)
2. **Task 2: Annotate vscode.json with _comment keys** - `637be49` (feat)

## Files Created/Modified
- `colors.toml` - Source-of-truth header added
- `btop.theme` - 33 color values annotated with colors.toml key mappings
- `hyprland.conf` - 2 color values annotated (accent border, shadow)
- `hyprlock.conf` - 7 rgba values annotated with palette mappings
- `mako.ini` - 5 color values annotated using line-above format
- `neovim.lua` - 4 values annotated, 2 flagged as UNMAPPED
- `waybar.css` - 2 missing tooltip annotations completed, header added
- `walker.css` - Header classification line added (annotations already complete)
- `swayosd.css` - Header classification line added (annotations already complete)
- `vscode.json` - 4 per-group _comment keys + update classification added

## Decisions Made
- **Mako line-above annotations:** Used line-above format (`# colors.toml: keyname` on the line before the value) instead of inline comments because INI parsers may treat `#` after a value as part of the value string. Safer approach without runtime verification.
- **Chromium.theme skipped:** No comments added because `omarchy-theme-set-browser` reads the file with `$(<file)` which captures entire content including any comment lines, breaking RGB parsing. Will be documented in COLORS.md (Plan 03-02) instead.
- **btop.theme section grouping:** Used section comment `# All use accent color: colors.toml: accent` for the 4 identical box outline colors instead of repeating annotations on each line. Individual annotations used for all other values.
- **vscode.json per-group _comment keys:** Placed _comment keys inside the [Tokyo Night] scope closest to the color values they describe, grouped by semantic role (backgrounds, foregrounds, accent, surfaces).

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- All 10 config files are fully annotated and ready for COLORS.md reference document (Plan 03-02)
- The greppable `colors.toml: keyname` pattern is consistent across all file types
- Chromium.theme documentation deferred to COLORS.md where its format restriction will be noted

## Self-Check: PASSED

All 10 modified files verified present. Both task commits (e7145df, 637be49) verified in git log.

---
*Phase: 03-color-system-traceability*
*Completed: 2026-02-18*
