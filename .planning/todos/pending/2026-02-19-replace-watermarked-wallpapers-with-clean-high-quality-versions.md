---
created: 2026-02-19T23:05:05.116Z
title: Replace watermarked wallpapers with clean high-quality versions
area: general
files:
  - backgrounds/1-sakura-cherry-blossoms.png
  - backgrounds/2-ocean-midnight-harbor.png
  - backgrounds/3-tide-underwater-shrine.png
  - backgrounds/4-ember-lantern-festival.png
  - backgrounds/5-moss-forest-shrine.png
  - backgrounds/qhd/
  - preview.png
---

## Problem

All 5 wallpaper images in `backgrounds/` have visible watermarks baked into the source assets. The image quality is also subpar — user flagged both issues during Phase 5 preview screenshot review. Since `preview.png` uses the Ember wallpaper as its desktop background, the watermark is visible in the repo's GitHub landing page screenshot too.

These are the anime-style wallpapers paired to each accent variant (sakura, ocean, tide, ember, moss). The yoru (default) variant has no paired wallpaper.

## Solution

Source or generate watermark-free versions of all 5 wallpapers matching the current scenes (cherry blossoms, midnight harbor, underwater shrine, lantern festival, forest shrine). Regenerate QHD downscaled versions in `backgrounds/qhd/`. Retake `preview.png` with the clean Ember wallpaper.

Options:
- Commission or AI-generate replacements matching the theme aesthetic
- Purchase stock/licensed versions of the current images
- Find CC0/open-license anime landscape art as replacements
