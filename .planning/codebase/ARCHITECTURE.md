# Architecture

**Analysis Date:** 2026-02-18

## Pattern Overview

**Overall:** Theme Configuration Pattern (Multi-tool Theme Suite)

**Key Characteristics:**
- Decentralized configuration files targeting different tools and environments
- Color palette inheritance through a single source-of-truth definition
- Tool-specific format adapters (TOML, JSON, Lua, custom conf)
- AMOLED-first design philosophy with true black (#000000) as primary background
- Gradient-based visual language for data representation and UI elements

## Layers

**Color Definition Layer:**
- Purpose: Define and standardize the core color palette used across all tools
- Location: `colors.toml`
- Contains: Base colors (background, foreground, accent), ANSI color codes (color0-color15), selection colors, cursor color
- Depends on: No dependencies (source of truth)
- Used by: All tool-specific configuration files that reference hex values

**Tool Integration Layer:**
- Purpose: Adapt color definitions and styling to specific application formats
- Locations:
  - `btop.theme` - System monitor theme (btop)
  - `hyprland.conf` - Wayland compositor configuration (Hyprland)
  - `neovim.lua` - Neovim editor configuration
  - `vscode.json` - VS Code theme extension reference
  - `icons.theme` - GTK icon theme specification
- Depends on: Color Definition Layer (references hex colors and styling concepts)
- Used by: User's system when loading the theme

**Asset Layer:**
- Purpose: Provide curated visual assets that complement the color scheme
- Location: `backgrounds/`
- Contains: 5 PNG wallpapers (1-5-*.png files) with dark atmospheric scenes matching purple/cyan tone palette
- Depends on: Color Definition Layer (assets must be perceptually compatible with palette)
- Used by: Desktop environment as wallpapers

**Documentation Layer:**
- Purpose: Explain theme features, installation, and palette composition
- Locations: `README.md`, `LICENSE`
- Depends on: All other layers (documents reference features across the suite)

## Data Flow

**Installation Flow:**

1. User invokes `omarchy-theme-install` command with GitHub repository URL
2. Theme manager clones repository into Omarchy themes directory
3. Theme manager reads all configuration files:
   - `colors.toml` → Parsed as TOML for color palette
   - `btop.theme` → Applied to btop monitor configuration
   - `hyprland.conf` → Merged into Hyprland configuration
   - `neovim.lua` → Incorporated into Neovim LazyVim plugin chain
   - `vscode.json` → References VS Code extension
   - `icons.theme` → Applied to GTK environment
   - `backgrounds/` → Available for wallpaper selection
4. Theme becomes active across all configured applications

**Color Inheritance Flow:**

1. Core palette defined in `colors.toml` with semantic naming (accent, background, foreground)
2. Color values referenced in tool-specific configs maintain visual consistency:
   - Accent color (#7B6CBD) used for:
     - Hyprland active window borders
     - btop highlight and box outlines
     - Selection background in terminals
   - Background color (#000000) used for:
     - AMOLED compliance (true black)
     - Hyprland and btop backgrounds
     - Neovim background overrides
   - Foreground/text color (#E8E0D0) used across all tools
3. Gradient definitions in `btop.theme` use base colors from palette for:
   - CPU/Memory usage visualization (cyan → blue → magenta)
   - Temperature representation (cyan → purple → red)

**Rendering Flow:**

1. Hyprland loads border colors and applies blur/shadow decoration effects
2. btop renders system metrics with gradient-mapped values
3. Neovim initializes with AMOLED black background override
4. Terminal inherits color palette via ANSI color definitions
5. VS Code applies Tokyo Night extension with color overrides

**State Management:**

- Static configuration: All theme settings are defined at installation time
- No runtime state: Theme is applied once during boot/session initialization
- No inter-tool communication: Each tool independently reads its configuration file

## Key Abstractions

**Color Palette:**
- Purpose: Represent visual identity and ensure consistency across all tools
- Examples: `colors.toml` (authoritative), references in `btop.theme`, `hyprland.conf`
- Pattern: Semantic color names (accent, background, foreground) mapped to hex values; numeric ANSI slots (color0-15) for terminal compatibility

**Gradient Maps:**
- Purpose: Create visual meaning through color progression (cool-to-warm representing low-to-high values)
- Examples: `btop.theme` temperature gradient, CPU usage gradient, memory meter gradient
- Pattern: Define start → mid → end colors for multi-point gradients; used for data visualization

**Tool Configuration Adapters:**
- Purpose: Transform a unified design vision into tool-specific configuration formats
- Examples: `colors.toml` (TOML), `btop.theme` (custom key=value), `hyprland.conf` (custom), `neovim.lua` (Lua table), `vscode.json` (JSON)
- Pattern: Each tool uses its native configuration language while maintaining semantic alignment

**AMOLED Compliance Overrides:**
- Purpose: Ensure true black rendering without wallpaper bleed-through
- Examples: `hyprland.conf` opacity rule, `neovim.lua` background color override
- Pattern: Explicit 1.0 opacity and color overrides to prevent alpha blending that causes gray wash

## Entry Points

**Installation Entry Point:**
- Location: Repository root (theme is installed via `omarchy-theme-install` command)
- Triggers: User runs theme installation command with repository URL
- Responsibilities: Theme manager reads all configuration files and applies them to corresponding system applications

**Theme Application Entry Point (Hyprland):**
- Location: `hyprland.conf`
- Triggers: Wayland session initialization
- Responsibilities: Apply border colors, opacity fixes, blur/shadow effects, and animations

**Color Palette Entry Point:**
- Location: `colors.toml`
- Triggers: Application initialization that needs color definitions
- Responsibilities: Provide canonical color values referenced by all tool-specific configs

**Neovim Entry Point:**
- Location: `neovim.lua`
- Triggers: Neovim startup with LazyVim plugin manager
- Responsibilities: Load tokyonight colorscheme and apply AMOLED background overrides

**System Monitor Entry Point:**
- Location: `btop.theme`
- Triggers: btop application launch
- Responsibilities: Apply theme colors and gradients to system monitoring display

## Error Handling

**Strategy:** Static configuration with no runtime validation

**Patterns:**
- No error handling required (configuration is static, set at installation)
- Invalid color hex values in tool configs would be caught by individual applications at startup
- Missing configuration files would result in application-specific fallback behavior (each tool has defaults)
- Tool-specific format errors (malformed TOML, JSON, Lua) caught by application parser at load time

## Cross-Cutting Concerns

**Color Consistency:** Maintained through `colors.toml` as single source of truth; all tool-specific configs reference hex values from this palette

**AMOLED Compliance:** True black (#000000) used throughout; explicit opacity overrides in `hyprland.conf` prevent wallpaper bleed-through; Neovim background override ensures editor maintains AMOLED black

**Gradient Mapping:** btop theme uses consistent gradient progression (cool-to-warm cyan-to-magenta) across CPU, memory, temperature, and network metrics for visual coherence

**Animation & Effects:** Hyprland animations (windows, fade, workspaces) provide smooth transitions; blur and shadow effects create depth while maintaining AMOLED aesthetic

---

*Architecture analysis: 2026-02-18*
