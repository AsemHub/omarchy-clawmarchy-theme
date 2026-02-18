# Codebase Concerns

**Analysis Date:** 2026-02-18

## Tech Debt

**Hyprland Configuration Opacity Override (FX-01):**
- Issue: Global opacity rule overrides all windows with `opacity 1.0 1.0` to achieve true black rendering
- Files: `hyprland.conf` (line 25)
- Impact: This broad rule forces full opacity on ALL windows regardless of class. If any application requires transparency for proper functionality, it will be broken. The catch-all `match:class .*` pattern is overly aggressive.
- Fix approach: Create more targeted window class rules instead of global override. Test with transparency-dependent applications (screenshots, screen recording, floating dialogs). Consider using `layerrule` instead of `windowrule` for layer-based control.

**Hardcoded Border Color in Hyprland (FX-02):**
- Issue: Border color `$activeBorderColor = rgb(7B6CBD)` is hardcoded and cannot be dynamically generated from `colors.toml`
- Files: `hyprland.conf` (line 8), `colors.toml` (line 4)
- Impact: Changes to accent color in `colors.toml` require manual update to `hyprland.conf`. Creates sync risk between two configuration sources.
- Fix approach: Document color synchronization requirement in README or create a build/generation step to inject colors from `colors.toml` into `hyprland.conf` during installation.

## Performance Bottlenecks

**Large Background Images Increase Repository Size:**
- Problem: Wallpaper collection totals 27MB (background images alone), with largest individual image at 9.6MB
- Files: `backgrounds/` directory (all 5 PNG files), `wallpaper-preview.png` (8.8MB), `preview.png` (988KB)
- Cause: High-resolution anime wallpapers stored as uncompressed PNG files in repository
- Improvement path: Consider using lossy compression (WebP at 80-90% quality) to reduce size by 40-60%. Alternative: Host large assets on CDN and reference via download URLs in installation script. This would reduce clone time for theme-only users.

**Blur and Shadow Effects Performance Impact:**
- Problem: Hyprland configuration enables blur with 2 passes and shadows on all windows
- Files: `hyprland.conf` (lines 32-47)
- Cause: Multiple blur passes (`passes = 2`) and shadow rendering (`render_power = 3`) consume GPU resources, especially problematic on integrated graphics or laptops
- Improvement path: Document performance trade-offs in README. Provide alternative "lite" config with blur disabled for lower-end hardware. Consider making blur and shadows optional via configuration flag.

## Fragile Areas

**External Icon Dependency:**
- Files: `icons.theme` (line 1)
- Why fragile: Theme hardcodes `Yaru-purple-dark` icon set. If user does not have this icon pack installed, theme falls back to system default, breaking visual consistency
- Safe modification: Add fallback icon theme specifications in order of preference. Test installation on clean systems without Yaru icon sets.
- Test coverage: No validation that required icon package exists before theme activation

**Neovim Colorscheme Configuration Brittleness:**
- Files: `neovim.lua` (lines 8-11)
- Why fragile: Hardcodes absolute color values and assumes `folke/tokyonight.nvim` plugin with specific version behavior
- Safe modification: Verify plugin version compatibility. Add version pinning. Test color overrides work across different tokyonight.nvim versions. Consider wrapping in version check.
- Test coverage: No version validation for `tokyonight.nvim`. If user has outdated plugin, `on_colors` callback may not work correctly.

**VSCode Configuration Incompleteness:**
- Files: `vscode.json` (lines 1-4)
- Why fragile: Only specifies VSCode colorscheme extension without full color customization for workspace. Missing editor theme, token colors, and UI elements customization. AMOLED black requirements may not be fully applied in VSCode without additional settings.
- Safe modification: Expand `vscode.json` to include full `workbench.colorCustomizations` and `editor.tokenColorCustomizations` matching color palette
- Test coverage: No validation that VSCode displays true black (`#000000`) backgrounds

## Missing Critical Features

**No Installation Validation:**
- Problem: Theme can be installed but no checks validate all components are correctly configured
- Blocks: Users may install theme without required dependencies (Yaru icons, tokyonight.nvim) and see broken visuals without clear error messages
- Recommendation: Add post-installation validation script that checks: icon theme availability, neovim plugin presence, hyprland version compatibility, color consistency across all configs

**Documentation Gaps:**
- Problem: README lacks troubleshooting section and doesn't document known limitations
- Blocks: Users on non-Wayland systems (X11 with i3, KDE, GNOME) cannot use hyprland.conf features
- Recommendation: Add "Compatibility" section documenting supported display servers, window managers, and fallback configurations for unsupported environments

**No Configuration Customization Guide:**
- Problem: Theme provides no way for users to customize colors or effects without directly editing configuration files
- Blocks: Users wanting to adjust purple accent to blue, or disable blur effects, must manually modify multiple files
- Recommendation: Create a simple configuration override mechanism (e.g., `.config/clawmarchy-overrides.conf`) allowing users to specify preferences without maintaining local changes

## Security Considerations

**No Validation of External Assets:**
- Risk: Theme references external colorscheme plugin (`tokyonight.nvim`) and icon pack (`Yaru-purple-dark`) without integrity checks
- Files: `neovim.lua` (line 3), `icons.theme` (line 1)
- Current mitigation: Relies on system package manager security
- Recommendations: Document source verification process for manual installations. Consider adding checksum validation for color references if hosting custom builds.

## Test Coverage Gaps

**No Color Consistency Validation:**
- What's not tested: Color hex values consistency across all config files (`colors.toml`, `hyprland.conf`, `btop.theme`, `neovim.lua`)
- Files: `colors.toml`, `hyprland.conf` (line 8), `btop.theme` (lines 50-87), `neovim.lua` (line 8)
- Risk: Manual updates create risk of color mismatches. For example, `#7B6CBD` appears in 5+ files but has no single source of truth
- Priority: High - Visual inconsistency undermines theme coherence

**No Cross-Application Rendering Test:**
- What's not tested: Visual appearance verification across Hyprland, Neovim, btop, VSCode, and terminal
- Files: All configuration files
- Risk: Individual configs may be valid but together produce inconsistent visual appearance (e.g., border colors don't match text highlights)
- Priority: Medium - Requires manual testing or screenshot comparison framework

**No Performance Benchmark:**
- What's not tested: Actual GPU/CPU impact of blur, shadow, and animation settings
- Files: `hyprland.conf` (lines 32-60)
- Risk: Theme may perform poorly on target hardware (integrated graphics, ARM devices) without testing
- Priority: Medium - Install base may skew toward high-end hardware initially

---

*Concerns audit: 2026-02-18*
