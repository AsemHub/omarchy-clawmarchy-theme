# External Integrations

**Analysis Date:** 2026-02-18

## APIs & External Services

**Not Applicable:**
- No external APIs are called
- No remote service integrations
- No webhooks or callbacks
- Theme operates entirely through local system configuration

## Data Storage

**Databases:**
- Not used - Theme is configuration-only

**File Storage:**
- Local filesystem only
- Wallpapers stored in `backgrounds/` directory
- Configuration files stored in repository root
- No cloud storage or CDN integration

**Caching:**
- Not applicable - No data layer

## Authentication & Identity

**Auth Provider:**
- Not required - Theme applies through system configuration
- Installation via Omarchy handles theme distribution only

## Monitoring & Observability

**Error Tracking:**
- Not applicable

**Logs:**
- Not configured - Theme has no runtime logging

## CI/CD & Deployment

**Hosting:**
- GitHub repository: `https://github.com/AsemHub/omarchy-clawmarchy-theme`
- Distribution via Omarchy package system

**CI Pipeline:**
- Not detected - Static configuration repository

## Environment Configuration

**Required Environment Variables:**
- None - Theme requires no environment configuration

**Configuration Files:**
- `colors.toml` - Master color palette
- `hyprland.conf` - Hyprland window manager settings
- `btop.theme` - System monitor theme
- `neovim.lua` - Neovim colorscheme
- `vscode.json` - VS Code theme metadata
- `icons.theme` - Icon theme name

**Secrets Location:**
- Not applicable - No credentials or secrets needed

## Installation & Distribution

**Installation Method:**
- Omarchy command: `omarchy-theme-install https://github.com/AsemHub/omarchy-clawmarchy-theme`
- Handled by Omarchy framework's package management system

**Theme Selection:**
- Omarchy command: `omarchy-theme-set clawmarchy` (after installation)
- Switches active theme across all configured applications

## Package Dependencies

**Framework Integration:**
- Omarchy framework - Manages theme installation and activation
  - Repository location: `https://omarchy.com`
  - Role: Theme distribution and application

**Neovim Plugin Dependencies:**
- folke/tokyonight.nvim - Neovim colorscheme
  - Repository: `https://github.com/folke/tokyonight.nvim`
  - Integration: Lua configuration in `neovim.lua` overrides background colors for AMOLED black

**Desktop Environment Dependencies:**
- Yaru-purple-dark GTK icon theme
  - System package (usually from distribution repositories)
  - Configured via `icons.theme` file

**VS Code Integration:**
- Tokyo Night VS Code extension (enkia.tokyo-night)
  - Optional extension referenced in `vscode.json`
  - Not required for core theme functionality

## Wallpaper Integration

**Image Assets:**
- 5 PNG wallpapers in `backgrounds/` directory:
  - `1-cyberpunk-neon-city.png` (2.4 MB)
  - `2-dark-atmospheric-shrine.png` (3.9 MB)
  - `3-character-silhouette.png` (6.5 MB)
  - `4-neon-rain-street.png` (5.4 MB)
  - `5-moonlit-landscape.png` (10.0 MB)

**Source:**
- Wallhaven.cc community collection
- Dark atmospheric scenes with purple/cyan color compatibility

## System Integration Points

**Hyprland Integration:**
- Window manager border colors: `#7B6CBD` (muted blue-violet)
- Window opacity override: 1.0 (prevents transparency-induced gray wash)
- Blur effect: 6px with 2 passes, 0.02 noise, 0.8 brightness
- Shadow effect: 12px range, power 3
- Animation timing: smooth bezier curves with overshot easing

**Terminal Integration:**
- TOML color palette (`colors.toml`) with 16-color definition
- Compatible with terminal emulators supporting true color
- AMOLED black background: `#000000`
- Accent color for UI elements: `#7B6CBD`

**System Monitor Integration:**
- btop theme file configures:
  - Gradient visualizations (temperature, CPU, memory, network)
  - Color mapping for usage metrics
  - UI element styling and contrast

## Webhooks & Callbacks

**Incoming:**
- Not applicable

**Outgoing:**
- Not applicable

---

*Integration audit: 2026-02-18*
