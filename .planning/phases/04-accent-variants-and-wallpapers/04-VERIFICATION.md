---
phase: 04-accent-variants-and-wallpapers
verified: 2026-02-19T20:30:00Z
status: gaps_found
score: 5/7 must-haves verified
re_verification: false
gaps:
  - truth: "Wallpaper collection contains at least 10 curated anime wallpapers"
    status: failed
    reason: "User deliberately replaced original 5 wallpapers with 5 new Gemini-generated ones instead of adding alongside them. Total is 5, not 10. This satisfies ASST-02 (dark atmospheric scenes working with any accent) but fails ASST-01 (at least 10 wallpapers) and ROADMAP Success Criterion 3."
    artifacts:
      - path: "backgrounds/"
        issue: "Contains 5 PNG files (1-sakura through 5-moss), not 10. The plan expected 6-10 added alongside 1-5 originals."
    missing:
      - "Either restore the 5 original wallpapers alongside the 5 new ones, OR update ROADMAP/REQUIREMENTS to formally reflect the accepted deviation (change ASST-01 to 5+ and SC3 to 5+). The deviation is documented in SUMMARY but not in REQUIREMENTS.md (ASST-01 still shows [x] Complete, which is inaccurate against its own definition)."
  - truth: "Variant installation follows a documented, straightforward process (VAR-05 / SC4)"
    status: partial
    reason: "The clawmarchy-variant script self-documents via --list and is self-explanatory. However, README.md contains no mention of variant switching -- a user reading only the README would not know the clawmarchy-variant script exists. VAR-05 requires 'documented with clear instructions'; the README is the primary user-facing documentation."
    artifacts:
      - path: "README.md"
        issue: "No section for accent variants, no mention of clawmarchy-variant script, no usage example. Features list still describes the theme as 'neon purple accents' only."
    missing:
      - "Add an 'Accent Variants' section to README.md documenting: available variants, the clawmarchy-variant <name> command, and the --list flag. This is a lightweight fix (5-10 lines)."
human_verification:
  - test: "Open each of the 5 wallpapers and verify they are dark atmospheric anime scenes, not accent-saturated"
    expected: "70-80% dark/black tones; accent color present but subtle; no text or watermarks; anime art style"
    why_human: "Cannot programmatically verify visual quality, style, or tone distribution of PNG images"
  - test: "Run clawmarchy-variant sakura from a directory other than the repo root (e.g., from /tmp) and verify it copies to the correct theme location"
    expected: "Files copied to the directory where clawmarchy-variant lives (SCRIPT_DIR resolution), not to /tmp"
    why_human: "SCRIPT_DIR dirname resolution requires live execution in a real Omarchy install path"
---

# Phase 4: Accent Variants and Wallpapers Verification Report

**Phase Goal:** Users can choose from at least 3 pre-built accent color alternatives beyond the default purple, each with verified contrast and consistent theming, alongside an expanded wallpaper collection
**Verified:** 2026-02-19T20:30:00Z
**Status:** gaps_found
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths (from ROADMAP Success Criteria)

| #  | Truth | Status | Evidence |
|----|-------|--------|---------|
| 1  | At least 3 accent variants installable alongside default purple, each with colors.toml and btop.theme | VERIFIED | 5 variants (sakura, ocean, tide, ember, moss) + yoru restore; each has 9 config files including colors.toml and btop.theme |
| 2  | Every accent variant passes WCAG 4.5:1 contrast against #000000 | VERIFIED | Computed ratios: yoru 4.72, sakura 7.52, ocean 6.16, tide 8.71, ember 7.53, moss 7.65 — all pass |
| 3  | Wallpaper collection contains at least 10 curated anime wallpapers | FAILED | Only 5 wallpapers exist in backgrounds/ (user replaced originals instead of adding) |
| 4  | Variant installation follows a documented, straightforward process | PARTIAL | Script self-documents via --list; README has no mention of clawmarchy-variant |
| 5  | 5 new accent variant directories exist with 9 config files each | VERIFIED | All 6 directories confirmed (5 new + yoru); each has exactly 9 files |
| 6  | No leftover default purple in non-purple variant files | VERIFIED | 0 matches in sakura/ocean/tide/ember; moss has exactly 1 exception (btop.theme temp_mid, documented) |
| 7  | Users can switch variants with a single command | VERIFIED | clawmarchy-variant script: executable, validates input, copies files, runs omarchy-theme-set |

**Score:** 5/7 truths verified (1 failed, 1 partial)

---

## Required Artifacts

### Plan 04-01 Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `variants/sakura/` | Pink accent (#D4839B), 9 config files | VERIFIED | 9 files confirmed; accent present in all 9 files in all 4 formats |
| `variants/ocean/` | Blue accent (#5B8EC9), 9 config files | VERIFIED | 9 files confirmed; accent present across all files |
| `variants/tide/` | Teal accent (#5AB5B5), 9 config files | VERIFIED | 9 files confirmed |
| `variants/ember/` | Orange accent (#D4895A), 9 config files | VERIFIED | 9 files confirmed |
| `variants/moss/` | Green accent (#6EA88E), 9 config files | VERIFIED | 9 files confirmed; temp_mid exception documented |
| `variants/yoru/` | Default purple restore point, 9 config files | VERIFIED | Byte-identical to root colors.toml and btop.theme; 23 occurrences of #7B6CBD as expected |

### Plan 04-02 Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `clawmarchy-variant` | Executable shell script for variant switching | VERIFIED | Executable; set -euo pipefail; SCRIPT_DIR resolution; --list; input validation; cp + omarchy-theme-set |
| `backgrounds/1-sakura-cherry-blossoms.png` | Sakura variant wallpaper | VERIFIED | PNG 2816x1536, 7.5 MB |
| `backgrounds/2-ocean-midnight-harbor.png` | Ocean variant wallpaper | VERIFIED | PNG 2816x1536, 7.2 MB |
| `backgrounds/3-tide-underwater-shrine.png` | Tide variant wallpaper | VERIFIED | PNG 2816x1536, 6.9 MB |
| `backgrounds/4-ember-lantern-festival.png` | Ember variant wallpaper | VERIFIED | PNG 2816x1536, 8.9 MB |
| `backgrounds/5-moss-forest-shrine.png` | Moss variant wallpaper | VERIFIED | PNG 2816x1536, 9.3 MB |
| `backgrounds/6-sakura-cherry-blossoms.png` | Sakura wallpaper (plan expected 6-10) | MISSING | User replaced originals; files are numbered 1-5, not 6-10 |
| `backgrounds/qhd/1-sakura-cherry-blossoms.png` | Sakura QHD downscale | VERIFIED | PNG 2560x1396 (aspect-preserving from 2816x1536 source) |
| `backgrounds/qhd/2-ocean-midnight-harbor.png` | Ocean QHD downscale | VERIFIED | PNG 2560x1396 |
| `backgrounds/qhd/3-tide-underwater-shrine.png` | Tide QHD downscale | VERIFIED | PNG 2560x1396 |
| `backgrounds/qhd/4-ember-lantern-festival.png` | Ember QHD downscale | VERIFIED | PNG 2560x1396 |
| `backgrounds/qhd/5-moss-forest-shrine.png` | Moss QHD downscale | VERIFIED | PNG 2560x1396 |

---

## Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `variants/*/colors.toml` | `colors.toml` | accent + selection_background values replaced | VERIFIED | `accent = "#D4839B"` (sakura), `#5B8EC9` (ocean), `#5AB5B5` (tide), `#D4895A` (ember), `#6EA88E` (moss) |
| `variants/*/btop.theme` | `btop.theme` | hi_fg, selected_fg, proc_misc, cpu_box, mem_box, net_box, proc_box replaced | VERIFIED | All 7 accent-role keys confirmed per variant; Moss temp_mid intentionally kept at #7B6CBD |
| `variants/*/hyprland.conf` | `hyprland.conf` | rgb() format replacement | VERIFIED | e.g., `rgb(D4839B)` in sakura |
| `variants/*/hyprlock.conf` | `hyprlock.conf` | decimal RGB rgba() replacement | VERIFIED | e.g., `rgba(212,131,155, 1.0)` in sakura (3 occurrences) |
| `variants/*/vscode.json` | `vscode.json` | alpha-appended hex (#RRGGBBAA) replacement | VERIFIED | e.g., `#D4839B40` and `#D4839B30` in sakura |
| `clawmarchy-variant` | `variants/*` | copies variant config files to theme root | VERIFIED | Line 45: `cp "$VARIANT_DIR"/* "$SCRIPT_DIR/"` |
| `clawmarchy-variant` | `omarchy-theme-set` | runs theme application after file copy | VERIFIED | Line 50: `omarchy-theme-set clawmarchy` |

---

## Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|-------------|-------------|--------|---------|
| VAR-01 | 04-01 | At least 3 pre-built accent variants alongside default purple | SATISFIED | 5 variants delivered (sakura, ocean, tide, ember, moss) |
| VAR-02 | 04-01 | Each variant includes modified colors.toml with different accent and selection_background | SATISFIED | Confirmed in all 5 non-yoru variants; accent and selection_background replaced |
| VAR-03 | 04-01 | Each variant includes re-crafted btop.theme gradient mapping | SATISFIED | 7 accent-role keys replaced per variant; Moss temp_mid exception handled correctly |
| VAR-04 | 04-01 | Each variant's accent passes WCAG 4.5:1 against #000000 | SATISFIED | All 6 accents verified: 4.72-8.71:1 ratios |
| VAR-05 | 04-02 | Variant installation documented with clear instructions | PARTIAL | clawmarchy-variant --list self-documents; README.md has no mention of variant switching or the script |
| ASST-01 | 04-02 | Wallpaper collection expanded to at least 10 curated anime wallpapers | BLOCKED | Only 5 wallpapers exist. User deliberately replaced originals rather than adding. REQUIREMENTS.md marks this [x] Complete but its own definition ("at least 10") is unmet. |
| ASST-02 | 04-02 | New wallpapers are dark atmospheric scenes working aesthetically with any accent | HUMAN NEEDED | 5 large-filesize PNG files confirmed (7-9 MB each, 2816x1536). Visual quality requires human verification. |

---

## Accepted Deviations (User-Directed)

The following deviations from the plan were explicitly accepted by the user before this verification:

| Deviation | Plan Said | Actual | Accepted? |
|-----------|-----------|--------|-----------|
| Wallpaper count | 10 (add 5 new alongside 5 originals, numbered 6-10) | 5 (replace all 5 originals with 5 new, numbered 1-5) | Yes |
| Wallpaper resolution | 4K (3840x2160) | 2816x1536 (Gemini Pro generation limit) | Yes |
| QHD dimensions | 2560x1440 (forced) | 2560x1396 (aspect-preserving) | Yes |

These deviations are documented in 04-02-SUMMARY.md. REQUIREMENTS.md and ROADMAP.md Success Criteria have not been updated to reflect the accepted count change (ASST-01 still states "at least 10").

---

## Anti-Patterns Found

| File | Pattern | Severity | Impact |
|------|---------|----------|--------|
| `README.md` | No mention of clawmarchy-variant, accent variants, or variant switching process | Warning | Users cannot discover variant switching from README; VAR-05 partially unmet |
| `README.md` | Features section still describes "5 curated anime wallpapers — dark atmospheric scenes with purple/cyan tones" — accurate count but implies purple-only theming | Info | Outdated framing; variants are not mentioned |
| `REQUIREMENTS.md` | ASST-01 marked `[x]` Complete but its definition ("at least 10") is unmet by 5 | Warning | Requirements tracking is inaccurate; misleads future contributors |

No stub implementations, empty handlers, or placeholder code found in any variant config files or the clawmarchy-variant script.

---

## Human Verification Required

### 1. Wallpaper Visual Quality

**Test:** Open each of the 5 wallpaper files in an image viewer:
- `backgrounds/1-sakura-cherry-blossoms.png`
- `backgrounds/2-ocean-midnight-harbor.png`
- `backgrounds/3-tide-underwater-shrine.png`
- `backgrounds/4-ember-lantern-festival.png`
- `backgrounds/5-moss-forest-shrine.png`

**Expected:** Each image is a dark atmospheric anime scene. 70-80% of the image area is near-black or very dark. Accent tones (pink, blue, teal, orange, green respectively) are present but subtle — lantern glow, water reflections, bioluminescence, etc. No watermarks, text overlays, or AI generation artifacts. Art style consistent with anime illustration aesthetic.

**Why human:** PNG pixel analysis cannot determine style, tone distribution, or aesthetic quality.

### 2. Variant Switching End-to-End (on live Omarchy install)

**Test:** From an Omarchy installation with Clawmarchy installed at `~/.config/omarchy/themes/clawmarchy/`, run: `clawmarchy-variant sakura`

**Expected:** Files from `variants/sakura/` are copied to the theme root. `omarchy-theme-set clawmarchy` runs and applies the sakura accent across the desktop (Waybar, Hyprland borders, Walker, btop, etc.). No errors.

**Why human:** SCRIPT_DIR dirname resolution works correctly only in a live install path; cannot test omarchy-theme-set in isolation.

---

## Gaps Summary

Two gaps block full goal achievement:

**Gap 1 — Wallpaper count (ASST-01):** The plan called for 10 wallpapers; 5 exist. The user deliberately replaced the original 5 with 5 new Gemini-generated ones. The core value (dark atmospheric anime wallpapers paired to each variant) is satisfied. The gap is a count mismatch between the requirement as written and what was delivered. Resolution options: (a) restore/add 5 more wallpapers to reach 10, or (b) update REQUIREMENTS.md and ROADMAP.md to formally reflect the accepted deviation (change "at least 10" to "5 variant-paired"). The second option requires only documentation changes.

**Gap 2 — Variant documentation in README (VAR-05 partial):** The clawmarchy-variant script has a --list mode and inline usage text, which is functional self-documentation. However, VAR-05 requires "documented with clear instructions" and the README — the primary user-facing entry point — has no mention of accent variants or the switching script. A user following only the README cannot discover this feature. This is a small, bounded fix: add an "Accent Variants" section to README.md.

Both gaps are lightweight to close. Gap 2 in particular is a 10-line README addition. Gap 1 requires a scope decision from the user.

---

_Verified: 2026-02-19T20:30:00Z_
_Verifier: Claude (gsd-verifier)_
