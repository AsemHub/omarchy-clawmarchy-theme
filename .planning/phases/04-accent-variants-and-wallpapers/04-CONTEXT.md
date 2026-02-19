# Phase 4: Accent Variants and Wallpapers - Context

**Gathered:** 2026-02-19
**Status:** Ready for planning

<domain>
## Phase Boundary

Ship 3+ pre-built accent color alternatives beyond the default purple, each with verified WCAG 4.5:1 contrast against #000000. Each variant includes its own colors.toml, btop.theme, all accent-dependent config files, and a paired wallpaper. Expand the wallpaper collection with AI-generated anime artwork. Variant installation follows a documented, straightforward process.

Prior decision: accent swap variants only (not full palette variants). The base 16-color ANSI palette stays constant; only the accent color and accent-derived values change per variant.

</domain>

<decisions>
## Implementation Decisions

### Accent color selection
- 5-6 total variants including the default purple (4-5 new accents)
- Claude selects specific hex values that pass WCAG 4.5:1 contrast against #000000
- Claude balances muted and vibrant tones across the set for range
- Each variant gets an evocative name (e.g., Sakura, Ocean, Ember) fitting the anime/aesthetic vibe

### Wallpaper collection
- All wallpapers are AI-generated (no sourced/licensed art)
- User generates wallpapers using Gemini Pro with prompts/specs provided in the plan
- Anime/manga aesthetic only — consistent with current collection
- One wallpaper per variant, color-matched to the variant's accent tones
- Ship at both 3840x2160 (4K) and 2560x1440 (QHD) resolutions

### Variant packaging
- Claude's Discretion: file structure (subdirectories vs flat)
- Claude's Discretion: whether default purple stays in root or moves to variant directory
- Claude's Discretion: whether variants include full file copies or only changed files
- Claude's Discretion: switching mechanism (manual copy vs script)

### btop gradient mapping
- Claude's Discretion: whether core gradients (cpu, mem, network, process) adapt per variant or stay fixed on palette colors
- Claude's Discretion: whether temp_mid uses the new accent or stays semantic
- Claude's Discretion: whether box outlines always match accent or use a variant-specific contrasting shade

</decisions>

<specifics>
## Specific Ideas

- User has Google Gemini Pro subscription with image generation access — plan should include detailed generation prompts for wallpapers
- Wallpaper prompts should specify dark atmospheric anime scenes with accent-complementary color tones
- Current 5 wallpapers (cyberpunk neon city, dark atmospheric shrine, character silhouette, neon rain street, moonlit landscape) set the aesthetic baseline

</specifics>

<deferred>
## Deferred Ideas

- **AI wallpaper generation CLI integration** — Integrate Gemini/Nano Banana for on-demand wallpaper generation from the command line. User has Gemini Pro subscription with image, video, and music generation access. This is a new capability (CLI tool/pipeline) that belongs in its own phase.
- **Music generation integration** — User has Gemini Pro music generation access. Entirely separate capability.

</deferred>

---

*Phase: 04-accent-variants-and-wallpapers*
*Context gathered: 2026-02-19*
