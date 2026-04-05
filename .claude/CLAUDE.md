# Global Instructions

## Background jobs

- Use the Bash tool's `run_in_background: true` parameter, not `&` inside the command string. Python buffers stdout when not a TTY — output is lost or incomplete with `&`.
- Always add `PYTHONUNBUFFERED=1` to background Python commands.
- Background tasks don't inherit `direnv` or shell profile PATH. Always prepend `PATH="/opt/homebrew/bin:$PATH"` to background commands so tools like `uv`, `node`, etc. are found.
- Pipe through `tee` when the user needs a persistent log: `command 2>&1 | tee /tmp/output.log`

## Long-running tasks

- Never go silent for more than 5 minutes. Report progress for any task that takes longer.
- Always attach `caffeinate -i -w <PID>` on macOS to prevent sleep. Find the PID with `pgrep -f <script_name>`, then run `caffeinate -i -w <PID> &`.
- Set up periodic monitoring (e.g., cron check every 2 minutes) for background jobs. If output hasn't changed since last check, the process is likely stalled — investigate.
