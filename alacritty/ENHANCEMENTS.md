# Optional Enhancements for Alacritty

Here are some popular enhancements you can add to make your terminal even more efficient:

## 1. Powerlevel10k (Beautiful Prompt)

```bash
brew install powerlevel10k
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
source ~/.zshrc
p10k configure
```

## 2. zsh-autosuggestions (Command Auto-completion)

```bash
brew install zsh-autosuggestions
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
source ~/.zshrc
```

## 3. zsh-syntax-highlighting (Syntax Highlighting)

```bash
brew install zsh-syntax-highlighting
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
source ~/.zshrc
```

## 4. eza (Better ls)

```bash
brew install eza
# Add to ~/.zshrc:
alias ls="eza --icons=always"
```

## 5. zoxide (Smarter cd)

```bash
brew install zoxide
# Add to ~/.zshrc:
eval "$(zoxide init zsh)"
```

## 6. tmux (Terminal Multiplexer)

```bash
brew install tmux
# Create ~/.tmux.conf with your preferences
```

## 7. fzf (Fuzzy Finder)

```bash
brew install fzf
$(brew --prefix)/opt/fzf/install
```

## 8. bat (Better cat)

```bash
brew install bat
alias cat="bat"
```

## 9. ripgrep (Better grep)

```bash
brew install ripgrep
```

## 10. fd (Better find)

```bash
brew install fd
```

## Recommended Setup Order

1. Start with Powerlevel10k for a beautiful prompt
2. Add zsh-autosuggestions for faster typing
3. Add zsh-syntax-highlighting for visual feedback
4. Add eza and zoxide for better navigation
5. Add tmux for advanced window management

## Popular Dotfiles to Reference

- **Josean Martinez**: https://github.com/josean-dev/dev-environment-files
- **ThePrimeagen**: https://github.com/ThePrimeagen/dotfiles
- **Kickstart.nvim**: https://github.com/nvim-lua/kickstart.nvim

These are great starting points for building your complete development environment!

