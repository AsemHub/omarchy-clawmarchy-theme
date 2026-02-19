#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
THEME_NAME="clawmarchy"
THEMES_DIR="$HOME/.config/omarchy/themes"
THEME_PATH="$THEMES_DIR/$THEME_NAME"
WORKSPACE=3
SCREENSHOT_PATH="$REPO_DIR/preview.png"
CURRENT_BG_LINK="$HOME/.config/omarchy/current/background"
SLEEP=1

echo "=== Clawmarchy Preview Screenshot ==="
echo ""

# --- Step 1: Install theme from local repo ---
echo "[1/8] Installing theme from local repo..."
mkdir -p "$THEMES_DIR"
rm -rf "$THEME_PATH"
ln -sf "$REPO_DIR" "$THEME_PATH"
echo "  Symlinked $REPO_DIR -> $THEME_PATH"

# --- Step 2: Switch to ember variant ---
echo "[2/8] Switching to ember variant..."
"$REPO_DIR/clawmarchy-variant" ember
sleep 2
echo "  Ember variant active, theme applied"

# --- Step 3: Force ember wallpaper ---
echo "[3/8] Setting ember wallpaper..."
EMBER_BG="$HOME/.config/omarchy/current/theme/backgrounds/4-ember-lantern-festival.png"
ln -nsf "$EMBER_BG" "$CURRENT_BG_LINK"
pkill -x swaybg 2>/dev/null || true
setsid uwsm-app -- swaybg -i "$CURRENT_BG_LINK" -m fill >/dev/null 2>&1 &
sleep 2
echo "  Ember wallpaper set"

# --- Step 4: Switch to workspace 3 and clean it ---
echo "[4/8] Switching to workspace $WORKSPACE and cleaning..."
hyprctl dispatch workspace "$WORKSPACE"
sleep "$SLEEP"

# Close ALL existing windows on this workspace
EXISTING=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $WORKSPACE) | .address")
for addr in $EXISTING; do
  hyprctl dispatch closewindow "address:$addr" 2>/dev/null || true
done
sleep "$SLEEP"

# Double-check — close any stragglers
REMAINING=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $WORKSPACE) | .address")
for addr in $REMAINING; do
  hyprctl dispatch closewindow "address:$addr" 2>/dev/null || true
done
sleep "$SLEEP"

# --- Step 5: Launch btop ---
echo "[5/8] Launching btop..."
ghostty -e btop &
sleep 3

# --- Step 6: Launch nvim ---
echo "[6/8] Launching nvim..."
ghostty -e nvim "$REPO_DIR/README.md" &
sleep 3

# Unfocus to show both tiled cleanly
hyprctl dispatch cyclenext
sleep "$SLEEP"

# --- Step 7: Open Walker launcher overlay ---
echo "[7/8] Opening Walker launcher..."
walker &
sleep 2

# --- Step 8: Take screenshot ---
echo "[8/8] Taking screenshot..."
grim "$SCREENSHOT_PATH"

# Kill walker after screenshot
pkill -x walker 2>/dev/null || true

# Check result
if [ -f "$SCREENSHOT_PATH" ]; then
  SIZE=$(du -h "$SCREENSHOT_PATH" | cut -f1)
  echo ""
  echo "=== Screenshot captured ==="
  echo "  Path: $SCREENSHOT_PATH"
  echo "  Size: $SIZE"
  echo ""
  echo "Done! preview.png is ready in the repo root."
else
  echo "ERROR: Screenshot failed!"
  exit 1
fi
