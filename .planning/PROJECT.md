# Clawmarchy Theme

## What This Is

A customizable AMOLED dark theme for Omarchy with neon purple accents and curated anime wallpapers. Covers the full Hyprland desktop stack — window manager, status bar, launcher, notifications, terminals, editors, and system monitors. Designed to be community-ready: installable, customizable via CLI, and available in multiple accent color variants.

## Core Value

Every visible element on an Omarchy desktop is consistently themed with AMOLED true black and the user's chosen accent color — no gray wash, no mismatched apps, no manual config editing.

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

- ✓ AMOLED true black (#000000) backgrounds across all themed apps — existing
- ✓ Muted blue-violet accent (#7B6CBD) for borders, highlights, UI elements — existing
- ✓ Hyprland window borders, blur, shadows, and animations — existing
- ✓ btop system monitor theme with cyan-to-magenta gradient mapping — existing
- ✓ Neovim tokyonight-night with AMOLED black overrides — existing
- ✓ VS Code Tokyo Night extension reference — existing
- ✓ Yaru-purple-dark GTK icon theme — existing
- ✓ 5 curated anime wallpapers with purple/cyan tones — existing
- ✓ 16-color ANSI terminal palette defined in colors.toml — existing
- ✓ One-command install via omarchy-theme-install — existing

### Active

<!-- Current scope. Building toward these. -->

- [ ] Waybar status bar themed with AMOLED black and accent colors
- [ ] Walker app launcher themed consistently with desktop
- [ ] Mako notification popups styled with theme colors
- [ ] Replace global opacity hack with targeted Hyprland window rules
- [ ] Full VS Code workspace color customizations (not just extension reference)
- [ ] Single source of truth color system — all configs generated from colors.toml
- [ ] CLI customization tool for changing accent color across all configs
- [ ] Accent color swap variants (blue, teal, red, etc. on same AMOLED black base)
- [ ] Expanded wallpaper collection beyond current 5
- [ ] Documentation: troubleshooting, compatibility, customization guide

### Out of Scope

<!-- Explicit boundaries. Includes reasoning to prevent re-adding. -->

- Full palette variants (Dracula, Gruvbox, etc.) — keep AMOLED black identity, only swap accents
- Ghostty terminal config — not requested for this iteration
- Mobile/tablet theming — Omarchy is desktop Linux only
- Automated visual regression testing — manual verification sufficient for theme work
- X11/non-Wayland support — Omarchy targets Hyprland/Wayland exclusively

## Context

Clawmarchy is a theme package for the Omarchy Linux desktop framework created by DHH. Omarchy provides `omarchy-theme-install` and `omarchy-theme-set` commands that handle theme distribution and application across system components.

The current theme works well for its covered apps (Hyprland, btop, Neovim, VS Code, icons) but has gaps:
- Waybar, Walker, and Mako are visible desktop elements without theme coverage
- Colors are manually duplicated across config files — the same hex values appear in 5+ files with no generation step
- The Hyprland opacity fix uses a global catch-all rule that could break transparency-dependent apps
- VS Code config only references the extension, missing workspace-level AMOLED customizations

The color sync problem is foundational — solving it (colors.toml as true source, configs generated from it) enables both the CLI tool and accent variants naturally.

## Constraints

- **Framework**: Must follow Omarchy theme conventions — standard file names, formats, and installation flow
- **Compatibility**: Hyprland/Wayland only, LazyVim for Neovim, Omarchy package system
- **Performance**: Effects (blur, shadows) should work on integrated graphics without noticeable lag
- **Assets**: Wallpapers should be dark atmospheric scenes that work with any accent color variant

## Key Decisions

<!-- Decisions that constrain future work. Add throughout project lifecycle. -->

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| AMOLED black base is constant across all variants | Core identity of the theme — accent colors change, black stays | — Pending |
| CLI tool for customization (not config file) | Lower friction for users, consistent output | — Pending |
| colors.toml as single source of truth | Enables generation, prevents drift, powers CLI and variants | — Pending |
| Accent swap variants, not full palette variants | Keeps theme coherent, manageable scope | — Pending |

---
*Last updated: 2026-02-18 after initialization*
