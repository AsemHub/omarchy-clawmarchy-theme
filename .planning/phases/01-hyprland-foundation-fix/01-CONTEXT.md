# Phase 1: Hyprland Foundation Fix - Context

**Gathered:** 2026-02-18
**Status:** Ready for planning

<domain>
## Phase Boundary

Replace the global opacity catch-all in Hyprland config with targeted window and layer rules. Opacity and transparency must work correctly for all window types and layer surfaces, unblocking component theming in Phase 2+. No new components are themed here — this is strictly the opacity/transparency foundation.

</domain>

<decisions>
## Implementation Decisions

### Window opacity targets
- All known GUI apps forced to full opacity (1.0) — terminals, browsers, editors, file managers, image viewers, media players
- No exceptions for aesthetic transparency — every window app gets solid AMOLED black
- Rule targeting approach: Claude's discretion (specific window classes vs broader patterns, based on current config and Omarchy defaults)

### Layer surface treatment
- Waybar: fully opaque AMOLED black (#000000), no transparency, no blur
- Mako notifications: fully opaque AMOLED black, no transparency, no blur
- SwayOSD (volume/brightness popups): fully opaque AMOLED black
- Walker (app launcher): fully opaque AMOLED black
- No blur effects on any layer surface — pure solid black everywhere
- Layer surfaces must use dedicated layerrule directives, not window opacity rules

### Default behavior for unlisted apps
- Smart catch-all approach: default rule makes everything opaque, with explicit exceptions only for apps that functionally need transparency (color pickers, screen capture tools, etc.)
- Not a comprehensive list — a catch-all with carve-outs for functional need only
- Include a commented example in config showing how users can add their own transparency exceptions
- No aesthetic exceptions — only apps that break without transparency get exempted

### Claude's Discretion
- Exact window class targeting strategy (per-class vs pattern matching)
- Which specific apps qualify for functional transparency exceptions
- layerrule syntax and ordering
- Config file organization and comment style

</decisions>

<specifics>
## Specific Ideas

- The current global catch-all is the root problem — it forces everything opaque including layer surfaces, which breaks Waybar/Mako theming
- User wants an "opaque by default, exceptions by need" philosophy — the theme should be AMOLED black everywhere unless an app functionally requires transparency
- Config should be self-documenting: include a commented example for adding custom transparency exceptions

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-hyprland-foundation-fix*
*Context gathered: 2026-02-18*
