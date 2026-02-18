# Coding Conventions

**Analysis Date:** 2026-02-18

## Project Type

This is a **theme configuration repository** rather than executable source code. It contains configuration files for multiple tools and environments. Conventions apply to configuration structure and formatting across all config files.

## Naming Patterns

**Files:**
- Snake case with descriptive names: `hyprland.conf`, `btop.theme`, `colors.toml`, `neovim.lua`, `vscode.json`
- File extensions match their config format (.conf for configuration, .theme for theme files, .toml for TOML, .lua for Lua, .json for JSON)
- No abbreviations in filenames except for tool-specific conventions (btop, vscode, neovim match tool names)

**Configuration Keys:**
- Snake case: `theme[main_bg]`, `theme[main_fg]`, `col.active_border`, `windowrule`
- Prefix-based organization: `theme[*]` for btop theme entries, `col.*` for color definitions in Hyprland, `opts.*` for Neovim options

**Color References:**
- Hex format: `#7B6CBD`, `#000000`, `#E8E0D0`
- Consistent use of hex color codes across all files (no RGB or HSL format)
- RGBA format for transparency: `rgba(00000088)` where last two digits are alpha

**Variable Names:**
- Semantic naming tied to purpose: `accent`, `cursor`, `foreground`, `background`
- Color semantic names: `selection_foreground`, `selection_background`, `inactive_fg`, `graph_text`
- Prefixed numeric colors: `color0` through `color15` for ANSI color palette

## Code Style

**Formatting:**
- TOML (`colors.toml`): Key-value pairs with `=` assignment, simple string values
- Bash-like config (`btop.theme`, `hyprland.conf`): Line-based key assignments with `=`, array-like syntax with brackets
- JSON (`vscode.json`): Standard JSON formatting with 2-space indentation
- Lua (`neovim.lua`): Table-based structure with standard Lua formatting conventions

**Linting:**
- No automated linting detected; files follow manual conventions
- Configuration files use consistent spacing and formatting within their respective formats

**Line Length:**
- No strict line length enforcement observed
- Comments and configuration values span naturally without line-breaking constraints

## Import Organization

**Neovim Configuration (`neovim.lua`):**
- Uses Lua table format with plugin specifications
- Plugins specified by author/package path: `"folke/tokyonight.nvim"`, `"LazyVim/LazyVim"`
- Option tables nested within plugin specifications using `opts = { ... }`
- Function callbacks for dynamic behavior: `on_colors = function(colors) ... end`

**VSCode Configuration (`vscode.json`):**
- Single-level JSON object with extension reference
- Extension identified by package ID: `"enkia.tokyo-night"`

**Neovim Color Override Approach:**
- Colors overridden via function callback to modify base colorscheme at load time
- Direct color object mutation: `colors.bg = "#000000"`, `colors.bg_dark = "#000000"`

## Comments and Documentation

**When to Comment:**
- Comments explain the "why" of non-obvious configuration decisions
- Used for section dividers: `# ----------------------------------------------------------`
- Document rationale for overrides: "AMOLED Opacity Fix", "Border Colors"
- Explain complex gradient purposes: "Cool-to-warm gradient: cyan/blue at low usage -> purple/magenta at high usage"

**Comment Style:**
- Single `#` for inline comments: `# Clawmarchy btop theme`
- Multiple `#` chars for visual separators: `# ----------------------------------------------------------`
- Comments placed above configuration blocks they describe
- Clear hierarchy: main comment, then sub-explanations

**Documentation in Files:**
- Header comments at top of config files identify purpose: `# Clawmarchy AMOLED Dark Theme`
- Inline documentation for technical constraints: `# Main background, empty for terminal default...`
- Color palette files include description of gradient purpose: `# CPU graph colors (cyan -> blue -> magenta) -- CORE GRADIENT`

## Configuration Organization

**Hierarchical Grouping:**
- Related settings grouped together with comments: Btop theme groups temperature, CPU, memory, disk, network, and process colors
- Hyprland configuration organized by FX codes: FX-02 for borders, FX-01 for opacity fixes
- Named sections using Hyprland syntax: `general { ... }`, `group { ... }`, `decoration { ... }`, `animations { ... }`

**Color Palette Consistency:**
- Primary palette defined in `colors.toml`: accent (#7B6CBD), foreground (#E8E0D0), background (#000000)
- Palette colors referenced across other configs: same color codes appear in btop.theme, hyprland.conf
- 16-color ANSI palette (color0-color15) defined once, used by all applications
- Gradient definitions use the base palette colors: temp_start, temp_mid, temp_end pick from color palette

## Configuration Values

**Colors:**
- All colors use 6-digit hex: `#7B6CBD` (never abbreviated as #7BC)
- AMOLED pure black is consistent: `#000000` everywhere
- Off-white text color consistent: `#E8E0D0` for foreground/text

**Numeric Values:**
- Opacity/alpha as final hex digits: `rgba(00000088)` = 53% opacity
- Blur settings as integers: `size = 6`, `passes = 2`, `noise = 0.02`
- Animation bezier curves as floating point: `0.36, 0, 0.66, -0.56`
- Animation timing in milliseconds: `animation = windows, 1, 4, overshot, slide` (1=duration)

**Boolean/Flags:**
- Lua style true/false: `enabled = true`, `new_optimizations = true`
- Hyprland rule format: `windowrule = opacity 1.0 1.0, match:class .*`

## Best Practices Observed

**Color Theming:**
- Define color palette once in central location (`colors.toml`)
- Reference palette colors in other configs using the exact hex values
- Use semantic color names (accent, foreground, selection) rather than generic names
- Provide both standard and bright variants for ANSI colors

**Configuration DRY (Don't Repeat Yourself):**
- Central `colors.toml` serves as single source of truth for colors
- Hyprland border colors consistently use `$activeBorderColor` variable reference
- Comments explain purpose of each section to prevent incorrect modifications

**Dark Theme Specifics:**
- Document AMOLED-specific constraints: 1.0 opacity needed for true black (no gray wash)
- Explain gradient rationales for readability: cool colors for low usage, warm for high usage
- Test colors work across multiple applications: terminal, btop, Hyprland, Neovim, VSCode

## Module Design

**Configuration Files as Modules:**
- Each file handles one tool's configuration: btop.theme, hyprland.conf, neovim.lua, etc.
- Neovim.lua uses lazy-loading plugin format with separate specs for each plugin
- No cross-file imports except via shared color values
- Each config self-contained with necessary defaults and overrides

**Extending the Theme:**
- New application configs follow same TOML/conf/JSON/Lua pattern
- Color palette (`colors.toml`) extensible with new semantic keys
- Gradient definitions in btop.theme are documented pattern to copy for new meters
- Hyprland config pattern clear for adding new visual effects (FX-codes)

