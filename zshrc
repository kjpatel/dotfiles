# fnm (Node version manager)
 eval "$(fnm env --use-on-cd)"

# rbenv (set Ruby shims early)
eval "$(rbenv init - zsh)"

# direnv (project env vars)
eval "$(direnv hook zsh)"

# Prompt (render last)
eval "$(starship init zsh)"

# Quality of life
export EDITOR="code"
export CLICOLOR=1              # always colorize ls output (macOS)

alias ll='ls -lhaG'            # long listing, human sizes, hidden files, color
alias la='ls -aG'              # hidden files, compact
alias l='ls -G'                # quick color listing

# AI agent shared config
_ai_config_file="$HOME/.config/gcma/default_agent"

_ai_resolve_agent() {
  # Resolve which AI agent to use: explicit arg > saved default > prompt user
  local ai_tool="$1"
  if [[ -n "$ai_tool" ]]; then
    echo "$ai_tool"
    return
  fi
  if [[ -f "$_ai_config_file" ]]; then
    cat "$_ai_config_file"
    return
  fi
  echo "No default AI agent set. Choose one (claude/codex) [claude]:" >&2
  read -r choice
  ai_tool="${choice:-claude}"
  mkdir -p "$(dirname "$_ai_config_file")"
  echo "$ai_tool" > "$_ai_config_file"
  echo "Saved '$ai_tool' as default. Change anytime with: gcma --set-default <agent>" >&2
  echo "$ai_tool"
}

_ai_run() {
  # Run a prompt through the resolved AI agent, printing the result to stdout
  local ai_tool="$1"
  local prompt="$2"
  local input="$3"

  case "$ai_tool" in
    codex)
      if [[ -n "$input" ]]; then
        echo "$input" | codex exec "$prompt"
      else
        codex exec "$prompt"
      fi
      ;;
    claude|claude-code)
      if [[ -n "$input" ]]; then
        echo "$input" | claude -p "$prompt"
      else
        claude -p "$prompt"
      fi
      ;;
    *)
      echo "Unknown agent '$ai_tool'. Use codex or claude." >&2
      return 1
      ;;
  esac
}

# Git helpers
gcma() {
  # Allow changing the default
  if [[ "$1" == "--set-default" ]]; then
    local new_default="${2:?Usage: gcma --set-default <codex|claude>}"
    mkdir -p "$(dirname "$_ai_config_file")"
    echo "$new_default" > "$_ai_config_file"
    echo "Default agent set to '$new_default'."
    return 0
  fi

  local ai_tool
  ai_tool="$(_ai_resolve_agent "$1")" || return 1

  local prompt="Look at the staged git changes only and write a concise commit message in imperative mood. Return only the commit message."
  local message
  message="$(_ai_run "$ai_tool" "$prompt")" || return 1

  git commit -m "$message"
}

gpr() {
  local base="${1:-main}"
  local commits
  commits="$(git log "$base"..HEAD --oneline 2>/dev/null)"

  if [[ -z "$commits" ]]; then
    echo "No commits ahead of $base." >&2
    return 1
  fi

  local ai_tool
  ai_tool="$(_ai_resolve_agent)" || return 1

  local prompt="You are looking at git commits for a pull request. Write a JSON object with two keys: \"title\" (concise, under 70 chars, imperative mood) and \"body\" (a markdown summary with a ## Summary section containing 1-3 bullet points). Return only valid JSON, no code fences."
  local diff_summary
  diff_summary="$(git log "$base"..HEAD --pretty=format:'%s' | head -20)"

  local result
  result="$(_ai_run "$ai_tool" "$prompt" "$diff_summary")" || return 1

  local title body
  title="$(echo "$result" | jq -r '.title // empty')"
  body="$(echo "$result" | jq -r '.body // empty')"

  if [[ -z "$title" ]]; then
    echo "Failed to generate PR metadata. Creating PR interactively." >&2
    gh pr create --base "$base"
    return
  fi

  gh pr create --base "$base" --title "$title" --body "$body"
}

proj() {
  # Fuzzy-find and cd into a project directory
  local search_root="${1:-$HOME}"
  local dir
  dir="$(fd -t d --max-depth 3 --hidden --exclude .git . "$search_root" | fzf --preview 'ls -1 {}')"
  if [[ -n "$dir" ]]; then
    cd "$dir" || return 1
  fi
}

port() {
  # Show what's running on a given port
  if [[ -z "$1" ]]; then
    echo "Usage: port <number>" >&2
    return 1
  fi
  lsof -i :"$1"
}

cleanup-bak() {
  # Remove backup files created by install.sh
  for f in ~/.zprofile ~/.zshrc ~/.gitconfig ~/.config/starship.toml; do
    find "$(dirname "$f")" -maxdepth 1 -name "$(basename "$f").bak.*" -print -delete
  done
}

swlogs() {
  # Tail parallel sweep worker logs (Granite Harbor backtest sweeps).
  # Finds the most recent sweep_logs_* dir, or accepts an explicit path.
  local dir="${1:-$(ls -td ${TMPDIR:-/tmp}/sweep_logs_* 2>/dev/null | head -1)}"
  if [[ -z "$dir" || ! -d "$dir" ]]; then
    echo "No sweep logs found. Pass a directory or run a parallel sweep first." >&2
    return 1
  fi
  local count=$(ls "$dir"/worker_*.log 2>/dev/null | wc -l | tr -d ' ')
  echo "Tailing $count worker logs in $dir"
  tail -f "$dir"/worker_*.log
}

dotup() {
  # Pull latest dotfiles, run brew bundle, and re-source zshrc
  local dotdir="${DOTFILES_DIR:-$HOME/.dotfiles}"
  echo "Pulling latest dotfiles..."
  git -C "$dotdir" pull || { echo "git pull failed" >&2; return 1; }
  echo "Running brew bundle..."
  brew bundle --file "$dotdir/Brewfile"
  echo "Re-sourcing zshrc..."
  source "$HOME/.zshrc"
  echo "Done."
}

. "$HOME/.local/bin/env"
