# Dotfiles

Personal dotfiles for a minimal, reproducible macOS development environment.

> **New here?** Check out the **[Learning Guide](LEARNING_GUIDE.md)** — a walkthrough of every tool in this repo with the commands worth knowing, power combos, and a suggested learning order.

## Contents

- [Brewfile](Brewfile) — Homebrew package and cask list
- [LEARNING_GUIDE.md](LEARNING_GUIDE.md) — Tool-by-tool guide with commands, tips, and workflows
- [install.sh](install.sh) — Installer script that creates symlinks and provisions Homebrew
- [gitconfig](gitconfig) — Git config
- [zprofile](zprofile) — Login shell profile (Homebrew shellenv)
- [zshrc](zshrc) — Interactive shell config (fnm, rbenv, direnv, starship)
- [config/starship.toml](config/starship.toml) — Starship prompt configuration

## Overview

This repo provides a small set of dotfiles and an installer to:
- Symlink configuration files into your $HOME
- Install Homebrew (if missing)
- Run `brew bundle` using the provided [Brewfile](Brewfile)

## Installation

Run the installer from the repo root:

```sh
bash ./install.sh
```

The installer script [install.sh](install.sh) sets up a runtime variable [`DOTFILES_DIR`](install.sh) and uses the helper function [`link()`](install.sh) to create symlinks and back up existing files.

What gets linked by default:
- [zprofile](zprofile) -> ~/.zprofile
- [zshrc](zshrc) -> ~/.zshrc
- [gitconfig](gitconfig) -> ~/.gitconfig
- [config/starship.toml](config/starship.toml) -> ~/.config/starship.toml

The script will install Homebrew if it is not present, then run:

- `brew update`
- `brew bundle --file "$DOTFILES_DIR/Brewfile"` (uses [Brewfile](Brewfile))
- `brew upgrade --cask`
- `brew cleanup`

## Behavior & Safety

- Existing destination files are moved to a timestamped backup: `file -> file.bak.<epoch>`
- Symlinks are created with `ln -s` so the source repo remains authoritative.
- See the implementation of [`link()`](install.sh) for exact behavior.

## Customization

- Edit [config/starship.toml](config/starship.toml) to change prompt appearance.
- Modify [Brewfile](Brewfile) to change installed packages and casks.
- Update [gitconfig](gitconfig), [zprofile](zprofile), and [zshrc](zshrc) as desired.

## Revert / Uninstall

To revert changes made by the installer:
1. Remove the symlinks created in your home directory (e.g., `~/.zshrc`, `~/.gitconfig`, etc.).
2. Restore backups `*.bak.*` which the installer created.
3. Optionally uninstall Homebrew packages via `brew uninstall` / `brew bundle --file Brewfile --no-upgrade` as needed.

## Notes

- The prompt relies on [starship](Brewfile) and its config at [config/starship.toml](config/starship.toml).
- [zshrc](zshrc) initializes `rbenv`, `direnv`, and `starship`.

## Files & Symbols

- [Brewfile](Brewfile)  
- [install.sh](install.sh) — see [`DOTFILES_DIR`](install.sh), [`link()`](install.sh)  
- [gitconfig](gitconfig)  
- [zprofile](zprofile)  
- [zshrc](zshrc)  
- [config/starship.toml](config/starship.toml)

## License

[MIT](LICENSE)
