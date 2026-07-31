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

  # Homebrew. /opt/homebrew on Apple Silicon, /usr/local on Intel — check both
  # so this file works on any Mac the dotfiles are cloned to.
  for __brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x "$__brew" ]] && eval "$("$__brew" shellenv)" && break
  done
  unset __brew

  # Claude Code long-lived OAuth token, read from the macOS Keychain so it is
  # never in this repo, which is public. Generated with `claude setup-token`.
  #
  # Why a token at all: Conductor runs many parallel Claude Code sessions, and
  # before CLI v2.1.211 concurrent sessions could refresh the shared OAuth
  # login simultaneously, revoking it and forcing every session to re-login
  # (401 "OAuth access token has been revoked"). A long-lived token never
  # refreshes, so the race cannot happen.
  #
  # USE ONE TOKEN ACROSS ALL MACHINES — do not mint one per machine. There is
  # no way to list or revoke an individual setup-token: no CLI subcommand, no
  # web UI, no device attribution (anthropics/claude-code#48373, #22995). The
  # only reason to hold per-device credentials is selective revocation, and
  # that does not exist here, so per-device buys nothing and leaves you with
  # several invisible year-long credentials. Whether minting a second token
  # invalidates the first is undocumented, which argues the same way.
  # If per-device isolation ever genuinely matters, the supported path is a
  # Console API key (sk-ant-...), which does have names and a revoke UI — but
  # it bills per token instead of against the subscription.
  #
  # PER-MACHINE SETUP: the login keychain does NOT sync over iCloud (only the
  # data protection keychain does, and the `security` CLI cannot write to it),
  # so cloning these dotfiles to a new Mac carries the lookup but not the
  # token. Copy the SAME token onto each machine with:
  #   security add-generic-password -U -a "$USER" -s claude-code-oauth-token -w
  # (-w with no value prompts, keeping it out of shell history.)
  # Until you do, the export below resolves to empty and Claude Code falls back
  # to normal OAuth login.
  #
  # EXPIRES AFTER ONE YEAR, and the failure is hard, not graceful: every
  # command starts returning "Login expired - Please run /login". Because the
  # value arrives from the Keychain, it will look like the Keychain broke.
  # It has not. Run `claude setup-token` again and re-store the new value.
  # Minted 2026-07-31 -> expires ~2027-07-31.
  #
  # Rate limits are shared per subscription, not per device: two Macs running
  # parallel sessions draw from the same pool.
  # Set here rather than in .zprofile so Conductor's non-login agent shells
  # inherit it too.
  if [[ -z "$CLAUDE_CODE_OAUTH_TOKEN" ]] && [[ -x /usr/bin/security ]]; then
    export CLAUDE_CODE_OAUTH_TOKEN="$(/usr/bin/security find-generic-password -a "$USER" -s claude-code-oauth-token -w 2>/dev/null)"
  fi
fi
