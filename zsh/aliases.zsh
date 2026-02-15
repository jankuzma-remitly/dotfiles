alias gc="git commit -m"
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias lg="lazygit"
alias gpl='git pull'
alias cd="z"
alias vim="nvim"
alias c="clear"
alias gs="git status"
alias gp="git push"
alias gch='git checkout'

_ai_prompt() {
  if command -v auggie &> /dev/null; then
    auggie -p -q "$1" 2>/dev/null
  else
    gemini -p "$1" 2>/dev/null
  fi
}

aicommit() {
  local diff=$(git diff --cached)
  local branch=$(git branch --show-current)
  local ticket=$(echo "$branch" | grep -oE 'GRO-[0-9]+' | head -1)

  if [ -z "$diff" ]; then
    echo "No staged changes. Stage your changes first with 'git add'"
    return 1
  fi

  echo "Generating commit messages..."

  local prompt="Generate exactly 5 concise git commit messages for this diff. Output ONLY the 5 messages, one per line, numbered 1-5. Conventional commits. If needed extract ticket number from branch $branch <type>(GRO-$ticket): <content> No other text:

$diff"

  local messages=$(_ai_prompt "$prompt")

  if [ -z "$messages" ]; then
    echo "Failed to generate messages"
    return 1
  fi

  if command -v fzf &> /dev/null; then
    local selected=$(echo "$messages" | fzf --height=10 --prompt="Select commit message: ")
    selected=$(echo "$selected" | sed 's/^[0-9][.):] *//')
  else
    echo "$messages"
    echo ""
    read "?Enter number (1-5): " choice
    selected=$(echo "$messages" | sed -n "${choice}p" | sed 's/^[0-9][.):] *//')
  fi

  if [ -n "$selected" ]; then
    git commit -m "$selected"
  else
    echo "No message selected, commit aborted."
  fi
}

aipr() {
  local branch=$(git branch --show-current)
  local ticket=$(echo "$branch" | grep -oE 'GRO-[0-9]+' | head -1)

  if [ -z "$ticket" ]; then
    read "?Enter ticket number (e.g., GRO-153): " ticket
  fi

  local base_branch="main"
  if ! git rev-parse --verify main &>/dev/null; then
    base_branch="master"
  fi

  local diff=$(git diff "$base_branch"...HEAD)

  if [ -z "$diff" ]; then
    echo "No changes compared to $base_branch"
    return 1
  fi

  echo "Generating PR titles..."

  local prompt="Generate exactly 5 concise PR titles for this diff. Format: [$ticket]: <title>
Output ONLY the 5 titles, one per line, numbered 1-5. No other text. Keep titles short and descriptive:

$diff"

  local messages=$(_ai_prompt "$prompt")

  if [ -z "$messages" ]; then
    echo "Failed to generate titles"
    return 1
  fi

  if command -v fzf &> /dev/null; then
    local selected=$(echo "$messages" | fzf --height=10 --prompt="Select PR title: ")
    selected=$(echo "$selected" | sed 's/^[0-9][.):] *//')
  else
    echo "$messages"
    echo ""
    read "?Enter number (1-5): " choice
    selected=$(echo "$messages" | sed -n "${choice}p" | sed 's/^[0-9][.):] *//')
  fi

  if [ -n "$selected" ]; then
    echo ""
    echo "Selected: $selected"
    echo "$selected" | pbcopy
    echo "(Copied to clipboard)"
  else
    echo "No title selected."
  fi
}

aipr-desc() {
  local pr_body=$(gh pr view --json body -q '.body')

  local base_branch="main"
  if ! git rev-parse --verify main &>/dev/null; then
    base_branch="master"
  fi
  local diff=$(git diff "$base_branch"...HEAD)

  echo "Generating updated PR description..."

  local prompt="Update this PR description. ONLY update the Summary and Testing steps taken sections. Keep EVERYTHING else exactly as-is including all HTML comments, checkboxes, and template structure.

DO NOT ADD ANY CHANGES THAT ARE NOT IN THE PR DIFF
DO NOT add any attribution, links to external sites, or mention any AI tools.

Current PR description:
$pr_body

Code diff:
$diff

Output ONLY the complete updated PR description, nothing else."

  local new_desc=$(_ai_prompt "$prompt")

  if [ -z "$new_desc" ]; then
    echo "Failed to generate description"
    return 1
  fi

  echo ""
  echo "$new_desc"
  echo ""

  read "?Update PR with this description? (y/n): " confirm

  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    gh pr edit --body "$new_desc"
    echo "PR description updated!"
  else
    echo "$new_desc" | pbcopy
    echo "Copied to clipboard instead."
  fi
}

ios2() {
  cd ~/projects/narwhal

  echo "Starting packager..."
  yarn native:packager &
  PACKAGER_PID=$!

  sleep 5

  echo "Starting iOS simulator 1 (iPhone 16e)..."
  DEFAULT_IOS_SIMULATOR="iPhone 16e" yarn ios:virtual &
  IOS1_PID=$!

  echo "Starting iOS simulator 2 (iPhone SE)..."
  DEFAULT_IOS_SIMULATOR="iPhone 17 Pro" yarn ios:virtual &
  IOS2_PID=$!

  echo 'Both iOS simulators started!'
  echo "Packager PID: $PACKAGER_PID"
  echo "iOS 1 PID: $IOS1_PID"
  echo "iOS 2 PID: $IOS2_PID"
}

zshr() {
  exec zsh -l
}
