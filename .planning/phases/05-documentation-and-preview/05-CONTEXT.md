# Phase 5: Documentation and Preview - Context

**Gathered:** 2026-02-19
**Status:** Ready for planning

<domain>
## Phase Boundary

Comprehensive README with component documentation, troubleshooting, customization guide, compatibility requirements, and an updated preview screenshot. The README already has a base structure (Install, Features, Accent Variants, Palette, Credits, Switching Themes) from prior phases. Phase 5 expands it into full documentation and adds a desktop preview.

</domain>

<decisions>
## Implementation Decisions

### Component docs depth
- Claude's Discretion: format (table vs grouped descriptions vs hybrid)
- Full file tree showing every config file in the theme (including variants/, backgrounds/)
- Claude's Discretion: whether to mark each file as generated vs static override in the README
- Claude's Discretion: whether to reference COLORS.md for detailed color mapping or inline in README

### Customization guide scope
- Pre-built variants only -- document clawmarchy-variant and the 6 options
- Do NOT include manual hex editing for custom accent colors (that's v2 CLI-01 scope)
- Claude's Discretion: wallpaper customization detail level (directory location, resolution guidance)

### Troubleshooting
- Claude's Discretion: expand beyond the 3 required issues (opacity, fonts, icons) based on what's likely to trip users up

### Compatibility
- Claude's Discretion: list specific versions or just "requires Omarchy" based on what the theme actually needs

### Preview screenshot
- Show the Ember (orange) variant -- warm and vibrant, stands out on GitHub
- Full desktop spread: Waybar at top, btop in terminal, Neovim or VS Code open, Walker launcher visible -- show all themed surfaces
- User will take the screenshot manually (Claude provides staging instructions in the plan)
- Claude's Discretion: whether to keep wallpaper-preview.png as a separate banner or use only preview.png

### README structure and tone
- Minimal and clean: short descriptions, tables over prose, let screenshots speak
- Table of contents at the top with linked navigation
- Claude's Discretion: GitHub badges (if any)
- Claude's Discretion: whether to keep the existing Palette section with color swatch badges

</decisions>

<specifics>
## Specific Ideas

- The README already has sections from 04-03 gap closure: Install, Features, Accent Variants, Palette, Credits, Switching Themes
- Expand on this base rather than rewriting from scratch
- Keep the current Install section as-is (one-liner is perfect)
- The Accent Variants section from 04-03 is already solid -- may only need minor tweaks

</specifics>

<deferred>
## Deferred Ideas

None -- discussion stayed within phase scope

</deferred>

---

*Phase: 05-documentation-and-preview*
*Context gathered: 2026-02-19*
