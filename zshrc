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
  git commit -m "$(codex exec 'Look at the staged git changes only and write a concise commit message in imperative mood. Return only the commit message.')"
}
