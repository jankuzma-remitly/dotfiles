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

link "$DOTFILES/yabai/.yabairc" "$HOME/.yabairc"
link "$DOTFILES/hammerspoon" "$HOME/.hammerspoon"
mkdir -p "$HOME/.config"
link "$DOTFILES/nvim" "$HOME/.config/nvim"

if ! grep -q 'dotfiles/zsh/aliases.zsh' "$HOME/.zshrc" 2>/dev/null; then
  echo "" >> "$HOME/.zshrc"
  echo "source ~/dotfiles/zsh/aliases.zsh" >> "$HOME/.zshrc"
  echo "Added aliases.zsh source line to .zshrc"
else
  echo "aliases.zsh already sourced in .zshrc"
fi

if ! grep -q 'source ~/.secrets' "$HOME/.zshrc" 2>/dev/null; then
  echo 'source ~/.secrets 2>/dev/null' >> "$HOME/.zshrc"
  echo "Added .secrets source line to .zshrc"
else
  echo ".secrets already sourced in .zshrc"
fi

if [ ! -f "$HOME/.secrets" ]; then
  echo "# Machine-specific secrets - NEVER commit this file" > "$HOME/.secrets"
  chmod 600 "$HOME/.secrets"
  echo "Created empty ~/.secrets - add your keys there"
fi

echo "Done!"
