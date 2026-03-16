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

# Git helpers
gcma() {
  local config_file="$HOME/.config/gcma/default_agent"
  local ai_tool="$1"

  # Allow changing the default
  if [[ "$ai_tool" == "--set-default" ]]; then
    local new_default="${2:?Usage: gcma --set-default <codex|claude>}"
    mkdir -p "$(dirname "$config_file")"
    echo "$new_default" > "$config_file"
    echo "Default agent set to '$new_default'."
    return 0
  fi

  # If no argument, read saved default or prompt on first run
  if [[ -z "$ai_tool" ]]; then
    if [[ -f "$config_file" ]]; then
      ai_tool="$(cat "$config_file")"
    else
      echo "No default AI agent set. Choose one (claude/codex) [claude]:"
      read -r choice
      ai_tool="${choice:-claude}"
      mkdir -p "$(dirname "$config_file")"
      echo "$ai_tool" > "$config_file"
      echo "Saved '$ai_tool' as default. Change anytime with: gcma --set-default <agent>"
    fi
  fi

  local prompt="Look at the staged git changes only and write a concise commit message in imperative mood. Return only the commit message."
  local message

  case "$ai_tool" in
    codex)
      message="$(codex exec "$prompt")"
      ;;
    claude|claude-code)
      message="$(claude -p "$prompt")"
      ;;
    *)
      echo "Usage: gcma [codex|claude]" >&2
      return 1
      ;;
  esac

  git commit -m "$message"
}
