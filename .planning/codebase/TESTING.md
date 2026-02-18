# Testing Patterns

**Analysis Date:** 2026-02-18

## Project Type

This is a **theme configuration repository** with no executable source code, unit tests, or automated testing infrastructure. Testing is **manual and visual**.

## Test Framework

**Testing Approach:**
- No automated testing framework detected
- Testing is manual and visual across target applications
- No test runner, assertion library, or test harness configured
- No test files found in repository

**Configuration Files:**
- No `package.json`, `jest.config.js`, `vitest.config.ts`, or similar test configuration
- No `.eslintrc`, `.prettierrc`, or linting configuration
- No GitHub Actions workflows or CI/CD configuration

## Manual Testing Strategy

**Visual Testing Protocol:**
The theme must be visually verified across multiple applications:

**Required Test Applications:**
1. **Hyprland (Window Manager)**
   - Verify border colors appear in `#7B6CBD` (muted blue-violet)
   - Verify AMOLED black background appears pure black, not gray
   - Verify window blur effect applies smoothly with 6px size
   - Verify animations are smooth without stuttering

2. **btop (System Monitor)**
   - Verify CPU graph shows gradient cyan→blue→magenta correctly
   - Verify memory meter colors match CPU gradient
   - Verify process box colors align with palette
   - Verify box outlines all appear in accent color `#7B6CBD`

3. **Neovim (Text Editor)**
   - Verify background color is pure black `#000000`
   - Verify text appears in off-white `#E8E0D0`
   - Verify Tokyo Night colorscheme applies with overrides
   - Verify float windows use dark background `#0a0a12`

4. **VSCode (Editor)**
   - Verify Tokyo Night extension loads
   - Verify extension settings properly apply
   - Verify editor background matches theme

5. **Icons and Cursors**
   - Verify `Yaru-purple-dark` icons load in file browsers
   - Verify cursor color matches foreground `#E8E0D0`

**Testing Checklist:**
- [ ] All colors from palette match expected hex values
- [ ] AMOLED black backgrounds are pure `#000000` (not gray)
- [ ] Purple accent `#7B6CBD` appears consistently across borders/highlights
- [ ] Text contrast is sufficient (off-white on black)
- [ ] Gradients display smoothly without banding in btop
- [ ] Window decorations (shadows, blur) render without performance impact
- [ ] Theme applies cleanly with no color conflicts
- [ ] All 5 wallpapers display correctly as backgrounds

## Manual Verification Points

**Color Verification:**
- Palette defined in `colors.toml` matches visual appearance
- ANSI colors (color0-color15) display correctly in terminal applications
- Gradient transitions are smooth in btop metrics

**Contrast and Readability:**
- Off-white text (`#E8E0D0`) is readable on pure black background
- Selected items with purple background (`#7B6CBD`) and light text have sufficient contrast
- Inactive text color (`#2A2835`) is visible when needed for secondary info

**Technical Constraints:**
- Hyprland opacity set to 1.0 to achieve true black (0.97 default creates gray wash)
- Neovim colorscheme overrides applied correctly to set AMOLED black
- VSCode extension properly configured via `vscode.json`

## Theme Configuration Files Requiring Verification

**`colors.toml`** - Color Palette Source of Truth
- Location: `/home/asem/repos/omarchy-clawmarchy-theme/colors.toml`
- Contains: ANSI color palette (color0-color15) and semantic colors
- Verification: All referenced colors must be accurate hex values
- Impact: Used by all terminal applications

**`btop.theme`** - System Monitor Theme
- Location: `/home/asem/repos/omarchy-clawmarchy-theme/btop.theme`
- Contains: Theme definitions for btop UI elements, gradients for metrics
- Verification: Gradients display smoothly, all box colors match palette
- Impact: Visual appearance of system monitoring dashboard

**`hyprland.conf`** - Window Manager Theme
- Location: `/home/asem/repos/omarchy-clawmarchy-theme/hyprland.conf`
- Contains: Border colors, opacity fixes, visual effects (blur, shadow, animations)
- Verification: Window borders correct color, AMOLED black background true black, effects smooth
- Impact: Critical for AMOLED black constraint (opacity must be 1.0)

**`neovim.lua`** - Editor Configuration
- Location: `/home/asem/repos/omarchy-clawmarchy-theme/neovim.lua`
- Contains: Lazy plugin spec, tokyonight colorscheme with AMOLED overrides
- Verification: Background color set to `#000000`, float windows set to `#0a0a12`
- Impact: Editor appearance and readability

**`vscode.json`** - VSCode Configuration
- Location: `/home/asem/repos/omarchy-clawmarchy-theme/vscode.json`
- Contains: Extension reference to Tokyo Night
- Verification: Extension loads, settings apply correctly
- Impact: VSCode editor theme

**`icons.theme`** - Icon Theme
- Location: `/home/asem/repos/omarchy-clawmarchy-theme/icons.theme`
- Contains: Icon theme name reference
- Verification: Icons display in file managers with correct color
- Impact: File manager and application icon appearance

## Regression Testing

**When Making Changes:**

1. **After modifying `colors.toml`:**
   - Visually verify new colors in terminal applications
   - Check all referencing configs pick up hex value changes
   - Verify contrast ratios remain acceptable

2. **After modifying `hyprland.conf`:**
   - Check window borders display correctly
   - Verify AMOLED black constraint (no gray wash)
   - Test window animations don't stutter
   - Verify blur effect renders properly

3. **After modifying `btop.theme`:**
   - Open btop and verify all metrics display correctly
   - Check CPU/memory gradients are smooth
   - Verify process box colors align with palette
   - Test on different color depths if possible

4. **After modifying `neovim.lua`:**
   - Open Neovim and verify background color
   - Check float window backgrounds (`:set signcolumn=yes` to see floats)
   - Test syntax highlighting colors
   - Verify no colorscheme conflicts

## No Unit Tests

This repository **intentionally has no automated tests** because:
- Configuration files are static data, not executable code
- Correctness is determined by visual appearance, not logic
- Testing requires GUI applications which are not automatable in standard test frameworks
- Theme validation is best done by human verification across multiple applications

## Documentation for Testing Newcomers

**How to verify the Clawmarchy theme:**

1. Install the theme following README.md instructions
2. Open each application: Hyprland, btop, Neovim, VSCode
3. Visually compare colors to README palette section
4. Verify AMOLED black background is pure black, not gray
5. Check purple accent color appears in borders and highlights
6. Confirm text contrast is readable on black background
7. Test wallpapers display without visual artifacts
8. Run system monitor (btop) and verify metric gradients are smooth

**Critical Visual Tests:**
- AMOLED constraint: Black must be `#000000` with no gray (Hyprland opacity=1.0 critical)
- Accent consistency: Purple `#7B6CBD` appears in all borders/highlights
- Text readability: Off-white `#E8E0D0` is readable on black
- Gradient smoothness: btop gradients transition without banding

