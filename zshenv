# Sourced by EVERY zsh: login, non-login, interactive, and scripts.
#
# This file exists because GUI-launched shells (Conductor, IDEs, LaunchAgents)
# are non-login and therefore never read .zprofile — not this repo's, and not
# macOS's own /etc/zprofile, which is where path_helper normally establishes
# /bin and /usr/bin. Without the block below such a shell cannot find `ls`.
#
# The guard keeps nested shells from prepending PATH repeatedly.

if [[ -z "$__DOTFILES_ENV_SET" ]]; then
  export __DOTFILES_ENV_SET=1

  # macOS base PATH (/bin, /usr/bin, /etc/paths.d) — normally login-only.
  [[ -x /usr/libexec/path_helper ]] && eval "$(/usr/libexec/path_helper -s)"

  # Homebrew.
  [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

  # Claude Code long-lived OAuth token. Lives in the macOS Keychain, never in
  # this repo, which is public. Store or rotate it with:
  #   security add-generic-password -U -a "$USER" -s claude-code-oauth-token -w
  # Set here rather than in .zprofile so Conductor's non-login agent shells
  # inherit it too.
  if [[ -z "$CLAUDE_CODE_OAUTH_TOKEN" ]] && [[ -x /usr/bin/security ]]; then
    export CLAUDE_CODE_OAUTH_TOKEN="$(/usr/bin/security find-generic-password -a "$USER" -s claude-code-oauth-token -w 2>/dev/null)"
  fi
fi
