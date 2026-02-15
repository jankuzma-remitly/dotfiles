# Alacritty & Tmux Theme Guide

## 🎨 Current Setup

Your terminal is now configured with beautiful, modern themes that work together seamlessly!

### Alacritty
- **Current Theme**: Catppuccin Mocha (dark, modern, easy on the eyes)
- **Font**: MesloLGS Nerd Font Mono (supports icons and special characters)
- **Opacity**: 95% with blur effect for a sleek look

### Tmux
- **Theme**: Catppuccin Mocha (matches Alacritty perfectly)
- **Separators**: Powerline symbols for a modern appearance
- **Status Bar**: Enhanced with emojis and useful information

---

## 🔄 Switching Alacritty Themes

Use the provided script to easily switch themes:

```bash
~/.config/alacritty/switch-theme.sh <theme-name>
```

### Recommended Themes

#### Dark Themes (Best for coding)
- **catppuccin_mocha** ⭐ (Current) - Warm, modern, excellent contrast
- **dracula** - Classic dark theme, very popular
- **nord** - Cool blues and greens, very professional
- **tokyonight** - Modern, inspired by Tokyo's night lights
- **gruvbox_dark** - Retro groove, warm colors
- **everforest_dark** - Forest-inspired, easy on eyes
- **one_dark** - Atom's popular dark theme

#### Light Themes (For daytime coding)
- **catppuccin_latte** - Light version of Catppuccin
- **github_light** - Clean GitHub light theme
- **dayfox** - Light, modern theme

---

## 📝 Manual Theme Switching

Edit `~/.config/alacritty/alacritty.toml` and change the import line:

```toml
[general]
import = [
  "~/.config/alacritty/themes/themes/dracula.toml"
]
```

Then restart Alacritty.

---

## 🎯 Tmux Theme Customization

Your Tmux theme is configured in `~/.config/tmux/oh-my-tmux/.tmux.conf.local`

The colors are based on Catppuccin Mocha palette:
- **Base**: #1E1E2E (dark background)
- **Text**: #CDD6F4 (bright foreground)
- **Accent**: #89B4FA (blue)
- **Highlight**: #A6E3A1 (green)

---

## 💡 Tips

1. **Reload Tmux**: `tmux source-file ~/.config/tmux/oh-my-tmux/.tmux.conf.local`
2. **Restart Alacritty**: Close and reopen the terminal
3. **Font Issues**: Ensure MesloLGS Nerd Font is installed: `brew install font-meslo-lg-nerd-font`
4. **Powerline Symbols**: Already included in Nerd Fonts

Enjoy your beautiful terminal! 🚀

