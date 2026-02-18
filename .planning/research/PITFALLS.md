# Pitfalls Research

**Domain:** Hyprland desktop theming with color generation and CLI customization (Omarchy framework)
**Researched:** 2026-02-18
**Confidence:** HIGH (verified against Omarchy issues, Hyprland wiki, and codebase analysis)

## Critical Pitfalls

### Pitfall 1: Global Opacity Catch-All Breaks Transparency-Dependent Apps

**What goes wrong:**
The current `hyprland.conf` uses `windowrule = opacity 1.0 1.0, match:class .*` to force full opacity on every window. This prevents AMOLED gray wash but kills transparency for screenshot tools, screen recorders, floating dialogs, overlay widgets, and any app that relies on alpha compositing. Worse, Hyprland's opacity system is multiplicative by default -- if a future Omarchy update or user config sets `active_opacity` to something below 1.0, it multiplies with this rule, producing unpredictable results.

**Why it happens:**
Omarchy ships a default opacity of 0.97 in its base `windows.conf`. On a black background, 3% transparency bleeds wallpaper through, turning `#000000` into `~#0D0D0D`. The quick fix is a global override, but `match:class .*` is a sledgehammer.

**How to avoid:**
Replace the global catch-all with targeted rules for known terminal/editor/btop classes. Use the `override` keyword to set exact values rather than relying on multiplication: `windowrule = opacity 1.0 override 1.0 override, match:class ^(ghostty|kitty|Alacritty|btop|neovide)$`. Leave other windows untouched so transparency works where apps expect it. Test with `hyprctl clients` to verify which classes need rules.

**Warning signs:**
- Screenshots or screen recordings show unexpected black rectangles
- Walker launcher or Mako notifications appear without expected transparency
- Users report floating windows or tooltips rendering incorrectly
- `hyprctl getoption decoration:active_opacity` shows multiplicative stacking

**Phase to address:**
Phase 1 (foundation) -- fix before adding Waybar/Walker/Mako coverage, since those are layer surfaces that the global rule could interfere with.

---

### Pitfall 2: Hyprland Window Rule Syntax Breaking Changes (0.48+/0.53+)

**What goes wrong:**
The current `hyprland.conf` uses `windowrule = opacity 1.0 1.0, match:class .*`, which is the newer syntax. However, Hyprland's window rule format underwent a complete overhaul in 0.48 and again in 0.53. The old `windowrulev2 = opacity 0.8 0.8, class:^(kitty)$` format is deprecated. Omarchy v3.3.0 itself noted that users updating would encounter "Hyprland configuration errors" requiring migration. If the theme ships rules in the wrong syntax version, it breaks on install.

**Why it happens:**
Hyprland is a fast-moving project with breaking changes. Theme authors write rules against their current Hyprland version and never test against newer (or older) versions. The migration from `windowrulev2` to block-style `windowrule` with `match:` syntax catches many theme projects off guard.

**How to avoid:**
Target the syntax version that Omarchy's current release expects. Since Omarchy v3.3.0 explicitly warns about this migration, use the current `windowrule = <action>, match:<property> <value>` format. Document the minimum Hyprland version in the theme README. Test any windowrule change with `hyprctl reload` and check `hyprctl systeminfo` for the compositor version.

**Warning signs:**
- Config parse errors on `hyprctl reload`
- GitHub issues from users on older or newer Hyprland versions
- Omarchy release notes mentioning windowrule syntax changes

**Phase to address:**
Phase 1 (foundation) -- must be correct before expanding rule coverage for Waybar/Walker/Mako layer rules.

---

### Pitfall 3: Color Drift Between colors.toml and Static Override Files

**What goes wrong:**
The same hex values (`#7B6CBD`, `#000000`, `#E8E0D0`) are currently hardcoded in 5+ files: `colors.toml`, `hyprland.conf`, `btop.theme`, `neovim.lua`, `vscode.json`. When the accent color changes, all files must be updated manually. In practice, one always gets missed. The Omarchy issue #4237 showed exactly this: when Omarchy's v3.3.0 theme refactor generated `activeBorderColor` from `colors.toml`, 9 out of 11 built-in themes had color mismatches because the template's `accent_strip` variable didn't match what themes had manually set.

**Why it happens:**
colors.toml is the declared "single source of truth" but currently has no generation pipeline -- it's a reference document, not a template input. Every config file independently hardcodes the same values. This is fine for a one-off theme but breaks completely when you add accent variants or a CLI tool.

**How to avoid:**
Build the generation pipeline before adding more themed apps. Define a clear template system: read colors.toml, produce all config files through string substitution. The Omarchy framework already generates configs from colors.toml for many apps (Waybar, Walker, Mako, btop, terminal emulators). For static override files (hyprland.conf, neovim.lua), use a build step or document which files are Omarchy-generated vs. theme-maintained. Never have the same hex value in both colors.toml and a static file that Omarchy already generates from it.

**Warning signs:**
- `grep -rn "7B6CBD"` across all files returns more than `colors.toml` and intentional static overrides
- Changing accent in colors.toml does not visibly change borders, highlights, or btop
- Users report "some things changed color but others didn't" after using the CLI tool

**Phase to address:**
Phase 2 (color generation system) -- this is the core architectural decision. Must be resolved before CLI tool or accent variants.

---

### Pitfall 4: Fighting Omarchy's Template Generation With Redundant Static Overrides

**What goes wrong:**
Omarchy v3.3.0+ generates Waybar CSS, Walker CSS, Mako config, btop theme, and terminal configs automatically from `colors.toml`. If a theme also ships static `waybar.css`, `walker.css`, or `mako.ini` files, those static files override the generated ones. This creates a maintenance trap: the static files don't update when colors.toml changes, and the theme author must manually keep them in sync with the generated output. The Dracula and Cobalt2 themes ship full static overrides for all apps -- this works for a fixed palette but becomes unmanageable with accent variants.

**Why it happens:**
Theme authors want pixel-perfect control over every app's styling, so they ship static config files. But Omarchy's template system was designed so that colors.toml is sufficient for most themes. Shipping static overrides means you're opting out of the generation pipeline for that app, which means accent swaps won't propagate to it.

**How to avoid:**
Decide per-app whether to rely on Omarchy's generation or provide a static override. For apps where the generated output is sufficient (Waybar, Mako, Walker, btop, terminals), let Omarchy generate from colors.toml -- do not ship a static file. Only ship static overrides for apps where the generated config is genuinely insufficient (like hyprland.conf for the opacity fix, or neovim.lua for tokyonight-specific overrides). Document which files are static overrides and why.

**Warning signs:**
- Theme ships both `colors.toml` AND a static config for an app Omarchy already generates for
- Accent color swap changes some apps but not others
- Users see different styles depending on whether they installed fresh vs. updated

**Phase to address:**
Phase 2 (color generation system) -- must decide the boundary between "Omarchy generates" and "theme overrides" before building the CLI tool.

---

### Pitfall 5: Accent Color Variants With Insufficient Contrast

**What goes wrong:**
The current accent `#7B6CBD` (muted blue-violet) was carefully chosen to work on `#000000` black. When building accent variants (blue, teal, red, etc.), it's tempting to just swap the hue while keeping similar lightness/saturation. But different hues at the same HSL lightness have wildly different perceived brightness (Helmholtz-Kohlrausch effect). A "teal" accent at the same HSL values as the purple may be unreadable on black, while a "yellow" accent may be blindingly bright. WCAG 2.1 requires 4.5:1 contrast for normal text and 3:1 for UI components.

**Why it happens:**
HSL/RGB are not perceptually uniform color spaces. Developers assume "same lightness = same readability" when swapping hues, but human perception doesn't work that way. Purple and blue require different lightness values to achieve the same perceived contrast against black.

**How to avoid:**
Define accent variants in a perceptually uniform color space like Oklch or CIELAB, not HSL. For each variant, verify WCAG contrast ratios against both the `#000000` background and the `#E8E0D0` foreground (for selection highlights). Use a contrast checker tool. Define a minimum contrast ratio (4.5:1 for text, 3:1 for borders/UI) and reject variants that fail. Store variant definitions in colors.toml and generate all configs from them.

**Warning signs:**
- Users report certain accent variants are "hard to read" or "too bright"
- Cyan/teal variants look washed out, yellow/orange variants are eye-searing
- Selection text (accent background + foreground text) becomes unreadable

**Phase to address:**
Phase 3 (accent variants / CLI tool) -- must be addressed when defining the variant palette, before shipping any new accent options.

---

### Pitfall 6: Neovim Color Override Breaks on tokyonight.nvim Version Changes

**What goes wrong:**
The current `neovim.lua` uses `on_colors` callback to override `colors.bg`, `colors.bg_dark`, `colors.bg_float`, and `colors.bg_sidebar`. This relies on tokyonight.nvim's internal color structure. When the plugin author renames, restructures, or deprecates color keys, the overrides silently fail -- Lua doesn't error on setting non-existent table fields. The AMOLED black background reverts to tokyonight's default dark blue (`#1a1b26`), breaking the core visual identity.

**Why it happens:**
Neovim colorscheme plugins have no stability guarantee for their `on_colors` API. The callback receives whatever color table the plugin internally uses, and that structure is an implementation detail. Theme authors treat it as a stable API.

**How to avoid:**
Pin the tokyonight.nvim version in documentation. Add a fallback: after the `on_colors` callback, set `vim.cmd("highlight Normal guibg=#000000")` as a safety net. Alternatively, use `on_highlights` which sets highlight groups directly (a more stable API than color table mutation). If building a CLI tool that generates neovim.lua, template the hex values but keep the override structure static -- don't try to dynamically generate the Lua callback logic.

**Warning signs:**
- After a `LazyVim` update, the background turns dark blue instead of black
- `on_colors` callback executes but background doesn't change
- Users report "theme broke after Neovim plugin update"

**Phase to address:**
Phase 2 (color generation) for templating the hex values; Phase 4 (polish) for version pinning and fallback safety.

---

## Technical Debt Patterns

Shortcuts that seem reasonable but create long-term problems.

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Hardcoding hex values in every config file | Fast to write, no build step needed | Every accent variant requires editing 5+ files; one missed file = visual inconsistency | Never after adding accent variants or a CLI tool |
| Global opacity `match:class .*` | Fixes AMOLED gray wash in one line | Breaks any app needing transparency; unpredictable with future Omarchy updates | Only as an interim fix in Phase 1, replaced with targeted rules immediately |
| Shipping static overrides for Omarchy-generated apps | Pixel-perfect control over each app's styling | Accent swaps don't propagate; must manually sync with colors.toml | Only when Omarchy's generated output is genuinely wrong for this theme |
| Using `sed` for color substitution in a CLI tool | Simple to implement, no dependencies | Breaks on colors containing regex special characters; can't handle multiline values; fragile with format changes | Only for a quick prototype; replace with TOML-aware parser for production |
| Storing 10MB PNG wallpapers in the git repo | Simple distribution, no external hosting | Git clone takes forever; repo bloats with each wallpaper added; git history stores every version permanently | Acceptable for 5 wallpapers at current scale; unacceptable if expanding the collection significantly |

## Integration Gotchas

Common mistakes when connecting theme configs to Omarchy-managed applications.

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| Waybar (layer surface) | Using `windowrule` instead of `layerrule` for opacity/blur | Waybar is a layer, not a window. Use `layerrule` for blur/opacity. Check with `hyprctl layers` to see Waybar's layer namespace |
| Walker (GTK4 app) | Shipping a static `walker.css` that conflicts with Omarchy's generated theme | Let Omarchy generate Walker styling from colors.toml. Only override if the generated CSS genuinely needs theme-specific adjustments |
| Mako (notification daemon) | Forgetting to reload Mako after config change (`makoctl reload`) | Mako does not hot-reload. Always run `makoctl reload` after changing config. Test with `notify-send "test" "message"` |
| Hyprland color format | Using `#RRGGBB` hex format in Hyprland conf | Hyprland uses `rgb(RRGGBB)` or `rgba(RRGGBBAA)` -- no leading `#`. Colors.toml uses `#RRGGBB`. The generation step must strip the `#` prefix |
| VS Code workspace colors | Only referencing an extension without workspace customizations | Ship full `workbench.colorCustomizations` with AMOLED black overrides. Extensions alone don't guarantee `#000000` backgrounds |
| btop gradient colors | Using random colors for gradients instead of palette-derived ones | All gradient start/mid/end colors should come from the 16-color ANSI palette in colors.toml for visual coherence |

## Performance Traps

Patterns that work on fast hardware but degrade on integrated graphics or laptops.

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Blur with 2+ passes on all windows | UI lag, dropped frames during window transitions | Use `passes = 1` as default; offer `passes = 2` as optional "high quality" setting | Integrated Intel/AMD graphics, especially with multiple monitors |
| Shadow `render_power = 3` on every window | Compositor frame drops during workspace switches | Reduce to `render_power = 2` or make shadows optional via a config flag | Laptops on battery, lower-end GPUs |
| Large wallpaper images (5-10MB each) | Slow theme installation, sluggish wallpaper transitions | Compress to WebP or JPEG at 90% quality; target < 2MB per wallpaper | Always on slow network; noticeable on NVMe with 5+ large wallpapers |
| Animation overshot beziers on workspace switch | Janky animation on lower frame rates | Test animations at 60fps and 30fps; reduce overshot factor if it stutters | 60Hz monitors with integrated graphics under load |

## UX Pitfalls

Common user experience mistakes in desktop theming.

| Pitfall | User Impact | Better Approach |
|---------|-------------|-----------------|
| CLI tool modifies files in-place without backup | User loses their customizations, can't undo | Always create a backup before modification (`.bak` file or git stash). Provide `--dry-run` flag to preview changes |
| Accent swap changes colors but requires logout to take effect | User thinks the tool is broken | Document which apps need reload vs restart. Provide a `reload-all` command that runs `hyprctl reload`, `makoctl reload`, `killall waybar && waybar &`, etc. |
| No preview of accent variants before applying | User must apply-test-revert cycle for each color | Show a terminal color preview or list available variants with sample swatches before applying |
| Icon theme doesn't match new accent color | Purple icons persist when accent changes to teal | Map accent variants to matching Yaru icon variants (purple -> Yaru-purple-dark, blue -> Yaru-blue-dark, etc.) or document the mismatch |
| Theme breaks silently on unsupported Omarchy version | User installs theme, nothing happens, no error message | Check Omarchy version at install time. Print clear warning if version is below minimum supported |

## "Looks Done But Isn't" Checklist

Things that appear complete but are missing critical pieces.

- [ ] **Waybar coverage:** Often missing -- hover states, tooltip backgrounds, and workspace indicator active state all need explicit color definitions. A waybar that "looks themed" in its default state may show default GTK colors on hover.
- [ ] **Walker launcher:** Often missing -- the input field background, placeholder text color, and result highlight color need separate CSS rules. The default Walker theme bleeds through underneath partial overrides.
- [ ] **Mako notifications:** Often missing -- urgency levels (low, normal, critical) each need their own color rules. A themed Mako that looks fine for normal notifications may show garish defaults for critical ones.
- [ ] **Selection colors:** Often missing -- terminal selection (colors.toml `selection_background`/`selection_foreground`) must be tested for readability. An accent that looks good as a border may be unreadable as a text selection background.
- [ ] **VS Code AMOLED compliance:** Often missing -- the extension reference alone does not set `#000000` backgrounds. Verify with `"editor.background": "#000000"` in workspace settings.
- [ ] **Hyprland lock screen (Hyprlock):** Often missing -- if the theme doesn't include `hyprlock.conf`, the lock screen uses system defaults which may clash with the AMOLED aesthetic.
- [ ] **SwayOSD on-screen display:** Often missing -- volume/brightness popups use system theme by default. A `swayosd.css` is needed for consistency.
- [ ] **Cursor theme on AMOLED:** Often missing -- default white cursors disappear on light-colored wallpaper areas and look jarring. Consider cursor color consistency.

## Recovery Strategies

When pitfalls occur despite prevention, how to recover.

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Global opacity rule breaks transparency apps | LOW | Remove the catch-all rule from `hyprland.conf`, run `hyprctl reload`. Add targeted rules for specific window classes instead. |
| Color drift across config files | MEDIUM | Run `grep -rn` for the old hex value across all theme files. Replace all occurrences. Then build the generation pipeline to prevent recurrence. |
| Neovim override breaks after plugin update | LOW | Set `vim.cmd("highlight Normal guibg=#000000")` in `neovim.lua` as immediate fix. Then check `on_colors` API in updated plugin docs. |
| Accent variant fails WCAG contrast | MEDIUM | Adjust the variant's lightness in Oklch space until it passes 4.5:1 against `#000000`. Regenerate all configs. |
| Static override conflicts with Omarchy generation | HIGH | Determine which version (static or generated) is correct. Delete the losing file. If static wins, document why. If generated wins, remove the static override and adjust colors.toml. |
| Hyprland syntax incompatibility | LOW | Use the migration tool at `https://itsohen.github.io/hyprrulefix/` or manually convert rules. Run `hyprctl reload` to verify. |

## Pitfall-to-Phase Mapping

How roadmap phases should address these pitfalls.

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Global opacity catch-all | Phase 1: Foundation | `hyprctl clients` shows no unexpected opacity override; test a transparent-background app |
| Hyprland syntax breaking changes | Phase 1: Foundation | `hyprctl reload` produces no parse errors; test on latest Omarchy release |
| Color drift between files | Phase 2: Color Generation | Changing accent in colors.toml propagates to all visible UI; `grep` finds hex values only in expected locations |
| Fighting Omarchy's template generation | Phase 2: Color Generation | Theme ships only static overrides for apps where generation is insufficient; all others rely on colors.toml |
| Accent contrast failures | Phase 3: CLI + Variants | Every accent variant passes WCAG 4.5:1 contrast check against `#000000`; selection text is readable |
| Neovim plugin version brittleness | Phase 2: Color Generation (template hex values); Phase 4: Polish (fallback safety) | After `LazyVim` update, background remains `#000000`; `on_colors` failure doesn't break AMOLED identity |

## Sources

- [Omarchy issue #4237: Theme refactor broke hyprland activeBorderColor](https://github.com/basecamp/omarchy/issues/4237) -- MEDIUM confidence, directly documents the color drift problem in Omarchy's own themes
- [Omarchy v3.3.0 release notes](https://github.com/basecamp/omarchy/releases/tag/v3.3.0) -- HIGH confidence, official release documenting theme generation system
- [Omarchy Making Your Own Theme](https://learn.omacom.io/2/the-omarchy-manual/92/making-your-own-theme) -- HIGH confidence, official documentation
- [Hyprland Window Rules Wiki](https://wiki.hypr.land/Configuring/Window-Rules/) -- HIGH confidence, official Hyprland documentation on opacity, override keyword, and layerrule vs windowrule
- [Hyprland 0.53 syntax change issues](https://github.com/JaKooLit/Hyprland-Dots/issues/902) -- MEDIUM confidence, community report of breakage from syntax migration
- [Hyprland opacity discussion #10222](https://github.com/hyprwm/Hyprland/discussions/10222) -- MEDIUM confidence, documents multiplicative opacity behavior
- [Hyprland color format issue #4473](https://github.com/hyprwm/Hyprland/issues/4473) -- MEDIUM confidence, documents `rgb()` vs `#hex` format requirement
- [Walker theming wiki](https://github.com/abenz1267/walker/wiki/Theming/86e6d7c213f1981c016d19e2f28d9cc0a40a63d5) -- MEDIUM confidence, official Walker documentation
- [WCAG 2.1 contrast requirements](https://web.dev/learn/accessibility/color-contrast) -- HIGH confidence, web standard
- [Codebase CONCERNS.md analysis](file:///home/asem/repos/omarchy-clawmarchy-theme/.planning/codebase/CONCERNS.md) -- HIGH confidence, direct analysis of current codebase issues
- [CLI color design best practices](https://blog.xoria.org/terminal-colors/) -- MEDIUM confidence, expert blog with color theory specifics

---
*Pitfalls research for: Hyprland desktop theming with color generation (Omarchy/Clawmarchy)*
*Researched: 2026-02-18*
