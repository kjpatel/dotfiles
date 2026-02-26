# rbenv (set Ruby shims early)
eval "$(rbenv init - zsh)"

# direnv (project env vars)
eval "$(direnv hook zsh)"

# Prompt (render last)
eval "$(starship init zsh)"

# Quality of life
export EDITOR="code"