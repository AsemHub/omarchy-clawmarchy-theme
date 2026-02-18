# Phase 1: Hyprland Foundation Fix - Research

**Researched:** 2026-02-18
**Domain:** Hyprland window rules and layer rules for opacity/transparency control
**Confidence:** HIGH

## Summary

Phase 1 replaces a single global opacity catch-all rule (`windowrule = opacity 1.0 1.0, match:class .*`) in `hyprland.conf` with targeted window rules and dedicated layer rules. The current rule overrides ALL windows and layer surfaces to full opacity, which achieves the AMOLED true black goal but prevents Phase 2+ from theming layer surfaces (Waybar, Mako, SwayOSD, Walker) independently.

The fix has two distinct parts: (1) replacing the global `windowrule` catch-all with a targeted default that uses the `override` keyword and allows functional transparency exceptions, and (2) adding `layerrule` directives for each layer surface (Waybar, Mako, SwayOSD, Walker) to control their blur and animation independently of window opacity rules. Hyprland does NOT support setting opacity on layer surfaces via `layerrule` -- layer surface opacity is controlled by the application itself (via CSS background-color alpha or INI config). The `layerrule` directives control compositor-level effects (blur, animations, xray) only.

**Primary recommendation:** Keep a targeted `windowrule = opacity 1.0 override 1.0 override, match:class .*` as the default catch-all (using `override` to prevent multiplicative stacking with Omarchy's default 0.97/0.9 rule), then add `layerrule = no_anim on, match:namespace ...` style rules to explicitly control compositor effects on layer surfaces. Layer surface opacity (making Waybar/Mako solid black) is handled by their own CSS/INI configs in Phase 2, not by Hyprland rules in Phase 1.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

#### Window opacity targets
- All known GUI apps forced to full opacity (1.0) -- terminals, browsers, editors, file managers, image viewers, media players
- No exceptions for aesthetic transparency -- every window app gets solid AMOLED black
- Rule targeting approach: Claude's discretion (specific window classes vs broader patterns, based on current config and Omarchy defaults)

#### Layer surface treatment
- Waybar: fully opaque AMOLED black (#000000), no transparency, no blur
- Mako notifications: fully opaque AMOLED black, no transparency, no blur
- SwayOSD (volume/brightness popups): fully opaque AMOLED black
- Walker (app launcher): fully opaque AMOLED black
- No blur effects on any layer surface -- pure solid black everywhere
- Layer surfaces must use dedicated layerrule directives, not window opacity rules

#### Default behavior for unlisted apps
- Smart catch-all approach: default rule makes everything opaque, with explicit exceptions only for apps that functionally need transparency (color pickers, screen capture tools, etc.)
- Not a comprehensive list -- a catch-all with carve-outs for functional need only
- Include a commented example in config showing how users can add their own transparency exceptions
- No aesthetic exceptions -- only apps that break without transparency get exempted

### Claude's Discretion
- Exact window class targeting strategy (per-class vs pattern matching)
- Which specific apps qualify for functional transparency exceptions
- layerrule syntax and ordering
- Config file organization and comment style

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| FNDTN-01 | Hyprland opacity uses targeted window class rules instead of global catch-all, so transparency-dependent apps and layer surfaces work correctly | Fully supported: research confirms `windowrule = opacity 1.0 override 1.0 override, match:class .*` with `override` keyword replaces Omarchy's multiplicative 0.97/0.9 default. Functional exceptions use `negative:` regex prefix or separate rules with lower opacity. |
| FNDTN-02 | Hyprland uses `layerrule` for layer surfaces (Waybar, notifications) instead of `windowrule` | Fully supported: research confirms `layerrule` uses `match:namespace` to target layer surfaces by name. Available actions: `blur`, `no_anim`, `xray`, `dim_around`, `animation`, `order`, `above_lock`, `ignore_alpha`, `no_screen_share`. Opacity is NOT a layerrule action -- layer opacity is controlled by the application's own config. |
</phase_requirements>

## Standard Stack

### Core

This phase modifies a single file (`hyprland.conf`) using Hyprland's native configuration syntax. No libraries or external tools are involved.

| Technology | Version | Purpose | Why Standard |
|------------|---------|---------|--------------|
| Hyprland config syntax | 0.53+ (current) | Window rules (`windowrule`) and layer rules (`layerrule`) | Omarchy v3.3.0+ requires this syntax; old `windowrulev2` syntax is deprecated and causes parse errors |
| `hyprctl` CLI | Ships with Hyprland | Runtime verification of rules, clients, layers | Official tool for inspecting compositor state |

### Supporting

| Tool | Purpose | When to Use |
|------|---------|-------------|
| `hyprctl clients` | List all open windows with their class names | Verify window rules match intended targets |
| `hyprctl layers` | List all layer surfaces with their namespaces | Discover exact namespace strings for layerrule targeting |
| `hyprctl reload` | Reload Hyprland config without restart | Test rule changes live |
| `hyprctl getoption decoration:active_opacity` | Check effective opacity settings | Verify override keyword prevents multiplicative stacking |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Catch-all `match:class .*` with override | Per-app rules for every known class | Catch-all is simpler and covers unlisted apps; per-app would miss new apps installed later |
| Anonymous rules (one-line) | Named rule blocks | Named rules allow runtime enable/disable via `hyprctl keyword`, but add verbosity for simple opacity rules; anonymous is sufficient here |

## Architecture Patterns

### Recommended Config Structure

The `hyprland.conf` theme override file should be organized in this order:

```
hyprland.conf
  |-- Section 1: Border Colors (existing FX-02)
  |-- Section 2: Window Opacity Rules (FNDTN-01)
  |     |-- Default catch-all: full opacity with override
  |     |-- Functional transparency exceptions (commented examples)
  |-- Section 3: Layer Surface Rules (FNDTN-02)
  |     |-- Waybar layer rules
  |     |-- Mako layer rules
  |     |-- SwayOSD layer rules
  |     |-- Walker layer rules
  |-- Section 4: Visual Effects (existing FX-02 - blur, shadows, animations)
```

### Pattern 1: Override Keyword for Opacity

**What:** Use `override` after each opacity value to set absolute opacity instead of multiplying with Omarchy's default 0.97/0.9 rule.

**When to use:** Always, for every opacity rule in the theme. Without `override`, Hyprland multiplies all matching opacity rules together (e.g., 1.0 * 0.97 = 0.97, or worse 0.97 * 0.9 = 0.873).

**Example:**
```conf
# Source: Omarchy issue #2285, Hyprland wiki, Omarchy discussion #3124
# WITHOUT override: opacity = rule_value * default_value (multiplicative)
# WITH override: opacity = rule_value (absolute, ignores other rules)
windowrule = opacity 1.0 override 1.0 override, match:class .*
```

The format is: `opacity <active> [override] <inactive> [override] [<fullscreen> [override]]`
- First value = active window opacity
- Second value = inactive window opacity
- Third value (optional) = fullscreen window opacity
- `override` after each value makes it absolute instead of multiplicative

**Confidence: HIGH** -- Verified via Omarchy issue #2285 (closed Feb 2026 with fix applied), Omarchy discussion #3124, and Hyprland wiki documentation.

### Pattern 2: Layer Rules with match:namespace

**What:** Use `layerrule` with `match:namespace` to target layer surfaces by their Wayland namespace string.

**When to use:** For all layer surfaces that need compositor-level control (blur, animation, rendering order).

**Example:**
```conf
# Source: Hyprland wiki, Hyprland discussion #12778
# Anonymous layerrule (one-line):
layerrule = blur off, match:namespace waybar

# Block-style layerrule (multiple properties):
layerrule {
    name = waybar-no-effects
    match:namespace = waybar
    blur = off
    no_anim = on
}
```

Common layer namespaces in Omarchy:
- `waybar` -- status bar
- `mako` -- notification daemon (verify with `hyprctl layers`)
- `swayosd` or `gtk-layer-shell` -- OSD popups (verify with `hyprctl layers`)
- `walker` -- app launcher (verify with `hyprctl layers`)

**Confidence: MEDIUM** -- Namespace strings need runtime verification with `hyprctl layers`. The exact namespace for SwayOSD and Walker may differ from expected.

### Pattern 3: Functional Transparency Exceptions

**What:** After the catch-all opacity rule, add specific rules for apps that functionally require transparency (not aesthetic preference).

**When to use:** For apps like color pickers, screen capture region selectors, or overlay tools that break without alpha compositing.

**Example:**
```conf
# Default: everything fully opaque for AMOLED black
windowrule = opacity 1.0 override 1.0 override, match:class .*

# Exception: color pickers need transparency to sample screen colors
# windowrule = opacity unset, match:class ^(hyprpicker)$
# windowrule = opacity unset, match:class ^(gcolor3)$
```

The `unset` keyword removes a previously applied rule for matching windows.

**Confidence: MEDIUM** -- The `unset` keyword for opacity needs verification. Alternative approach: set specific non-1.0 values for exception apps. The exact list of apps that functionally need transparency is an implementation decision.

### Anti-Patterns to Avoid

- **Using windowrule for layer surfaces:** Layer surfaces (Waybar, Mako, SwayOSD) are NOT windows. `windowrule` opacity rules do not reliably target them. Use `layerrule` exclusively for layer surface control.
- **Omitting the `override` keyword:** Without `override`, Hyprland multiplies opacity values. Theme rule of 1.0 * Omarchy default of 0.97 = 0.97, which causes the gray wash the rule is trying to prevent.
- **Using old `windowrulev2` syntax:** Deprecated since Hyprland 0.48, causes parse errors on 0.53+. Use `windowrule` with `match:class` syntax.
- **Setting opacity via layerrule:** `layerrule` does not support an `opacity` action. Layer surface opacity must be controlled by the application's own configuration (CSS `background-color` alpha, INI `background-color` alpha).
- **Regex without anchors in exceptions:** Use `^(classname)$` for exact matches to prevent partial matching (e.g., `firefox` would also match `firefox-developer-edition` if not anchored).

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Discovering window class names | Guessing class names from app names | `hyprctl clients \| grep class` on running windows | Class names are often unexpected (e.g., `com.mitchellh.ghostty` not `ghostty`, `org.gnome.Nautilus` not `nautilus`) |
| Discovering layer namespaces | Guessing namespace strings | `hyprctl layers` on running desktop | Namespaces vary by toolkit and configuration |
| Testing opacity values | Editing config and restarting Hyprland | `hyprctl keyword windowrule "opacity 0.5 override 0.5 override, match:class .*"` for live testing | Live keyword injection tests rules without restart; `hyprctl reload` applies config changes |
| Converting old rule syntax | Manual rewriting | Hyprland 0.53 windowrule converter tool at `https://itsohen.github.io/hyprrulefix/` | Handles edge cases in regex escaping and property renaming |

**Key insight:** The runtime verification tools (`hyprctl clients`, `hyprctl layers`, `hyprctl reload`) are essential for this phase. Never assume class names or layer namespaces -- always verify on a running system.

## Common Pitfalls

### Pitfall 1: Multiplicative Opacity Stacking

**What goes wrong:** Omarchy's default `windows.conf` sets `windowrule = opacity 0.97 0.9, match:class .*`. If the theme adds its own `windowrule = opacity 1.0 1.0, match:class .*` without `override`, Hyprland multiplies them: 1.0 * 0.97 = 0.97 active, 1.0 * 0.9 = 0.9 inactive. The windows appear slightly transparent despite the theme rule saying 1.0.

**Why it happens:** Hyprland's opacity system is multiplicative by design. All matching opacity rules are multiplied together unless `override` is used.

**How to avoid:** Always use `override` after each opacity value: `windowrule = opacity 1.0 override 1.0 override, match:class .*`

**Warning signs:** Windows appear very slightly transparent instead of pure black. A gray wash is visible when dragging windows over the wallpaper. `#000000` backgrounds render as `~#0D0D0D`.

**Confidence: HIGH** -- Verified via Omarchy issue #2285 (confirmed and fixed Feb 2026).

### Pitfall 2: Layer Surfaces Not Affected by Window Rules

**What goes wrong:** Adding `windowrule = opacity 1.0 override, match:class .*` and expecting it to make Waybar/Mako opaque. Layer surfaces exist in a different rendering layer than windows and may not be targeted by `windowrule` at all (or may be affected unpredictably).

**Why it happens:** Wayland separates "windows" (XDG surfaces) from "layer surfaces" (wlr-layer-shell protocol). Waybar, Mako, SwayOSD, and Walker are layer surfaces, not windows. Hyprland provides `layerrule` specifically for this.

**How to avoid:** Use `layerrule` with `match:namespace` for all layer surface control. Never rely on `windowrule` for layer surfaces.

**Warning signs:** Waybar/Mako appearance doesn't change when windowrule opacity is modified. `hyprctl clients` does not list Waybar or Mako (they appear in `hyprctl layers` instead).

**Confidence: HIGH** -- This is the fundamental architectural distinction in Wayland compositors.

### Pitfall 3: Incorrect Layer Namespace Strings

**What goes wrong:** Writing `layerrule = blur off, match:namespace mako` when the actual namespace is `notifications` or `mako-notifications`. The rule silently does nothing.

**Why it happens:** Layer namespaces are set by the application, not by any standard. They can be anything the developer chose. They also vary across versions and configurations.

**How to avoid:** Always verify namespaces with `hyprctl layers` on a running system before writing rules. Include a comment in the config noting the verified namespace.

**Warning signs:** Layer rules appear to have no effect. `hyprctl layers` output doesn't match the namespace in the rule.

**Confidence: HIGH** -- This is a well-documented issue in the Hyprland community.

### Pitfall 4: Hyprland Syntax Version Mismatch

**What goes wrong:** Using old `windowrulev2` syntax or old action names (e.g., `noanim` instead of `no_anim on`, `noborder` instead of `no_border on`). Config fails to parse on Hyprland 0.53+.

**Why it happens:** Hyprland 0.53 (shipped with Omarchy v3.3.0) completely overhauled rule syntax. Old syntax was removed, not just deprecated.

**How to avoid:** Use only the 0.53+ syntax:
- `windowrule` not `windowrulev2`
- `match:class` not `class:`
- Boolean actions use `on`/`off` suffix: `no_blur on`, `no_border on`, `no_anim on`
- Verify with `hyprctl reload` after any config change

**Warning signs:** `hyprctl reload` produces parse errors. Hyprland log shows "invalid option" or "unknown rule" warnings.

**Confidence: HIGH** -- Verified via Omarchy issue #4115, issue #4023, and multiple community reports.

### Pitfall 5: layerrule Opacity Is Not a Thing

**What goes wrong:** Attempting `layerrule = opacity 1.0, match:namespace waybar` -- this is not a valid layerrule action. Hyprland will ignore or error.

**Why it happens:** Feature request #4267 for layerrule opacity was closed as "not planned." The Hyprland developers' position is that layer applications should control their own opacity via their native config.

**How to avoid:** For Phase 1, the `layerrule` directives handle compositor effects (blur off, animation control). The actual AMOLED black opacity for Waybar/Mako is achieved in Phase 2 by setting their CSS/INI `background-color` to `#000000` (fully opaque). Phase 1's layerrules establish the foundation; Phase 2's component configs deliver the visual result.

**Warning signs:** N/A -- just don't attempt it.

**Confidence: HIGH** -- Verified via Hyprland issue #4267.

## Code Examples

Verified patterns from official sources and Omarchy codebase:

### Current Config (What We're Replacing)

```conf
# Current hyprland.conf line 25:
windowrule = opacity 1.0 1.0, match:class .*
```

Problems:
1. No `override` keyword -- opacity multiplies with Omarchy's 0.97/0.9 default
2. Targets everything including layer surfaces (unpredictable behavior)
3. No mechanism for functional transparency exceptions

### Recommended Window Opacity Rules

```conf
# Source: Omarchy issue #2285, Hyprland wiki, Omarchy discussion #3124
# ---------------------------------------------------------------
# Window Opacity (FNDTN-01)
# Override Omarchy's default 0.97/0.9 opacity for true AMOLED black.
# The 'override' keyword sets absolute opacity, preventing
# multiplicative stacking with the base config.
# ---------------------------------------------------------------
windowrule = opacity 1.0 override 1.0 override, match:class .*

# ---------------------------------------------------------------
# Transparency Exceptions
# Apps that functionally require transparency to work correctly.
# To add your own exceptions, copy the pattern below:
#   windowrule = opacity <active> override <inactive> override, match:class ^(app-class)$
# Find app class names with: hyprctl clients | grep class
# ---------------------------------------------------------------
# windowrule = opacity unset, match:class ^(hyprpicker)$
```

### Recommended Layer Surface Rules

```conf
# Source: Hyprland wiki, verified syntax from discussion #12778
# ---------------------------------------------------------------
# Layer Surface Rules (FNDTN-02)
# Layer surfaces (status bars, notifications, popups, launchers)
# use layerrule, not windowrule. Opacity for these surfaces is
# controlled by each app's own config (CSS/INI), not by Hyprland.
# These rules control compositor effects only.
# Verify namespaces with: hyprctl layers
# ---------------------------------------------------------------

# Waybar -- no blur, no special effects (AMOLED solid black)
layerrule = blur off, match:namespace waybar

# Mako notifications -- no blur (AMOLED solid black)
layerrule = blur off, match:namespace mako

# SwayOSD volume/brightness popups -- no blur
# NOTE: verify actual namespace with hyprctl layers
layerrule = blur off, match:namespace swayosd

# Walker app launcher -- no blur
# NOTE: verify actual namespace with hyprctl layers
layerrule = blur off, match:namespace walker
```

### Omarchy's Default Opacity Rule (What We Override)

```conf
# From: ~/.local/share/omarchy/default/hypr/windows.conf
# Source: github.com/basecamp/omarchy/blob/master/default/hypr/windows.conf
windowrule = opacity 0.97 0.9, match:class .*
```

This is the rule that causes gray wash on AMOLED black. It sets 97% active and 90% inactive opacity on ALL windows. Our `override` keyword in the theme rule supersedes this.

### Omarchy's Browser Opacity Rules (Reference)

```conf
# From: ~/.local/share/omarchy/default/hypr/apps/browser.conf
# Source: github.com/basecamp/omarchy/blob/master/default/hypr/apps/browser.conf
windowrule = opacity 1 0.97, match:tag chromium-based-browser
windowrule = opacity 1 0.97, match:tag firefox-based-browser
windowrule = opacity 1.0 1.0, match:initial_title ((?i)(?:[a-z0-9-]+\.)*youtube\.com_/|app\.zoom\.us_/wc/home)
```

Note: Omarchy already handles browser-specific opacity. Our catch-all with `override` will supersede these, which is the desired behavior for AMOLED black.

### Hyprland Config Load Order

```conf
# From: github.com/basecamp/omarchy/blob/master/config/hypr/hyprland.conf
# Load order determines override precedence:
source = ~/.local/share/omarchy/default/hypr/windows.conf   # 1. Default 0.97/0.9 opacity
source = ~/.config/omarchy/current/theme/hyprland.conf       # 2. Theme overrides (OUR FILE)
source = ~/.config/hypr/looknfeel.conf                       # 3. User overrides (last wins)
```

Theme rules in `hyprland.conf` are loaded AFTER Omarchy defaults, so our rules take precedence. The `override` keyword provides additional safety against multiplicative stacking.

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `windowrulev2 = opacity 1.0 1.0, class:^(.*)$` | `windowrule = opacity 1.0 override 1.0 override, match:class .*` | Hyprland 0.48-0.53 (2024-2025) | Must use new syntax; `override` keyword prevents multiplicative stacking |
| No layerrule (layer surfaces uncontrolled) | `layerrule = blur off, match:namespace waybar` | Hyprland 0.40+ | Dedicated layer control separate from window rules |
| `noanim` as action name | `no_anim on` (boolean toggle) | Hyprland 0.53 | All boolean actions now use `on`/`off` suffix |
| `ignorealpha` as action name | `ignore_alpha <value>` | Hyprland 0.53 | Renamed with value parameter |

**Deprecated/outdated:**
- `windowrulev2`: Completely removed in Hyprland 0.53. Use `windowrule` with `match:` syntax.
- `class:` prefix without `match:`: Old syntax. Use `match:class` in the new format.
- `noanim`, `noborder`, `noblur`: Renamed to `no_anim on`, `no_border on`, `no_blur on`.

## Critical Discovery: Layer Opacity Cannot Be Set via layerrule

Hyprland's `layerrule` does NOT support an `opacity` action. Issue #4267 requested this feature but was closed as "not planned." The developers stated that layer applications should control their own opacity.

**Impact on Phase 1:** The `layerrule` directives in this phase can only control compositor effects (blur, animations, etc.) -- they cannot make Waybar/Mako backgrounds opaque. Making these surfaces AMOLED black requires setting `background-color: #000000` in their own config files (waybar.css, mako.ini), which is Phase 2 work.

**What Phase 1 DOES accomplish for layers:** Disabling blur ensures no background bleed-through on layer surfaces. This is the compositor-side foundation. Phase 2 completes the picture with application-side solid black backgrounds.

**Confidence: HIGH** -- Verified via Hyprland GitHub issue #4267.

## Discretion Recommendations

### Window Class Targeting Strategy

**Recommendation: Keep the catch-all, use `override` keyword.**

Rationale:
1. Omarchy's `windows.conf` already applies `opacity 0.97 0.9, match:class .*` as a catch-all
2. Omarchy's `apps/terminals.conf` tags terminals (`Alacritty|kitty|com.mitchellh.ghostty`) and `apps/browser.conf` tags browsers
3. Adding per-class rules for every known app would be fragile and miss newly installed apps
4. A catch-all `opacity 1.0 override 1.0 override, match:class .*` with the `override` keyword achieves the same goal more robustly
5. The `override` keyword makes per-class rules unnecessary -- it forces absolute opacity regardless of other rules

The per-class approach would only be needed if some windows should remain semi-transparent for aesthetic reasons. Since the user decision explicitly says "no exceptions for aesthetic transparency," the catch-all with override is the correct approach.

### Functional Transparency Exceptions

**Recommendation: Include commented-out examples only; do not add active exceptions.**

Apps that may need transparency:
- `hyprpicker` -- Hyprland's built-in color picker (samples screen colors through transparent overlay)
- `gcolor3` / `gpick` -- GTK color pickers
- `slurp` -- screen region selector (used by screenshot tools)
- `grim` with `slurp` -- screenshot capture workflow

However, these tools generally work fine even at full opacity because they capture the compositor's output, not what's visible through their own window. The exception mechanism exists for edge cases, not for a known list.

**Recommendation:** Include commented examples showing the syntax pattern, but leave all exceptions commented out. Users can uncomment or add their own if they encounter a specific app that breaks.

### layerrule Syntax and Ordering

**Recommendation: Anonymous one-line rules, one per layer surface.**

Rationale:
- Named rule blocks add verbosity without benefit for simple "blur off" rules
- One rule per namespace is clear and easy to modify
- Rules should appear after window rules in the config for logical grouping
- Include a comment with `hyprctl layers` as the discovery command

### Config File Organization

**Recommendation: Four clearly commented sections.**

```
1. Border Colors (existing, unchanged)
2. Window Opacity Rules (new, FNDTN-01)
3. Layer Surface Rules (new, FNDTN-02)
4. Visual Effects (existing, unchanged -- blur/shadows/animations)
```

Each section gets a comment header block matching the existing style in `hyprland.conf`:
```conf
# ----------------------------------------------------------
# Section Name (REQ-ID)
# Explanation of what this section does and why
# ----------------------------------------------------------
```

## Open Questions

1. **Exact layer namespaces for SwayOSD and Walker**
   - What we know: Waybar uses `waybar`, Mako likely uses `mako` as namespace
   - What's unclear: SwayOSD might use `swayosd`, `gtk-layer-shell`, or something else. Walker might use `walker` or its GTK layer namespace.
   - Recommendation: Verify with `hyprctl layers` on the running system during implementation. Add a verification step to the plan.

2. **Does `opacity unset` work for exceptions?**
   - What we know: `unset` is documented as removing a previously applied rule value
   - What's unclear: Whether `opacity unset` properly reverts to Omarchy's default behavior or removes opacity entirely
   - Recommendation: Test during implementation. Alternative: use explicit lower opacity values like `opacity 0.95 override 0.9 override` for exceptions instead of `unset`.

3. **Interaction between theme catch-all and Omarchy's per-app rules**
   - What we know: Hyprland processes rules top-to-bottom, last match wins. Theme loads after Omarchy defaults. `override` prevents multiplication.
   - What's unclear: Whether Omarchy's browser-specific rules (`opacity 1 0.97, match:tag chromium-based-browser`) would still apply after our catch-all override
   - Recommendation: The catch-all with `override` should supersede all previous rules for all windows. This is the desired behavior. Verify by checking browser opacity after applying the theme.

## Sources

### Primary (HIGH confidence)
- Omarchy `windows.conf` default config: https://github.com/basecamp/omarchy/blob/master/default/hypr/windows.conf -- verified the default `opacity 0.97 0.9` catch-all rule
- Omarchy `hyprland.conf` main config: https://github.com/basecamp/omarchy/blob/master/config/hypr/hyprland.conf -- verified config load order (defaults -> theme -> user)
- Omarchy `apps/browser.conf`: https://github.com/basecamp/omarchy/blob/master/default/hypr/apps/browser.conf -- verified browser opacity handling with tags
- Omarchy `apps/terminals.conf`: https://github.com/basecamp/omarchy/blob/master/default/hypr/apps/terminals.conf -- verified terminal class tagging (`Alacritty|kitty|com.mitchellh.ghostty`)
- Omarchy issue #2285 (opacity misconfiguration): https://github.com/basecamp/omarchy/issues/2285 -- confirmed multiplicative opacity bug and `override` fix
- Omarchy discussion #3124 (OVERRIDE keyword): https://github.com/basecamp/omarchy/discussions/3124 -- confirmed `override` as the correct approach for opacity corrections
- Omarchy issue #4115 (v3.3.0 syntax errors): https://github.com/basecamp/omarchy/issues/4115 -- confirmed 0.53 syntax migration requirements
- Hyprland issue #4267 (layerrule opacity): https://github.com/hyprwm/Hyprland/issues/4267 -- confirmed opacity is NOT available as a layerrule action

### Secondary (MEDIUM confidence)
- Hyprland wiki Window Rules: https://wiki.hypr.land/Configuring/Window-Rules/ -- official docs (content loaded via search results, not direct fetch due to JS rendering)
- DeepWiki Hyprland Layer Rules: https://deepwiki.com/hyprwm/hyprland-wiki/3.4-window-rules -- comprehensive layer rule reference with actions table
- DeepWiki dots-hyprland rules: https://deepwiki.com/end-4/dots-hyprland/4.1-window-rules-and-layer-rules -- practical windowrule and layerrule examples
- Hyprland discussion #12778 (layerrule syntax): https://github.com/hyprwm/Hyprland/discussions/12778 -- confirmed `match:namespace` syntax for 0.53+
- DankLinux-Docs issue #38 (deprecated syntax): https://github.com/AvengeMedia/DankLinux-Docs/issues/38 -- before/after syntax examples for 0.53 migration
- DeepWiki Omarchy Hyprland config: https://deepwiki.com/basecamp/omarchy/4.1-hyprland-configuration -- three-layer config architecture
- RetroPC theme (reference): https://github.com/rondilley/omarchy-retropc-theme -- community theme showing minimal hyprland.conf override pattern
- Cobalt2 theme (reference): https://github.com/hoblin/omarchy-cobalt2-theme -- community theme showing border-only override pattern

### Tertiary (LOW confidence)
- Hyprland 0.53 converter tool: https://forum.hypr.land/t/0-53-window-layerrule-converter/1243 -- community converter for syntax migration

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- Hyprland config syntax is well-documented and verified against Omarchy's actual default files
- Architecture: HIGH -- Config load order verified from Omarchy source, `override` keyword verified from issue #2285 resolution
- Pitfalls: HIGH -- All pitfalls verified against real Omarchy issues and Hyprland discussions
- Layer rules: MEDIUM -- Syntax verified but exact namespace strings for SwayOSD/Walker need runtime verification
- Transparency exceptions: MEDIUM -- `unset` keyword needs testing; commented-out approach avoids risk

**Research date:** 2026-02-18
**Valid until:** 2026-03-18 (30 days -- Hyprland config syntax is stable post-0.53 migration)
