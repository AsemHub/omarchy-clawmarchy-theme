# Feature Research

**Domain:** Hyprland/Omarchy desktop theme package
**Researched:** 2026-02-18
**Confidence:** HIGH

## Feature Landscape

### Table Stakes (Users Expect These)

Features users assume exist. Missing these = theme feels incomplete and amateurish.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Waybar status bar theming (waybar.css) | Every polished Omarchy theme (Cobalt2, Ash, Dracula, Aura) ships a waybar.css override. The auto-generated version from colors.toml only defines 2 CSS variables (`@define-color foreground` and `@define-color background`). Without a custom override, the bar looks generic. | LOW | File is pure CSS `@define-color` directives. Can start minimal (matching auto-gen format) and enhance later. Omarchy's base waybar/style.css `@import`s this file. |
| Walker launcher theming (walker.css) | Same pattern -- all complete themes ship walker.css. Auto-generated version defines 6 CSS variables (`selected-text`, `text`, `base`, `border`, `foreground`, `background`). Custom override lets the launcher match the AMOLED aesthetic. | LOW | CSS color definitions only. Walker inherits default theme styling, so the override just sets colors. |
| Mako notification theming (mako.ini) | Notifications are one of the most visible desktop elements. Auto-generated mako.ini only sets 3 color values plus includes the core layout config. Custom override can tune font, border width, dimensions, padding. | LOW-MEDIUM | Can start by just overriding colors (LOW) or customize full layout (MEDIUM). The Cobalt2 theme customizes font, dimensions, padding, and adds app-specific rules. |
| Hyprlock lock screen theming (hyprlock.conf) | Lock screen is a daily touchpoint. Auto-generated version sets 5 color variables (`$color`, `$inner_color`, `$outer_color`, `$font_color`, `$check_color`). Every serious theme provides this. | LOW | Template-generated from colors.toml already. Custom override only needed for non-standard color mappings. Current Clawmarchy may work fine with auto-gen. |
| SwayOSD on-screen display theming (swayosd.css) | Volume/brightness popups appear frequently. Auto-generated version defines 5 CSS color variables. Custom override ensures consistency. | LOW | CSS color definitions only. Minimal effort. |
| Chromium browser theming (chromium.theme) | Browser is always open. Auto-generated file is just the RGB background value (e.g., `26,27,38`). Single line file. | LOW | Trivially simple -- just `R,G,B` on one line. |
| Obsidian note-taking theming (obsidian.css) | Users who have Obsidian expect it themed. Auto-generated version is comprehensive (100 lines covering headers, code, links, graphs). | LOW | Auto-generated version is already thorough. Custom override only needed if AMOLED-specific tweaks are desired. |
| Terminal emulator configs (alacritty.toml, ghostty.conf, kitty.conf) | Omarchy supports 3 terminal emulators. Colors.toml auto-generates all 3 configs. Not shipping these means relying on auto-gen, which is fine for most themes. | LOW | Auto-gen from colors.toml is sufficient. Only override if terminal-specific tweaks needed (like cursor shape, font). |
| Preview screenshot (preview.png) | Community themes without screenshots don't get installed. Users browse visually. Already exists in Clawmarchy. | LOW | Already shipped. Keep updated as theme expands. |
| Consistent color palette across all components | The core promise of a theme. If waybar is purple but mako is blue, the theme is broken. Colors must trace back to a single palette. | MEDIUM | Already done for existing components via colors.toml. New files (waybar/walker/mako) need to reference same hex values. |

### Differentiators (Competitive Advantage)

Features that set Clawmarchy apart from 100+ community themes. Not required, but make it special.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| AMOLED true black (#000000) with opacity fix | Most dark themes use dark gray (Catppuccin #1e1e2e, Tokyo Night #1a1b26, Matte Black #121212). True black is rare and prized for OLED displays. The existing opacity windowrule (`opacity 1.0 1.0, match:class .*`) prevents wallpaper bleed-through that would ruin the effect. | Already built | Current implementation uses global catch-all rule. Refining to targeted rules is planned. Core differentiator worth protecting. |
| Custom btop gradient mapping (cyan-to-magenta) | Most themes use simple start/mid/end gradients with accent colors. Clawmarchy's btop theme maps low usage to cool cyan, mid to blue, high to magenta -- creating a visually meaningful heat map. | Already built | Already shipped and well-crafted. |
| CLI accent color customization tool | No popular Omarchy theme ships a CLI tool. Aether and Tema are separate applications. A built-in `clawmarchy-accent` command that rewrites colors.toml and regenerates all configs from a single command would be unique. | HIGH | Requires: parsing colors.toml, color math for derived palette, regenerating btop.theme/neovim.lua/hyprland.conf, understanding Omarchy's generation pipeline. Major feature. |
| Pre-built accent color variants | Most themes ship one color scheme. Shipping 5-6 pre-built variants (blue, teal, red, amber, green on same AMOLED black base) lets users pick without any CLI knowledge. Each variant is just a separate colors.toml + btop.theme with different accent colors. | MEDIUM | Each variant needs colors.toml + btop.theme + neovim.lua at minimum. Variants where a Neovim colorscheme exists (tokyonight with different styles) are easier. Need to decide if variants are separate theme dirs or same theme with swappable colors. |
| Curated anime wallpaper collection | Generic landscapes are easy to find. Curated anime wallpapers with specific color-tone matching (dark atmospheric + purple/cyan tones) serve a specific aesthetic niche. 5 wallpapers is decent; 10-15 would be comprehensive. | LOW-MEDIUM | Low complexity per wallpaper (just sourcing and adding to backgrounds/). Medium overall effort for curation quality. Must ensure wallpapers work across accent color variants. |
| Comprehensive documentation | Most Omarchy themes have a 10-line README. Proper docs covering: palette breakdown, troubleshooting (opacity issues, font requirements), customization guide, compatibility notes, and screenshots per variant would be exceptional. | MEDIUM | Writing quality docs takes time but no technical complexity. |
| Single-source color system with generation | Using colors.toml as the authoritative source and generating all other configs from it (btop.theme, neovim.lua overrides, hyprland.conf) prevents color drift. Most themes manually duplicate colors across files. | HIGH | Requires a build/generation step. Currently Omarchy generates waybar/walker/mako/etc from colors.toml, but btop.theme and neovim.lua are manually authored. A local generation script could template these too. |
| Semantic waybar color variables | The Omarchy PR #2808 added `@theme-red`, `@theme-yellow`, `@theme-green` to waybar themes for status indicators (battery, recording). Shipping these semantic mappings makes the theme work better with Omarchy's evolving status bar. | LOW | Just adding 3 additional `@define-color` lines to waybar.css mapping to palette colors (color1=red, color3=yellow, color2=green). |
| Full VS Code workspace color customization | Current vscode.json only references the Tokyo Night extension. Full workspace-level AMOLED overrides (editor background, sidebar, terminal) would make VS Code truly match the desktop. | MEDIUM | VS Code's settings.json supports `workbench.colorCustomizations` for fine-grained overrides. Needs careful mapping of ~20 color tokens. |

### Anti-Features (Commonly Requested, Often Problematic)

Features that seem good but create maintenance burden, scope creep, or user confusion.

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Full palette variants (Dracula, Gruvbox, Nord on black) | "What if I want Dracula colors on black?" | Each full palette variant needs entirely new colors.toml, btop.theme gradients, neovim.lua colorscheme, and 16-color ANSI palette. It's a new theme, not a variant. Maintenance burden grows linearly. Dilutes AMOLED identity. | Ship accent color variants (same palette structure, different accent hue). Point users to dedicated Dracula/Gruvbox Omarchy themes that already exist. |
| Dynamic wallpaper-based theming (like Aether/Tema) | "Auto-match colors to my wallpaper" | Requires runtime color extraction, sophisticated palette generation, and conflicts with the curated aesthetic. Aether and Tema already do this as standalone tools. Duplicating their work inside a theme is wrong scope. | Recommend Aether/Tema in docs for users who want dynamic theming. Clawmarchy is a curated, opinionated theme -- not a theme engine. |
| GTK/Qt application theming (beyond icons) | "Make Firefox/Thunar/Nautilus match" | GTK theming is a massive rabbit hole with version fragmentation (GTK3 vs GTK4), app-specific quirks, and constant breakage. Omarchy handles GTK via system-level settings. Themes should not override GTK. | Ship icon theme reference (already done with Yaru-purple-dark). Let Omarchy handle GTK/Qt color propagation. |
| Animated wallpapers or video backgrounds | "Would look cool with animated cyberpunk" | Hyprland supports them via plugins, but they drain GPU/battery, conflict with AMOLED black power savings, and add massive repo size. | Ship static wallpapers. Document how users can add their own animated wallpapers if desired. |
| Custom Waybar layout/modules (not just colors) | "Add weather module, Spotify widget" | Waybar layout (config.jsonc) is personal preference territory. Themes should style what Omarchy's default layout shows, not redefine the layout. Layout changes risk breaking Omarchy updates. | Only ship waybar.css (colors/styling). Let Omarchy manage waybar layout via its config.jsonc. |
| Ghostty terminal config | "I use Ghostty, theme it too" | Omarchy auto-generates ghostty.conf from colors.toml. Shipping a custom one only helps if terminal-specific tweaks are needed beyond colors. Manual maintenance burden for minimal gain. | Rely on Omarchy's auto-generation from colors.toml. Only override if Ghostty-specific features (like cursor style) need AMOLED-specific settings. |
| X11/non-Wayland support | "Make it work on i3/XFCE" | Omarchy is Hyprland/Wayland exclusive. Supporting X11 would require entirely different config formats and testing infrastructure. | Explicitly document as out of scope. |
| Automated visual regression testing | "Test that screenshots match" | Theme changes are visual and subjective. Screenshot comparison tools add CI complexity for minimal value. Manual review is faster for a solo/small project. | Manual verification with preview.png updates on meaningful changes. |

## Feature Dependencies

```
[colors.toml palette]
    |--generates--> [waybar.css] (auto-gen or custom override)
    |--generates--> [walker.css] (auto-gen or custom override)
    |--generates--> [mako.ini] (auto-gen or custom override)
    |--generates--> [hyprlock.conf] (auto-gen or custom override)
    |--generates--> [swayosd.css] (auto-gen or custom override)
    |--generates--> [chromium.theme] (auto-gen or custom override)
    |--generates--> [terminal configs] (auto-gen)
    |--manually--> [btop.theme] (manual, uses palette colors)
    |--manually--> [neovim.lua] (manual, references colorscheme)
    |--manually--> [hyprland.conf] (manual, custom effects beyond border color)
    |--manually--> [vscode.json] (manual, extension reference + overrides)

[Accent color variants]
    |--requires--> [colors.toml palette] (each variant = different colors.toml)
    |--requires--> [btop.theme] (gradient colors change per accent)
    |--may-require--> [neovim.lua] (if colorscheme style changes)
    |--does-not-require--> [waybar/walker/mako] (auto-gen handles them)

[CLI accent customization tool]
    |--requires--> [colors.toml as single source of truth]
    |--requires--> [btop.theme generation from palette] (or template)
    |--requires--> [understanding of Omarchy's omarchy-theme-set pipeline]
    |--enhances--> [accent color variants] (CLI can create variants on the fly)

[Single-source generation system]
    |--requires--> [colors.toml palette definition]
    |--enables--> [CLI accent customization tool]
    |--enables--> [accent color variants] (generate instead of manual)
    |--conflicts-with--> [manual btop.theme authoring] (must template it)

[Semantic waybar colors]
    |--requires--> [waybar.css custom override] (add @theme-red/yellow/green)
    |--requires--> [colors.toml] (map color1/color2/color3 to semantics)

[Full VS Code workspace colors]
    |--enhances--> [vscode.json] (extends from extension-only to full overrides)
    |--independent of--> all other features

[Expanded wallpaper collection]
    |--independent of--> all other features
    |--consideration--> wallpapers should work with all accent variants
```

### Dependency Notes

- **Waybar/Walker/Mako/SwayOSD/Hyprlock overrides are independent**: Each can be added without the others. They only depend on having the right colors from the palette.
- **CLI tool requires generation system**: You cannot build a "change accent color" CLI without first having a way to regenerate btop.theme and other manual files from the palette. These are coupled.
- **Accent variants can be manual or generated**: Pre-built variants can be hand-crafted (copy colors.toml, change accent, manually adjust btop gradient). But if you later build the CLI/generation system, manual variants become obsolete.
- **Omarchy handles most generation already**: The critical insight is that Omarchy's template system (`~/.local/share/omarchy/default/themed/*.tpl`) generates waybar.css, walker.css, mako.ini, etc. from colors.toml automatically. Themes only need custom overrides if they want styling beyond what the templates provide.

## MVP Definition

### Launch With (v1) -- Complete Theme Coverage

Minimum for the theme to be considered "complete" by Omarchy community standards.

- [ ] **waybar.css** -- Custom override with AMOLED colors + semantic color variables (@theme-red/yellow/green). Even if just color definitions, having the file signals completeness.
- [ ] **walker.css** -- Custom override with AMOLED black base and accent selection colors.
- [ ] **mako.ini** -- Custom override with AMOLED black background, accent border, and properly sized notifications.
- [ ] **hyprlock.conf** -- Custom override with AMOLED black lock screen colors. May already work via auto-gen, but verify and override if needed.
- [ ] **swayosd.css** -- Custom override with AMOLED colors for volume/brightness popups.
- [ ] **chromium.theme** -- Single-line RGB background color file.
- [ ] **Refine opacity window rule** -- Replace global `match:class .*` with targeted rules to avoid breaking transparency-dependent apps.
- [ ] **Update README** -- Document all themed components, installation, and palette.

### Add After Validation (v1.x)

Features to add once core coverage is shipped and stable.

- [ ] **Pre-built accent variants (3-5 colors)** -- Ship blue, teal, red variants as separate directories or a variant selection mechanism. Start with 3 that have clear aesthetic appeal.
- [ ] **Expanded wallpaper collection** -- Add 5-10 more wallpapers. Ensure they work aesthetically across accent variants (dark, atmospheric, not tied to purple specifically).
- [ ] **Full VS Code workspace color customizations** -- Extend vscode.json with `workbench.colorCustomizations` for AMOLED editor/sidebar/terminal backgrounds.
- [ ] **Obsidian.css override** -- If auto-gen doesn't produce AMOLED black backgrounds, ship a custom override.
- [ ] **Comprehensive documentation** -- Troubleshooting guide, compatibility notes, customization instructions, variant screenshots.

### Future Consideration (v2+)

Features to defer until the theme has community traction and the simpler features are validated.

- [ ] **CLI accent customization tool** -- Defer because it requires a build system, color math, template engine. Only worth building if community demand exists. Users can manually edit colors.toml.
- [ ] **Single-source generation from colors.toml** -- Template btop.theme and neovim.lua from palette. Enables CLI tool but adds build complexity. Worth it only at scale.
- [ ] **Theme hook integration** -- Use Omarchy's `omarchy-theme-hook` system for runtime accent switching without theme reinstall. Requires deeper integration research.

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| waybar.css override | HIGH | LOW | P1 |
| walker.css override | HIGH | LOW | P1 |
| mako.ini override | HIGH | LOW | P1 |
| hyprlock.conf override | MEDIUM | LOW | P1 |
| swayosd.css override | MEDIUM | LOW | P1 |
| chromium.theme | MEDIUM | LOW | P1 |
| Refine opacity window rule | MEDIUM | LOW | P1 |
| Semantic waybar colors | MEDIUM | LOW | P1 |
| README update | MEDIUM | LOW | P1 |
| Pre-built accent variants | HIGH | MEDIUM | P2 |
| Expanded wallpapers | MEDIUM | LOW | P2 |
| VS Code workspace colors | MEDIUM | MEDIUM | P2 |
| Obsidian.css override | LOW | LOW | P2 |
| Documentation site/guide | MEDIUM | MEDIUM | P2 |
| CLI accent tool | HIGH | HIGH | P3 |
| Single-source generation | MEDIUM | HIGH | P3 |
| Theme hook integration | LOW | HIGH | P3 |

**Priority key:**
- P1: Must have -- completes the theme for community release
- P2: Should have -- adds polish and differentiation
- P3: Nice to have -- deferred until demand validates effort

## Competitor Feature Analysis

| Feature | Built-in Omarchy Themes (tokyo-night, catppuccin) | Cobalt2 (comprehensive community) | Ash/Aura (community) | Clawmarchy Current | Clawmarchy Target |
|---------|---------------------------------------------------|------------------------------------|-----------------------|---------------------|-------------------|
| colors.toml | Yes | Yes | Yes | Yes | Yes |
| btop.theme | Yes | Yes | Yes | Yes (custom gradients) | Yes |
| neovim.lua | Yes | Yes (custom colorscheme) | Yes | Yes (tokyonight AMOLED) | Yes |
| vscode.json | Yes (extension ref) | Yes | Yes | Yes (extension ref) | Full workspace overrides |
| icons.theme | Yes | Yes | Yes | Yes (Yaru-purple-dark) | Yes |
| backgrounds/ | Yes (3-5) | Yes | Yes | Yes (5 curated anime) | 10-15 wallpapers |
| hyprland.conf | Some (kanagawa has extra) | Yes | Yes | Yes (blur, shadow, animations, opacity) | Refined opacity rules |
| waybar.css | NO (auto-gen only) | Yes (custom) | Yes (custom) | NO | Yes (custom + semantic) |
| walker.css | NO (auto-gen only) | Yes (custom) | Yes (custom) | NO | Yes (custom) |
| mako.ini | NO (auto-gen only) | Yes (custom layout + colors) | Yes (custom) | NO | Yes (custom) |
| hyprlock.conf | NO (auto-gen only) | Yes (custom) | Yes (custom) | NO | Yes (custom) |
| swayosd.css | NO (auto-gen only) | Yes (custom) | Yes (custom) | NO | Yes (custom) |
| chromium.theme | NO (auto-gen only) | Yes | Yes | NO | Yes |
| obsidian.css | NO (auto-gen only) | Yes (custom) | No | NO | Maybe (auto-gen may suffice) |
| Accent variants | No | No | No | No | Yes (3-5 variants) |
| CLI customization | No | No | No | No | Future (P3) |
| preview.png | Yes | Yes | Yes | Yes | Yes (per variant) |
| AMOLED true black | matte-black only (#121212, not true #000000) | No (#193549 blue) | No | Yes (#000000) | Yes (#000000) |

**Key competitive insight:** Clawmarchy's AMOLED true black differentiates it from nearly every other Omarchy theme. Even matte-black uses #121212, not true #000000. Protecting this with the opacity fix and extending it consistently across all components is the core value proposition. Adding accent variants multiplies this advantage -- no other theme offers "pick your accent on true AMOLED black."

## Sources

- [Omarchy Manual: Making your own theme](https://learn.omacom.io/2/the-omarchy-manual/92/making-your-own-theme) -- Official Omarchy theme conventions and file structure (HIGH confidence)
- [Omarchy Manual: Themes](https://learn.omacom.io/2/the-omarchy-manual/52/themes) -- Theme overview and capabilities (HIGH confidence)
- [Omarchy PR #2808: Semantic waybar color support](https://github.com/basecamp/omarchy/pull/2808/files) -- Semantic color variables for waybar (HIGH confidence)
- [Omarchy Issue #327: Unify theme CSS files](https://github.com/basecamp/omarchy/issues/327) -- Decision to keep waybar/walker/swayosd CSS separate for flexibility (HIGH confidence)
- [Cobalt2 Theme](https://github.com/hoblin/omarchy-cobalt2-theme) -- Reference comprehensive community theme (MEDIUM confidence)
- [Ash Theme](https://github.com/bjarneo/omarchy-ash-theme) -- Reference comprehensive community theme (MEDIUM confidence)
- [Dracula Theme](https://github.com/guibes/omarchy-dracula-theme) -- Reference comprehensive community theme (MEDIUM confidence)
- [Aether](https://github.com/bjarneo/aether) -- Visual theming app for Omarchy with wallpaper color extraction (MEDIUM confidence)
- [Tema](https://github.com/bjarneo/tema) -- Wallpaper-based theme generator for Omarchy (MEDIUM confidence)
- [Walker Theming Wiki](https://github.com/abenz1267/walker/wiki/Theming/86e6d7c213f1981c016d19e2f28d9cc0a40a63d5) -- Walker CSS theming documentation (HIGH confidence)
- [omarchy-theme-hook](https://breakshit.blog/blog/omarchy-theme-hook) -- Theme hook system for runtime theme application (MEDIUM confidence)
- [Omarchy Theming DeepWiki](https://deepwiki.com/basecamp/omarchy/6-theming-and-customization) -- Three-layer theming architecture documentation (MEDIUM confidence)
- Local filesystem inspection of `~/.local/share/omarchy/themes/` and `~/.local/share/omarchy/default/themed/*.tpl` -- Verified auto-generation template system (HIGH confidence)

---
*Feature research for: Hyprland/Omarchy desktop theme package (Clawmarchy)*
*Researched: 2026-02-18*
