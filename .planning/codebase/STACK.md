# Technology Stack

**Analysis Date:** 2026-02-18

## Languages

**Primary:**
- TOML - `colors.toml` configuration file defining color palette
- Shell/Bash - Installation via omarchy command-line tools
- Lua - Neovim plugin configuration (`neovim.lua`)
- Conf - Hyprland window manager configuration (`hyprland.conf`)
- Theme file format - btop status monitor theme (`btop.theme`)
- JSON - VS Code theme reference (`vscode.json`)

**Secondary:**
- PNG - Image assets for wallpapers and previews (`backgrounds/`, `preview.png`, `wallpaper-preview.png`)

## Runtime

**Environment:**
- Omarchy framework - Theme installation and management system
- Hyprland - Window manager (Linux/Wayland)
- Neovim - Text editor with Lua plugin system
- btop - System resource monitor
- VS Code - Code editor
- Terminal - Display and color rendering

**Package Manager:**
- Omarchy package system - Handles theme distribution and installation
- Neovim plugin manager (LazyVim) - Referenced but not directly managed in this repo

## Frameworks & Tools

**Theme/Configuration:**
- Omarchy - Theme framework for unified system theming
- Hyprland - Window manager with customizable decorations and animations
- btop - Terminal status monitor with custom themes

**Editor/IDE Integrations:**
- Neovim - Lua-based configuration integration
- VS Code - Extension-based theme system
- LazyVim - Neovim distribution used for plugin management

**Color Management:**
- TOML-based palette definition - Centralized color scheme (`colors.toml`)

## Key Dependencies

**Framework Dependencies:**
- Omarchy - Core theme framework for installation/management
  - Provides `omarchy-theme-install` and `omarchy-theme-set` commands
  - Handles theme application across system components

**Neovim Plugin Dependencies:**
- folke/tokyonight.nvim - Tokyo Night colorscheme for Neovim
  - Used as base colorscheme with AMOLED black overrides
  - Priority: 1000 (loaded early)
  - Customized for `tokyonight-night` style

- LazyVim/LazyVim - Neovim distribution
  - Provides plugin manager and configuration structure
  - Used to set colorscheme to `tokyonight-night`

**Desktop Environment:**
- Yaru-purple-dark - GTK icon theme (`icons.theme`)
  - Used for consistent icon styling across GTK applications

**VS Code:**
- Tokyo Night extension - enkia.tokyo-night
  - Referenced in `vscode.json` for editor theme

## Configuration

**Environment:**
- No runtime environment variables required
- No secrets or credentials needed
- Static configuration files only

**Build/Installation:**
- Installation command: `omarchy-theme-install https://github.com/AsemHub/omarchy-clawmarchy-theme`
- Theme switching command: `omarchy-theme-set <theme-name>`

**Configuration Files:**
- `colors.toml` - Master color palette (16 colors + accent, cursor, foreground, background, selection)
- `hyprland.conf` - Window manager styling (borders, opacity, decorations, animations)
- `btop.theme` - System monitor theme with gradients
- `neovim.lua` - Neovim colorscheme configuration
- `vscode.json` - VS Code theme reference
- `icons.theme` - GTK icon theme name

## Design Specifications

**Color Palette:**
- Background: `#000000` (AMOLED true black)
- Accent: `#7B6CBD` (muted blue-violet)
- Foreground: `#E8E0D0` (warm off-white)
- 16-color terminal palette with warm/cool gradients
- Red: `#C45B6E`, Green: `#6EA88E`, Blue: `#6E8EC4`, Purple: `#9B7BC8`, Cyan: `#5AA8B5`

**Visual Effects:**
- Hyprland blur: 6px, 2 passes, 0.02 noise, 0.8 brightness
- Hyprland shadows: 12px range, power 3, semi-transparent black
- Hyprland animations: smooth bezier curves with overshot timing
- Window opacity: 1.0 (no transparency to prevent gray wash on black)

**Wallpapers:**
- 5 curated anime wallpapers in `backgrounds/` directory
- Dark atmospheric scenes with purple/cyan tones
- Source: Wallhaven community

## Platform Requirements

**Development:**
- Linux system with Wayland/Hyprland support
- Omarchy framework installed
- Git for cloning theme repository

**Production/Target Platforms:**
- Linux with Hyprland window manager
- Neovim (optional, for Neovim users)
- btop (optional, for system monitoring visualization)
- VS Code (optional, for code editor styling)
- GTK-based applications (uses Yaru-purple-dark icons)
- POSIX-compliant shell for theme installation scripts

**Hardware:**
- Display with color support
- No special hardware requirements

---

*Stack analysis: 2026-02-18*
