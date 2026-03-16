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

If you want help writing commit messages for staged changes, your shell config includes `gcma`:

```sh
git add .
gcma                         # uses your saved default agent
gcma claude                  # override with Claude Code
gcma codex                   # override with Codex
gcma --set-default claude    # change the saved default
```

On first run, `gcma` prompts you to pick an agent (claude or codex) and remembers your choice in `~/.config/gcma/default_agent`. It reads staged changes and asks the selected CLI to return a concise commit message.

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

For Python projects, `direnv` pairs nicely with `venv`:

```sh
python3 -m venv .venv
echo 'source .venv/bin/activate' > .envrc
direnv allow
```

That gives you automatic virtual environment activation when you enter the project directory.

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

`venv` is included with Python, so you do not need a separate Homebrew package for it.

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

Common Node/npm/pnpm commands:

```sh
node script.js                 # run a script
npm install                    # install dependencies from package.json
npm run dev                    # common command to start a dev server
npx tool-name                  # run a package without installing globally
pnpm install                   # faster, disk-efficient alternative to npm install
pnpm add package-name          # add a dependency
pnpm dlx tool-name             # pnpm equivalent of npx
```

### `rbenv` + `ruby-build` — Ruby Version Manager

Already configured in [zshrc](zshrc). `ruby-build` is installed alongside `rbenv` so `rbenv install` works out of the box:

```sh
rbenv install 3.3.0            # install a Ruby version (via ruby-build)
rbenv global 3.3.0             # set the default version
rbenv local 3.3.0              # set version for the current project
ruby -v                        # verify the active version
```

---

## Cloud & Infrastructure

### `awscli` — AWS Command Line Interface

Interact with AWS services directly from the terminal. Set up once, use everywhere:

```sh
aws configure                  # set your access key, secret, region (do this first)
aws configure list             # verify current credentials
aws sts get-caller-identity    # confirm who you're authenticated as
```

**S3 — File Storage**

```sh
aws s3 ls                      # list all your S3 buckets
aws s3 ls s3://bucket-name/    # list files in a bucket
aws s3 cp file.txt s3://bucket-name/path/  # upload a file
aws s3 cp s3://bucket-name/path/file.txt . # download a file
aws s3 sync ./local-dir s3://bucket-name/  # sync a folder to S3
```

**Useful for PMs**

```sh
# See recent activity in a bucket (useful for checking if uploads are landing)
aws s3 ls s3://bucket-name/ --recursive --human-readable | sort | tail -20

# Check what environment variables are set for a Lambda function
aws lambda get-function-configuration --function-name my-function | jq '.Environment'

# List all EC2 instances and their states
aws ec2 describe-instances | jq '.Reservations[].Instances[] | {id: .InstanceId, state: .State.Name}'
```

**PM tip**: Credentials live in `~/.aws/credentials`. Use `direnv` with per-project `.envrc` files to switch between AWS accounts/roles without overwriting your global config.

### `supabase` — Supabase CLI

Manage Supabase projects (Postgres, Auth, Edge Functions) from the terminal:

```sh
supabase init                  # initialize a new Supabase project locally
supabase start                 # start local Supabase stack (Postgres, Auth, etc.)
supabase stop                  # stop local stack
supabase db reset              # reset local database to migrations
supabase migration new name    # create a new migration
supabase status                # check local service status
supabase link --project-ref x  # link to a remote Supabase project
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

### Cursor — AI-Native Editor

A VS Code fork with built-in AI features. Same shortcuts and extensions as VS Code, plus:

- `Cmd+K` — inline AI edit
- `Cmd+L` — open AI chat panel
- Tab completion with AI suggestions

If you already know VS Code, Cursor feels immediately familiar.

### Zed — GPU-Accelerated Editor

A fast, minimal editor built in Rust. Worth trying if VS Code feels sluggish:

```sh
zed file.txt                   # open a file
zed .                          # open current directory
```

Key shortcuts mirror VS Code (`Cmd+P`, `Cmd+Shift+P`). Built-in AI assistant and collaboration features.

### Raycast — Launcher (Nice-to-Have)

A Spotlight replacement with extras. Not essential to get started, but convenient once you're settled in:

- **`Option+Space`** — open Raycast
- Type an app name to launch it
- `clip` — clipboard history
- `window` — manage window layouts

The Raycast Store has extensions for Jira, GitHub, Linear, etc. Worth exploring later.

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

### GitHub Desktop — Git GUI

Visual interface for Git — useful when diffs or merge conflicts are easier to handle visually:

- Stage/unstage changes with checkboxes
- View diffs side-by-side
- Create branches and PRs without the CLI

**PM tip**: If the `git` CLI feels intimidating, GitHub Desktop is a gentler way to start.

### Postman — API Testing

Visual tool for building and testing API requests:

- Create and save HTTP requests (GET, POST, PUT, DELETE)
- Organize requests into collections
- Inspect response bodies, headers, and status codes
- Share collections with your team

**PM tip**: Ask an engineer to share their Postman collection — it's the fastest way to understand your team's API surface.

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

### Fonts

The Brewfile installs two fonts:

- **Hack Nerd Font** — monospace font with icon glyphs required by Starship and other terminal tools. Set this as your font in iTerm2/VS Code/Cursor for proper prompt rendering.
- **Lato** — clean sans-serif for presentations and documents.

---

## AI Dev Tools

### Codex

An agentic coding CLI from OpenAI that runs in your terminal:

```sh
codex                         # start an interactive session
codex "explain this codebase" # start with a prompt
codex exec "summarize the staged diff"
codex --help
```

Useful for: repo-aware code changes, explanations, reviews, and terminal-native workflows like AI-generated commit messages.

### Claude Code

An agentic coding tool that runs in your terminal:

```sh
claude                         # start a session in current directory
claude "explain this codebase" # start with a prompt
claude --help                  # see all options
```

Useful for: writing boilerplate, understanding unfamiliar codebases, writing tests, refactoring, and automating tedious tasks.

### ChatGPT Desktop App

General-purpose desktop AI app from OpenAI. Good for writing, planning, brainstorming, research, and quick Q&A outside a repo-focused terminal workflow.

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

If the installer leaves backup files behind while relinking dotfiles, you can remove current-directory backups with:

```sh
find . -maxdepth 1 \( -type f -o -type l \) -name '*.bak.*' -delete
```

---

## Suggested Learning Order

Start with the tools that give you the biggest daily productivity gains:

| Priority | Tool | Why |
|----------|------|-----|
| 1 | **git + gh** | Critical for working with engineers — learn the commands above cold |
| 2 | **fzf** | `Ctrl+R` alone will change how you use the terminal |
| 3 | **VS Code shortcuts** | `Cmd+P` and `Cmd+Shift+P` are transformative |
| 4 | **jq** | Once you start working with APIs, this is indispensable |
| 5 | **Claude Code** | Accelerates everything else on this list |
| 6 | **Obsidian** | Invest time linking notes — the graph view pays off over months |
| 7 | **Docker basics** | Enough to run local services without needing an engineer |
| 8 | **ripgrep + bat + fd** | Replace grep/cat/find for a noticeably better terminal experience |
| 9 | **direnv** | Once you have multiple projects, saves constant manual setup |
| 10 | **TablePlus + SQL** | Pull your own data directly — a PM superpower |
| 11 | **awscli** | Query S3, Lambda, and EC2 without bothering an engineer |
| 12 | **fnm / rbenv** | Only relevant when working on Node or Ruby projects |
| 13 | **Raycast** | Nice-to-have Spotlight replacement — explore once you're comfortable |
