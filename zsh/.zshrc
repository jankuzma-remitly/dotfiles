# ============================================================================
# SHELL STARTUP TRACKING
# ============================================================================
ZSH_START_TIME=${ZSH_START_TIME:-$(date +%s%N)}

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="af-magic"
export LANG=en_US.UTF-8
export EDITOR='nvim'
export TERM_PROGRAM=Alacritty
export TERM=alacritty
export NVM_DIR="$HOME/.nvm"
command -v go &>/dev/null && export PATH="$(go env GOPATH)/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"

# Machine-specific secrets (API keys, tokens, work aliases)
source ~/.secrets 2>/dev/null

# ============================================================================
# OH MY ZSH
# ============================================================================

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13
ENABLE_CORRECTION="true"

plugins=(
git
docker
docker-compose
fzf
)

[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# ============================================================================
# LAZY LOADERS
# ============================================================================

if [[ -o interactive ]]; then
  nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
  }

  node() {
    unset -f node
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    node "$@"
  }

  npm() {
    unset -f npm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npm "$@"
  }

  yarn() {
    unset -f yarn
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    yarn "$@"
  }
fi

command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

rbenv() {
  unset -f rbenv
  eval "$(command rbenv init -)"
  rbenv "$@"
}

# ============================================================================
# STARTUP TIME
# ============================================================================

if [[ -n "$ZSH_START_TIME" ]]; then
  ZSH_END_TIME=$(date +%s%N)
  ZSH_ELAPSED=$(( (ZSH_END_TIME - ZSH_START_TIME) / 1000000 ))
  if [[ $ZSH_ELAPSED -lt 1000 ]]; then
    echo "Shell startup: ${ZSH_ELAPSED}ms"
  else
    ZSH_ELAPSED_SEC=$(( ZSH_ELAPSED / 1000 ))
    echo "Shell startup: ${ZSH_ELAPSED_SEC}s"
  fi
  unset ZSH_START_TIME ZSH_END_TIME ZSH_ELAPSED
fi

# Portable aliases and functions
source "$HOME/dotfiles/zsh/aliases.zsh"
