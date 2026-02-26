# Brewfile Learning Guide
**Persona: PM who occasionally codes**

---

## 🔧 Core CLI Tools

### `git` — Version Control
The foundation of everything. Focus on these:
- `git status` — see what's changed
- `git add -p` — stage changes interactively (review before committing)
- `git commit -m "message"` — commit with a message
- `git log --oneline` — compact history
- `git diff` — see unstaged changes
- `git pull` / `git push` — sync with remote
- `git stash` / `git stash pop` — temporarily shelve changes
- `git checkout -b branch-name` — create and switch to a new branch

### `gh` — GitHub CLI
Lets you manage GitHub without leaving the terminal:
- `gh auth login` — authenticate once
- `gh pr create` — open a pull request from the terminal
- `gh pr list` — see open PRs
- `gh pr checkout 123` — check out a PR locally
- `gh issue list` — browse issues
- `gh repo clone owner/repo` — clone a repo

### `jq` — JSON Parser
Essential when working with APIs or data:
- `cat file.json | jq .` — pretty-print JSON
- `cat file.json | jq '.key'` — extract a field
- `curl api.example.com/data | jq '.results[]'` — pipe API output and extract arrays

### `ripgrep` (`rg`) — Fast Code Search
Way faster than `grep`:
- `rg "search term"` — search current directory recursively
- `rg "term" src/` — search a specific folder
- `rg -l "term"` — list only matching file names
- `rg -i "term"` — case-insensitive search

### `fd` — Better `find`
- `fd filename` — find a file by name
- `fd -e py` — find all Python files
- `fd -t d config` — find directories named "config"

### `fzf` — Fuzzy Finder
Most powerful when used with shell integrations:
- `Ctrl+R` — fuzzy search your command history (killer feature)
- `Ctrl+T` — fuzzy search files in your current directory
- `cd **<Tab>` — fuzzy navigate directories

### `bat` — Better `cat`
- `bat file.py` — view a file with syntax highlighting and line numbers
- `bat --plain file.txt` — plain output (no decorations)

---

## 🖥️ Shell & Environment

### `starship` — Shell Prompt
No commands to learn — it runs automatically. It shows git branch, language versions, and more in your prompt. Just install and configure via `~/.config/starship.toml` if you want to customize.

### `direnv` — Per-Project Env Variables
- Create a `.envrc` file in a project folder with `export VAR=value`
- Run `direnv allow` once to activate it
- Variables load automatically when you `cd` into that folder and unload when you leave

---

## 🐍 Language Runtimes

### `python@3.14`
- `python3 script.py` — run a script
- `python3 -m venv .venv && source .venv/bin/activate` — create and activate a virtual environment
- `pip install package-name` — install a library
- `python3 -c "print('hello')"` — quick one-liner

### `node` + `npm`
- `node script.js` — run a script
- `npm install` — install dependencies from `package.json`
- `npm run dev` — common command to start a dev server
- `npx tool-name` — run a package without installing it globally

### `rbenv` — Ruby Version Manager
- `rbenv install 3.3.0` — install a Ruby version
- `rbenv global 3.3.0` — set the default version
- `rbenv local 3.3.0` — set version for the current project
- `ruby -v` — verify the active version

---

## 🖱️ GUI Applications

### iTerm2 — Terminal Emulator
Key shortcuts to learn:
- `Cmd+D` — split pane vertically
- `Cmd+Shift+D` — split pane horizontally
- `Cmd+T` — new tab
- `Cmd+;` — autocomplete from history
- `Cmd+Shift+H` — paste history

### VS Code — Primary Editor
Must-know shortcuts:
- `Cmd+P` — open any file by name
- `Cmd+Shift+P` — command palette (run anything)
- `Cmd+` ` — open integrated terminal
- `Cmd+B` — toggle sidebar
- `Cmd+Shift+F` — global search
- `Option+click` — place multiple cursors
- `Cmd+D` — select next occurrence of word

### Raycast — Launcher & Productivity Hub
This replaces Spotlight and then some:
- `Option+Space` — open Raycast
- Type an app name to launch it
- `clip` — open clipboard history (huge time saver)
- `window` — manage window layouts
- `calc` — quick calculator
- Explore extensions in the Raycast Store (Jira, GitHub, Linear integrations are excellent for PMs)

### TablePlus — Database GUI
- Connect to Postgres, MySQL, SQLite, and more visually
- Learn basic SQL: `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`
- Use the filter bar to query without writing SQL manually
- `Cmd+K` — quick open a table

### Docker Desktop — Containers
PM-relevant basics:
- `docker ps` — see running containers
- `docker compose up` — start a multi-service app defined in `docker-compose.yml`
- `docker compose down` — stop everything
- `docker logs container-name` — see what an app is outputting
- The GUI dashboard is friendly — use it to start/stop containers without CLI

### Obsidian — Notes
- `Cmd+O` — open a note
- `Cmd+N` — new note
- `[[note name]]` — link to another note (core feature)
- `Cmd+Shift+F` — global search across all notes
- Learn the Graph View to visualize connections between ideas

### CleanShot — Screenshots & Recording
- `Ctrl+Shift+3` (configurable) — screenshot with annotation tools
- `Ctrl+Shift+5` — screen recording
- Scrolling capture for long pages is a standout feature

---

## 🤖 AI Dev Tools

### Claude Code
- Run `claude` in any project directory to start an agentic coding session
- Great for writing boilerplate, understanding unfamiliar codebases, writing tests
- `claude --help` — see all options

### Claude Desktop App
- Use for general reasoning, writing, and research
- Cowork mode (what you're using now) — delegate file and task automation

---

## 📚 Suggested Learning Order for a PM

1. **Raycast** — immediate daily productivity gain, zero learning curve
2. **git + gh** — critical for working with engineers; learn the 10 commands above cold
3. **fzf** — `Ctrl+R` alone will change how you use the terminal
4. **VS Code shortcuts** — `Cmd+P` and `Cmd+Shift+P` are transformative
5. **jq** — once you start working with APIs, this becomes indispensable
6. **Obsidian** — invest time linking your notes; the graph view pays off over months
7. **Docker basics** — enough to run local services without needing an engineer
8. **ripgrep + bat** — replace grep/cat for a noticeably nicer terminal experience
9. **direnv** — once you have multiple projects, this saves constant manual setup
10. **TablePlus + SQL basics** — being able to query your own data directly is a superpower
