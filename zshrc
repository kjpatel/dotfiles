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
  local ai_tool="${1:-codex}"
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
