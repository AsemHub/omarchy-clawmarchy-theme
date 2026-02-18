# Codebase Structure

**Analysis Date:** 2026-02-18

## Directory Layout

```
omarchy-clawmarchy-theme/
├── colors.toml              # Core color palette definition (source of truth)
├── btop.theme               # System monitor (btop) theme with gradient mappings
├── hyprland.conf            # Wayland compositor (Hyprland) configuration
├── neovim.lua               # Neovim editor configuration (LazyVim plugin format)
├── vscode.json              # VS Code theme extension reference
├── icons.theme              # GTK icon theme specification
├── backgrounds/             # Curated anime wallpapers directory
│   ├── 1-cyberpunk-neon-city.png
│   ├── 2-dark-atmospheric-shrine.png
│   ├── 3-character-silhouette.png
│   ├── 4-neon-rain-street.png
│   └── 5-moonlit-landscape.png
├── README.md                # Theme documentation and feature overview
├── LICENSE                  # License file (proprietary/open source)
├── preview.png              # Desktop screenshot showing theme applied
├── wallpaper-preview.png    # Large wallpaper preview image
└── .git/                    # Git repository metadata
```

## Directory Purposes

**Root Directory:**
- Purpose: Contains all theme configuration files and assets
- Contains: Configuration files (TOML, Lua, JSON, custom formats), image assets, documentation
- Key files: `colors.toml`, `README.md`, configuration for each supported tool

**backgrounds/:**
- Purpose: Stores curated anime wallpapers that complement the theme's color palette and aesthetic
- Contains: PNG image files (2.3MB-9.6MB each)
- Key files: All 5 numbered wallpapers follow naming pattern `[number]-[description].png`
- Usage: Users select one as their desktop wallpaper; chosen wallpaper becomes theme backdrop

## Key File Locations

**Entry Points:**

- `colors.toml`: Primary color palette definition; referenced by all tool-specific configs
- `hyprland.conf`: Hyprland compositor initialization; applies theme at session start
- `neovim.lua`: Neovim plugin configuration; loaded during editor startup
- `btop.theme`: System monitor theme; applied when btop launches
- `README.md`: Theme documentation; first point of reference for users

**Configuration:**

- `colors.toml`: TOML format defining semantic colors (accent, background, foreground) and ANSI codes (color0-color15)
- `btop.theme`: btop-specific theme format with gradient definitions and meter colors
- `hyprland.conf`: Hyprland configuration syntax with window rules, animations, decorations
- `neovim.lua`: Lua table format for LazyVim plugin specification
- `vscode.json`: JSON format referencing external VS Code extension
- `icons.theme`: Simple text file naming GTK icon theme

**Core Logic (Theme Design):**

- `colors.toml`: Defines core palette (purple accent #7B6CBD, true black background #000000, warm off-white foreground #E8E0D0)
- `btop.theme`: Implements gradient-mapped visualization logic (CPU, memory, temperature, network metrics)
- `hyprland.conf`: Implements AMOLED compliance (opacity 1.0 for true black) and visual effects (blur, shadows, animations)

**Visual Assets:**

- `backgrounds/`: All 5 anime wallpapers numbered 1-5 with descriptive names
- `preview.png`: Desktop screenshot (1010KB) showing complete theme
- `wallpaper-preview.png`: Large wallpaper demonstration (9.1MB)

## Naming Conventions

**Files:**

- Configuration files: Kebab-case with tool name suffix (`hyprland.conf`, `btop.theme`, `neovim.lua`, `vscode.json`)
- Color palette: Literal `colors.toml` (singular source)
- Assets: Numbered prefix for ordering (`1-`, `2-`, `3-`, `4-`, `5-`) followed by descriptive kebab-case name
- Documentation: Uppercase singular nouns (`README.md`, `LICENSE`)
- Preview/demo images: Descriptive kebab-case with `preview` or `wallpaper` prefix

**Directories:**

- `backgrounds/`: Plural form indicating collection of multiple assets
- No subdirectories for organization (flat structure for theme simplicity)

**Color References:**

- TOML keys: Snake_case semantic names (`accent`, `foreground`, `background`, `color0`-`color15`)
- Hex format: Lowercase 6-character codes (e.g., `#7b6cbd`)

## Where to Add New Code

**New Tool Integration:**

- Primary: Create new configuration file at root level with pattern `[toolname].[ext]`
- Example: Adding support for new tool would create `konsole.json` or `alacritty.yml`
- Reference: Must include colors from `colors.toml` to maintain palette consistency
- Test: Verify new tool can parse and apply the configuration format

**New Wallpaper Asset:**

- Location: `/backgrounds/` directory
- Naming: Continue numbering sequence (`6-description.png`, `7-description.png`)
- Format: PNG image file (2.3MB-9.6MB typical size)
- Requirements: Dark atmospheric scene with purple/cyan tone compatibility

**Theme Customization/Variants:**

- Current structure supports single theme per repository
- To create variant: Fork repository and modify `colors.toml` hex values across all dependent tool configs
- No branching or versioning inside root (each Git branch = separate theme variant)

**Documentation Updates:**

- Primary: `README.md` for user-facing features and installation
- Palette section: Update if color values change (color badges reference hex values)
- Features section: Add any new tool integrations or wallpaper additions

## Special Directories

**Backgrounds Directory:**

- Purpose: Asset storage for wallpapers
- Generated: No (manually curated)
- Committed: Yes (part of theme distribution)
- Modification: Add new wallpapers; maintain numbering sequence

**.git Directory:**

- Purpose: Git repository metadata
- Generated: Yes (created on `git init`)
- Committed: No (Git internal, not user-modified)
- Modification: Managed by Git commands only

## File Format Reference

**TOML (colors.toml):**
```toml
# Format: key = "value"
accent = "#7B6CBD"          # Used for highlights, borders, selection backgrounds
background = "#000000"      # AMOLED true black, applied to all backgrounds
foreground = "#E8E0D0"      # Text and UI element color
color0 = "#111118"          # ANSI terminal color (black equivalent)
color15 = "#E8E0D0"         # ANSI terminal color (white equivalent)
```

**Custom Theme Format (btop.theme, hyprland.conf):**
```
# Format: theme[key]="value" or key = value
theme[main_bg]="#000000"    # btop background
theme[cpu_start]="#5AA8B5"  # Gradient start color

# Hyprland uses standard config format
$activeBorderColor = rgb(7B6CBD)
general {
    col.active_border = $activeBorderColor
}
```

**Lua (neovim.lua):**
```lua
-- Lua table format for plugin specification
return {
    {
        "plugin/name",
        opts = {
            key = "value",
            on_colors = function(colors)
                colors.bg = "#000000"
            end,
        },
    },
}
```

**JSON (vscode.json):**
```json
{
  "name": "Theme Name",
  "extension": "publisher.extension-id"
}
```

---

*Structure analysis: 2026-02-18*
