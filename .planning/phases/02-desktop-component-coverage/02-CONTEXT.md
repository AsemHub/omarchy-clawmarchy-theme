# Phase 2: Desktop Component Coverage - Context

**Gathered:** 2026-02-18
**Status:** Ready for planning

<domain>
## Phase Boundary

Theme every visible desktop surface -- Waybar, Walker, Mako, SwayOSD, Hyprlock, Chromium, and VS Code -- with AMOLED true black backgrounds and accent color highlights. This phase delivers visual theming for all components; it does not add new functionality, change layouts/modules, or modify component behavior.

</domain>

<decisions>
## Implementation Decisions

### Waybar design
- Solid true black (#000000) background, no transparency or blur
- Accent color on active workspace indicator and module icons (battery, wifi, clock icons)
- Workspace indicators as numbers, active workspace highlighted with accent
- No separators between module groups -- spacing alone distinguishes groups
- Text remains white/light gray

### Notification urgency (Mako)
- All notifications have AMOLED black background
- Urgency differentiated by left-edge border stripe only (like Slack/Discord style)
  - Normal: accent color border
  - Low: muted yellow border
  - Critical: red border
- App name displayed in accent color, summary and body text in white/gray
- Border is left-edge stripe, not full border

### Lock screen (Hyprlock)
- Large clock display over wallpaper, no date or extra info
- Clock text in accent color
- Password input is a dark box with accent-colored border, dot characters for password
- Wallpaper dimmed ~40-50% so clock and input field stand out clearly

### Accent balance (cross-component)
- Moderate presence philosophy: accent on active/interactive elements plus borders, icons, and highlights -- noticeable but not dominant
- Walker: accent border on search input field AND accent highlight on selected result
- VS Code: AMOLED black backgrounds everywhere, accent only on active tab indicator and focus borders -- minimal accent in editor
- SwayOSD: black popup background with accent-colored progress bar for volume/brightness
- Chromium: AMOLED black background (accent usage at Claude's discretion)

### Claude's Discretion
- Chromium accent treatment details (beyond AMOLED black background)
- Exact font sizes and spacing across all components
- Waybar module icon selection
- Mako notification animation/timeout behavior
- SwayOSD popup size and positioning
- Walker result list density and styling beyond accent highlights

</decisions>

<specifics>
## Specific Ideas

- Notification left-edge border is inspired by Slack/Discord notification stripe pattern
- Workspace indicators are numbers (not dots/pills) -- keep it functional
- Lock screen is minimal: just a big accent clock + password box, wallpaper does the visual work (dimmed for contrast)
- VS Code theming is intentionally restrained -- accent only on active tab, black backgrounds do the heavy lifting

</specifics>

<deferred>
## Deferred Ideas

None -- discussion stayed within phase scope

</deferred>

---

*Phase: 02-desktop-component-coverage*
*Context gathered: 2026-02-18*
