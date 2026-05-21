---
name: git-guardrails
description: Blocks destructive git commands (push --force, reset --hard, clean -f, branch -D, rebase) before they execute. Install as an Opencode plugin (.ts) or Hermes shell hook (.sh).
---

# Git Guardrails

Prevents destructive git operations from being executed accidentally by AI agents. Two implementations bundled — agent detects the platform and installs the correct one.

## What Gets Blocked

- `git push` — all variants including `--force`, `--force-with-lease`, `--delete`
- `git reset --hard`
- `git clean -f` / `git clean -fd` / `git clean -fdx`
- `git branch -D`
- `git checkout .` / `git restore .`
- `git rebase` — all variants (without explicit `--continue`/`--abort` confirmation)

## Process

### 1. Detect Platform

Check the current environment context:

| Signal | Platform |
|--------|----------|
| `AGENTS.md` exists, `CLAUDE.md` does NOT exist | **OpenCode** → install `.ts` plugin |
| `CLAUDE.md` exists (with or without AGENTS.md) | **Hermes** → install `.sh` hook |
| Neither file exists | Ask user which platform |

### 2. Install

#### OpenCode: Plugin Installation

Copy [opencode-block-dangerous-git.ts](./opencode-block-dangerous-git.ts) to the project's plugin directory:

```bash
cp opencode-block-dangerous-git.ts .opencode/plugins/git-guardrails.ts
```

Or for global installation:

```bash
cp opencode-block-dangerous-git.ts ~/.config/opencode/plugins/git-guardrails.ts
```

Ask the user which scope they prefer (project or global). Project scope is recommended — it travels with the repo and affects all contributors using OpenCode.

The plugin uses `tool.execute.before` to intercept bash commands. When a blocked pattern is detected, it throws an error which OpenCode surfaces to the agent.

#### Hermes: Shell Hook Installation

Copy [hermes-block-dangerous-git.sh](./hermes-block-dangerous-git.sh) and configure the hook:

```bash
# Make executable
chmod +x ~/.hermes/hooks/hermes-block-dangerous-git.sh

# Add to ~/.hermes/config.yaml
```

The `~/.hermes/config.yaml` hook block:

```yaml
hooks:
  pre_tool_exec:
    - name: git-guardrails
      command: ~/.hermes/hooks/hermes-block-dangerous-git.sh
      on: bash
```

The shell script reads the command, checks against blocked patterns, and exits non-zero if blocked. Hermes surfaces the block to the agent.

### 3. Verify

**OpenCode**: Run a command that should be blocked. The agent should see "BLOCKED" message instead of executing.

**Hermes**: Same — attempt a blocked command and verify it's rejected.

### 4. Fallback: Rule-Based (No Hook Support)

If neither hook mechanism is available, inject these rules into the project's agent configuration file (same file chosen by `setup-skills` — `AGENTS.md` or `CLAUDE.md`):

```markdown
## Git Safety Rules

Never execute these commands without explicit user confirmation:
- `git push` (any variant)
- `git reset --hard`
- `git clean -f` / `git clean -fd` / `git clean -fdx`
- `git branch -D`
- `git checkout .` / `git restore .`
- `git rebase`

If you need to run any of them, ask the user first: "I need to run `<command>`. Is that OK?"
```
