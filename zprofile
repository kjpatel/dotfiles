# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Claude Code — long-lived OAuth token for parallel sessions (Conductor).
# The token itself lives in the macOS Keychain, never in this repo, which is
# public. Store or rotate it with:
#   security add-generic-password -U -a "$USER" -s claude-code-oauth-token -w
# (-w with no value prompts, so it stays out of shell history.)
export CLAUDE_CODE_OAUTH_TOKEN=$(security find-generic-password -a "$USER" -s claude-code-oauth-token -w 2>/dev/null)
