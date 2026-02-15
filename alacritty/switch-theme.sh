#!/bin/bash

# Alacritty Theme Switcher
# Usage: switch-theme.sh <theme-name>
# Example: switch-theme.sh dracula

ALACRITTY_CONFIG="$HOME/.config/alacritty/alacritty.toml"
THEMES_DIR="$HOME/.config/alacritty/themes/themes"

# List of available themes
THEMES=(
  "catppuccin_mocha"
  "catppuccin_macchiato"
  "catppuccin_frappe"
  "dracula"
  "nord"
  "tokyonight"
  "gruvbox_dark"
  "ayu_dark"
  "everforest_dark"
  "one_dark"
  "github_dark"
)

# Function to display available themes
show_themes() {
  echo "Available themes:"
  for theme in "${THEMES[@]}"; do
    if [ -f "$THEMES_DIR/$theme.toml" ]; then
      echo "  ✓ $theme"
    fi
  done
}

# Function to switch theme
switch_theme() {
  local theme=$1
  
  if [ ! -f "$THEMES_DIR/$theme.toml" ]; then
    echo "❌ Theme '$theme' not found!"
    show_themes
    exit 1
  fi
  
  # Update the import line in alacritty.toml
  sed -i '' "s|import = \[.*\]|import = [\n  \"~/.config/alacritty/themes/themes/$theme.toml\"\n]|" "$ALACRITTY_CONFIG"
  
  echo "✅ Theme switched to: $theme"
  echo "💡 Restart Alacritty to see the changes"
}

# Main logic
if [ -z "$1" ]; then
  show_themes
  echo ""
  echo "Usage: $0 <theme-name>"
  echo "Example: $0 dracula"
else
  switch_theme "$1"
fi

