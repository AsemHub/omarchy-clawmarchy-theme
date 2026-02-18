---
phase: 01-hyprland-foundation-fix
verified: 2026-02-18T21:00:00Z
status: passed
score: 4/4 must-haves verified
re_verification: false
---

# Phase 1: Hyprland Foundation Fix — Verification Report

**Phase Goal:** Hyprland opacity and transparency work correctly for all window types and layer surfaces, unblocking component theming in subsequent phases
**Verified:** 2026-02-18T21:00:00Z
**Status:** passed
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths

| #  | Truth                                                                                                                                                       | Status     | Evidence                                                                                                                         |
|----|-------------------------------------------------------------------------------------------------------------------------------------------------------------|------------|----------------------------------------------------------------------------------------------------------------------------------|
| 1  | All windows display at full opacity (1.0) via the `override` keyword, preventing gray wash from Omarchy's default 0.97/0.9 multiplier                       | VERIFIED   | `hyprland.conf` line 25: `windowrule = opacity 1.0 override 1.0 override, match:class .*`                                       |
| 2  | Layer surfaces (Waybar, Mako, SwayOSD, Walker) have blur disabled via dedicated `layerrule` directives, not `windowrule`                                    | VERIFIED   | `hyprland.conf` lines 51-54: four `layerrule = blur off, match:namespace <surface>` lines, zero `layerrule = opacity` lines      |
| 3  | Config includes commented transparency exception examples showing users how to carve out apps that functionally need transparency                             | VERIFIED   | Lines 36-39: template pattern comment + commented `hyprpicker` and `slurp` exceptions; line 33: `hyprctl clients` discovery hint |
| 4  | The old catch-all rule (`opacity 1.0 1.0` without `override`) is replaced, not duplicated                                                                  | VERIFIED   | Grep for `opacity 1.0 1.0` in `hyprland.conf`: zero matches. Exactly one active `windowrule = opacity` line (line 25, with `override`) |

**Score:** 4/4 truths verified

---

### Required Artifacts

| Artifact        | Expected                                                  | Status     | Details                                                                                                  |
|-----------------|-----------------------------------------------------------|------------|----------------------------------------------------------------------------------------------------------|
| `hyprland.conf` | Targeted window opacity rules and layer surface rules     | VERIFIED   | File exists (90 lines). Contains `opacity 1.0 override 1.0 override` catch-all and 4 `layerrule` directives. Substantive — no stubs, no placeholders. Committed in two atomic commits: `479bc7f` (Task 1) and `39b2cef` (Task 2). |

**Wiring (Level 3):** `hyprland.conf` is a static Hyprland config file loaded by Omarchy's compositor config chain (`~/.local/share/omarchy/default/hypr/windows.conf` → `~/.config/omarchy/current/theme/hyprland.conf`). The file itself IS the wired artifact — no import/usage check in code is applicable. The override keyword is the mechanical link that supersedes Omarchy's default 0.97/0.9 rule.

---

### Key Link Verification

| From              | To                                           | Via                                                         | Status   | Details                                                                                                                                      |
|-------------------|----------------------------------------------|-------------------------------------------------------------|----------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `hyprland.conf`   | Omarchy default `windows.conf`               | `override` keyword superseding 0.97/0.9 opacity catch-all  | WIRED    | Line 25: `windowrule = opacity 1.0 override 1.0 override, match:class .*` — pattern confirmed present, no old non-override rule exists       |
| `hyprland.conf`   | Waybar, Mako, SwayOSD, Walker layer surfaces | `layerrule` directives targeting each by namespace          | WIRED    | Lines 51-54: all four surfaces targeted. No `layerrule = opacity` (invalid action) found. Section header documents `hyprctl layers` for runtime namespace verification. |

---

### Requirements Coverage

| Requirement | Source Plan   | Description                                                                                                   | Status    | Evidence                                                                                                                                  |
|-------------|---------------|---------------------------------------------------------------------------------------------------------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------|
| FNDTN-01    | 01-01-PLAN.md | Hyprland opacity uses targeted window class rules instead of global catch-all, so transparency-dependent apps and layer surfaces work correctly | SATISFIED | `hyprland.conf` line 25: override-keyword catch-all replaces old non-override rule. Section header labeled FNDTN-01. REQUIREMENTS.md marks as Complete. |
| FNDTN-02    | 01-01-PLAN.md | Hyprland uses `layerrule` for layer surfaces (Waybar, notifications) instead of `windowrule`                  | SATISFIED | `hyprland.conf` lines 51-54: four `layerrule = blur off, match:namespace` directives. No `windowrule` targeting layer surfaces. REQUIREMENTS.md marks as Complete. |

**Orphaned requirements check:** REQUIREMENTS.md traceability table maps only FNDTN-01 and FNDTN-02 to Phase 1. No additional Phase 1 requirements exist in REQUIREMENTS.md. No orphans.

---

### Anti-Patterns Found

| File            | Line | Pattern                  | Severity | Impact                         |
|-----------------|------|--------------------------|----------|--------------------------------|
| `hyprland.conf` | —    | None found               | —        | No TODOs, no stubs, no empty implementations, no console.log-only handlers. Config is substantive and complete for phase scope. |

---

### Human Verification Required

The following items cannot be verified programmatically and require a running Hyprland session to confirm:

#### 1. Override keyword prevents gray wash at runtime

**Test:** Open any window (terminal, browser, file manager) on an AMOLED black wallpaper. Drag the window slowly over the wallpaper edge.
**Expected:** Window background renders as pure `#000000`. No gray wash or slight transparency visible. Background color behind the window is not lightened.
**Why human:** Multiplicative opacity stacking is a compositor runtime effect. File inspection confirms the `override` syntax is correct, but actual rendering depends on Hyprland's rule evaluation order at runtime.

#### 2. Layer surface blur is actually disabled

**Test:** With Waybar, Mako, SwayOSD, and Walker running, observe whether any blur/frosted-glass compositor effect appears behind their backgrounds.
**Expected:** No blur behind any of the four surfaces. Backgrounds appear as solid color (whatever the app's own CSS/INI sets), not blurred.
**Why human:** `layerrule` namespace matching depends on the actual namespace string each app registers at runtime. SwayOSD and Walker namespaces are best-guess from documentation; config comments note to verify with `hyprctl layers`.

#### 3. SwayOSD and Walker namespace strings are correct

**Test:** Run `hyprctl layers` while SwayOSD OSD is visible (trigger a volume change) and while Walker launcher is open. Check the `namespace` field in the output.
**Expected:** SwayOSD appears as namespace `swayosd`; Walker appears as namespace `walker`.
**Why human:** The RESEARCH.md explicitly flags SwayOSD and Walker namespaces as MEDIUM confidence — "best-guess from documentation." The config includes verification comments, but runtime confirmation is needed before Phase 4.

---

### Gaps Summary

No gaps. All four must-have truths are verified against the actual codebase. Both required artifacts exist, are substantive, and are wired correctly. Both requirement IDs (FNDTN-01, FNDTN-02) are satisfied with evidence in `hyprland.conf`. No anti-patterns detected. No orphaned requirements.

The three human verification items above are runtime/visual checks that cannot be confirmed from static file inspection. They do not block phase completion — the config syntax is correct and the patterns are verified against Hyprland 0.53+ documentation — but should be confirmed on a live system before treating Phase 1 as production-ready.

---

_Verified: 2026-02-18T21:00:00Z_
_Verifier: Claude (gsd-verifier)_
