# Alacritty Configuration

Your Alacritty terminal has been set up with a modern, efficient configuration!

## What's Installed

✅ **Alacritty** - Fast, GPU-accelerated terminal emulator
✅ **Meslo Nerd Font** - Beautiful monospace font with icon support
✅ **Catppuccin Mocha Theme** - Modern, easy-on-the-eyes color scheme

## Configuration Details

### Window Settings
- **Padding**: 12px on all sides for better aesthetics
- **Decorations**: Buttonless for a clean, minimal look
- **Opacity**: 95% with blur effect for a modern appearance
- **Dimensions**: 120 columns × 40 lines (adjust in `alacritty.toml` if needed)

### Font
- **Font**: MesloLGS Nerd Font Mono (size 14)
- Supports all Nerd Font icons for better terminal experience
- Properly configured for italic, bold, and bold-italic styles

### Keyboard Shortcuts
- `Cmd+C` - Copy
- `Cmd+V` - Paste
- `Cmd+N` - New window
- `Cmd++` - Increase font size
- `Cmd+-` - Decrease font size
- `Cmd+0` - Reset font size

### Other Features
- **Scrollback**: 10,000 lines of history
- **Cursor**: Beam style (Block in vi mode)
- **Selection**: Semantic selection with auto-copy to clipboard
- **Shell**: zsh (default)

## Customization

To customize the configuration, edit:
```
~/.config/alacritty/alacritty.toml
```

### Available Themes
Other Catppuccin themes available in `~/.config/alacritty/themes/themes/`:
- `catppuccin_mocha.toml` (current - dark)
- `catppuccin_macchiato.toml` (dark)
- `catppuccin_frappe.toml` (dark)
- `catppuccin_latte.toml` (light)

To switch themes, change the import line in `alacritty.toml`:
```toml
import = [
  "~/.config/alacritty/themes/themes/catppuccin_macchiato.toml"
]
```

## Tips for Efficiency

1. **Use keyboard shortcuts** - Avoid mouse when possible
2. **Adjust font size** - Use Cmd+/- to find your perfect size
3. **Customize keybindings** - Add more in the `[keyboard]` section
4. **Combine with tmux** - For advanced window/pane management
5. **Use shell plugins** - Consider zsh-autosuggestions, zsh-syntax-highlighting

## Next Steps

Consider setting up:
- **Powerlevel10k** - Beautiful zsh prompt
- **zsh-autosuggestions** - Command auto-completion
- **zsh-syntax-highlighting** - Syntax highlighting
- **tmux** - Terminal multiplexer for better workflow

Enjoy your beautiful new terminal! 🚀

