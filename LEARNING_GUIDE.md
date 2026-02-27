# Learning Guide

**Audience**: PM who occasionally codes — enough to be dangerous, not enough to be an engineer.

This guide covers every tool in the [Brewfile](Brewfile) and shows how they work together. It's organized by category, with a suggested learning order at the end.

---

## First 30 Minutes

After running `install.sh`, try these immediately to verify everything works:

```sh
# Your prompt should already look different (starship is active)
# Try fuzzy history search
# Press Ctrl+R, type a few letters of a past command

# Search this repo
rg "brew" Brewfile

# View a file with syntax highlighting
bat zshrc

# Find files by name
fd starship

# Pretty-print some JSON
echo '{"name":"Kushan","role":"PM"}' | jq .

# Check GitHub auth
gh auth status
```

If all of those work, your environment is ready.

---

## Core CLI Tools

### `git` — Version Control

The foundation of working with code. These 10 commands cover 95% of daily use:

```sh
git status                     # see what's changed
git add -p                     # stage changes interactively (review before committing)
git commit -m "message"        # commit with a message
git log --oneline              # compact history
git diff                       # see unstaged changes
git pull / git push            # sync with remote
git stash / git stash pop      # temporarily shelve changes
git checkout -b branch-name    # create and switch to a new branch
git branch -d branch-name      # delete a merged branch
git log --oneline --graph      # visualize branch history
```

**PM tip**: `git log --oneline --since="1 week ago"` is great for checking what shipped recently.

### `gh` — GitHub CLI

Manage GitHub without leaving the terminal:

```sh
gh auth login                  # authenticate once
gh pr create                   # open a pull request from the terminal
gh pr list                     # see open PRs
gh pr checkout 123             # check out a PR locally
gh pr view 123 --web           # open PR in browser
gh issue list                  # browse issues
gh issue create                # file an issue from the terminal
gh repo clone owner/repo       # clone a repo
gh repo view --web             # open current repo in browser
```

**PM tip**: `gh pr list --search "is:open review-requested:@me"` shows PRs waiting for your review.

### `jq` — JSON Parser

Essential when working with APIs or data:

```sh
cat file.json | jq .                      # pretty-print JSON
cat file.json | jq '.key'                 # extract a field
cat file.json | jq '.users[] | .name'     # extract names from an array
curl -s api.example.com/data | jq '.results[]'  # pipe API output
echo '{"a":1}' | jq '. + {"b":2}'        # merge objects
```

**PM tip**: Pair with `curl` to explore any REST API your team builds. `curl -s your-api/endpoint | jq .` is the fastest way to understand a response shape.

### `ripgrep` (`rg`) — Fast Code Search

Replaces `grep`. Searches recursively by default, respects `.gitignore`:

```sh
rg "search term"               # search current directory recursively
rg "term" src/                 # search a specific folder
rg -l "term"                   # list only matching file names
rg -i "term"                   # case-insensitive search
rg -c "TODO"                   # count matches per file
rg "term" -g "*.py"            # only search Python files
```

### `fd` — Better `find`

Simple, fast file search:

```sh
fd filename                    # find a file by name
fd -e py                       # find all Python files
fd -e md                       # find all markdown files
fd -t d config                 # find directories named "config"
fd -H .env                     # include hidden files in search
```

### `fzf` — Fuzzy Finder

The single most impactful terminal productivity tool. Your shell is already configured with these keybindings:

- **`Ctrl+R`** — fuzzy search your command history (learn this first)
- **`Ctrl+T`** — fuzzy search files in your current directory
- **`cd **<Tab>`** — fuzzy navigate directories
- **`kill <Tab>`** — fuzzy search processes to kill

### `bat` — Better `cat`

Drop-in replacement for `cat` with syntax highlighting and line numbers:

```sh
bat file.py                    # view with syntax highlighting
bat --plain file.txt           # plain output (no decorations)
bat -l json file.txt           # force a specific language
bat --diff file.py             # show git diff for a file
```

---

## Shell & Environment

### `starship` — Shell Prompt

Already active in your shell (configured in [zshrc](zshrc)). Shows git branch, language versions, command duration, and more — no commands to learn.

Customize the look by editing [config/starship.toml](config/starship.toml). The current config uses a two-line "hacker flair" layout with a right-side status HUD.

### `direnv` — Per-Project Env Variables

Automatically loads/unloads environment variables when you enter/leave a directory:

```sh
# In a project folder:
echo 'export API_KEY=abc123' > .envrc
direnv allow                   # activate (one-time per .envrc change)
# Variables are now set when you cd in, cleared when you cd out
```

Already hooked into your shell via [zshrc](zshrc). Add `.envrc` to your global gitignore so secrets don't leak.

---

## Language Runtimes

### `python@3.14`

```sh
python3 script.py              # run a script
python3 -m venv .venv          # create a virtual environment
source .venv/bin/activate      # activate it
pip install package-name       # install a library
pip freeze > requirements.txt  # snapshot dependencies
deactivate                     # leave the virtual environment
```

**PM tip**: Always use a venv for each project. It prevents package conflicts and makes projects reproducible.

### `fnm` — Node Version Manager

Manages multiple Node.js versions. Already configured in [zshrc](zshrc) with `--use-on-cd`, which auto-switches Node versions when a project has a `.node-version` or `.nvmrc` file.

```sh
fnm list-remote                # see available Node versions
fnm install 22                 # install Node 22.x (latest LTS)
fnm use 22                     # switch to Node 22
fnm default 22                 # set as default
node -v                        # verify active version
```

Common Node/npm commands:

```sh
node script.js                 # run a script
npm install                    # install dependencies from package.json
npm run dev                    # common command to start a dev server
npx tool-name                  # run a package without installing globally
```

### `rbenv` — Ruby Version Manager

Already configured in [zshrc](zshrc):

```sh
rbenv install 3.3.0            # install a Ruby version
rbenv global 3.3.0             # set the default version
rbenv local 3.3.0              # set version for the current project
ruby -v                        # verify the active version
```

---

## GUI Applications

### iTerm2 — Terminal Emulator

Key shortcuts:

| Shortcut | Action |
|----------|--------|
| `Cmd+D` | Split pane vertically |
| `Cmd+Shift+D` | Split pane horizontally |
| `Cmd+T` | New tab |
| `Cmd+;` | Autocomplete from history |
| `Cmd+Shift+H` | Paste history |
| `Cmd+Option+Arrow` | Switch between panes |

### VS Code — Primary Editor

Must-know shortcuts:

| Shortcut | Action |
|----------|--------|
| `Cmd+P` | Open any file by name |
| `Cmd+Shift+P` | Command palette (run anything) |
| `` Cmd+` `` | Open integrated terminal |
| `Cmd+B` | Toggle sidebar |
| `Cmd+Shift+F` | Global search |
| `Option+Click` | Place multiple cursors |
| `Cmd+D` | Select next occurrence of word |
| `Cmd+Shift+L` | Select all occurrences of word |
| `Option+Up/Down` | Move line up/down |

**PM tip**: Install the GitLens extension to see who last changed any line and why — great for understanding code history.

### Sublime Text — Lightweight Editor

Fast alternative for quick edits when VS Code feels heavy:

```sh
subl file.txt                  # open a file
subl .                         # open current directory as project
```

Same essential shortcuts as VS Code (`Cmd+P`, `Cmd+Shift+P`).

### Raycast — Launcher & Productivity Hub

Replaces Spotlight:

- **`Option+Space`** — open Raycast
- Type an app name to launch it
- `clip` — clipboard history (huge time saver)
- `window` — manage window layouts
- `calc` — quick calculator

Explore the Raycast Store for extensions. Jira, GitHub, Linear, and Notion integrations are particularly useful for PMs.

### TablePlus — Database GUI

Visual interface for Postgres, MySQL, SQLite, and more:

```sql
-- Basic queries to know:
SELECT * FROM users LIMIT 10;
SELECT * FROM users WHERE email LIKE '%@company.com';
SELECT status, COUNT(*) FROM orders GROUP BY status;
```

- `Cmd+K` — quick open a table
- Use the filter bar to query without writing SQL

**PM tip**: Being able to pull your own data without asking an engineer is a superpower. Start with simple `SELECT` queries.

### Docker Desktop — Containers

Enough to run services locally:

```sh
docker ps                      # see running containers
docker compose up              # start a multi-service app
docker compose up -d           # start in background (detached)
docker compose down            # stop everything
docker logs container-name     # see output
docker compose logs -f         # follow all logs live
```

The GUI dashboard is friendly — use it to start/stop containers without the CLI.

### Obsidian — Notes

```
Cmd+O          — open a note
Cmd+N          — new note
Cmd+Shift+F    — global search
[[note name]]  — link to another note (core feature)
```

Invest time in linking notes. The graph view becomes valuable once you have 50+ connected notes.

### CleanShot — Screenshots & Recording

- `Ctrl+Shift+3` (configurable) — screenshot with annotation tools
- `Ctrl+Shift+5` — screen recording
- Scrolling capture for long pages is a standout feature

---

## AI Dev Tools

### Claude Code

An agentic coding tool that runs in your terminal:

```sh
claude                         # start a session in current directory
claude "explain this codebase" # start with a prompt
claude --help                  # see all options
```

Useful for: writing boilerplate, understanding unfamiliar codebases, writing tests, refactoring, and automating tedious tasks.

### Claude Desktop App

General-purpose AI assistant for reasoning, writing, research, and analysis. Use Computer Use / MCP integrations to delegate tasks across your desktop apps.

---

## Power Combos

These tools become more powerful when chained together:

```sh
# Find a file, then view it with syntax highlighting
fd config.py | head -1 | xargs bat

# Search for a term, pick a match interactively, open in VS Code
rg -l "TODO" | fzf | xargs code

# Find all Python files modified in the last 7 days
fd -e py --changed-within 7d

# Pretty-print a curl response and extract specific fields
curl -s https://api.example.com/users | jq '.[0] | {name, email}'

# Search command history for docker commands
history | rg docker | fzf

# View git log with fuzzy search
git log --oneline | fzf --preview 'git show {1}'

# Find large files in a repo
fd -t f -x stat -f '%z %N' {} | sort -rn | head -20
```

---

## Understanding Your Shell Config

This dotfiles repo configures your shell in two stages:

**[zprofile](zprofile)** runs once at login:
- Sets up Homebrew's shell environment (`brew shellenv`)

**[zshrc](zshrc)** runs for every new terminal:
- `fnm` — Node version manager with auto-switching
- `rbenv` — Ruby version manager
- `direnv` — per-project env vars
- `starship` — prompt (rendered last so it can detect everything above)
- Sets VS Code as default `$EDITOR`

**[config/starship.toml](config/starship.toml)** controls your prompt:
- Left side: directory, git branch, git status, command duration
- Right side: Python/Ruby/Node versions, Docker context, clock
- Two-line layout with `┌/└` brackets

To customize, edit these files and open a new terminal to see changes.

---

## Suggested Learning Order

Start with the tools that give you the biggest daily productivity gains:

| Priority | Tool | Why |
|----------|------|-----|
| 1 | **Raycast** | Immediate daily productivity gain, zero learning curve |
| 2 | **git + gh** | Critical for working with engineers — learn the commands above cold |
| 3 | **fzf** | `Ctrl+R` alone will change how you use the terminal |
| 4 | **VS Code shortcuts** | `Cmd+P` and `Cmd+Shift+P` are transformative |
| 5 | **jq** | Once you start working with APIs, this is indispensable |
| 6 | **Claude Code** | Accelerates everything else on this list |
| 7 | **Obsidian** | Invest time linking notes — the graph view pays off over months |
| 8 | **Docker basics** | Enough to run local services without needing an engineer |
| 9 | **ripgrep + bat + fd** | Replace grep/cat/find for a noticeably better terminal experience |
| 10 | **direnv** | Once you have multiple projects, saves constant manual setup |
| 11 | **TablePlus + SQL** | Pull your own data directly — a PM superpower |
| 12 | **fnm / rbenv** | Only relevant when working on Node or Ruby projects |
