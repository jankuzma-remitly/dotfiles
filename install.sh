#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    echo "Backing up existing $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -s "$src" "$dst"
  echo "Linked $dst -> $src"
}

if command -v brew &>/dev/null; then
  brew bundle check --file="$DOTFILES/Brewfile" || brew bundle --file="$DOTFILES/Brewfile"
else
  echo "Homebrew not found - skipping brew bundle"
fi

link "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES/yabai/.yabairc" "$HOME/.yabairc"
link "$DOTFILES/hammerspoon" "$HOME/.hammerspoon"
mkdir -p "$HOME/.config"
link "$DOTFILES/nvim" "$HOME/.config/nvim"
link "$DOTFILES/alacritty" "$HOME/.config/alacritty"

if [ ! -f "$HOME/.secrets" ]; then
  echo "# Machine-specific secrets - NEVER commit this file" > "$HOME/.secrets"
  chmod 600 "$HOME/.secrets"
  echo "Created empty ~/.secrets - add your keys there"
fi

echo "Done!"
