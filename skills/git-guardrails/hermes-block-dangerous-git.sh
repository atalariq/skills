#!/usr/bin/env bash
# Hermes shell hook — blocks destructive git commands before execution
#
# Install:
#   1. chmod +x ~/.hermes/hooks/hermes-block-dangerous-git.sh
#   2. Add to ~/.hermes/config.yaml:
#      hooks:
#        pre_tool_exec:
#          - name: git-guardrails
#            command: ~/.hermes/hooks/hermes-block-dangerous-git.sh
#            on: bash
#
# Exit codes: 0 = allow, 1 = block

set -euo pipefail

# Read input (Hermes passes tool call data via stdin or args)
input="${1:-}"
if [ -z "$input" ] && [ ! -t 0 ]; then
  input=$(cat)
fi

# Try to extract command from JSON input, fall back to raw text
command=""
if command -v jq &>/dev/null && echo "$input" | jq -e '.command' &>/dev/null; then
  command=$(echo "$input" | jq -r '.command')
else
  command="$input"
fi

# Blocked patterns — regex
BLOCKED=(
  'git push'
  'git reset --hard'
  'git clean -f'
  'git branch -D'
  'git checkout \.'
  'git restore \.'
  'git rebase'
)

for pattern in "${BLOCKED[@]}"; do
  if echo "$command" | grep -qE "$pattern"; then
    cat >&2 <<EOF
BLOCKED: Destructive git command detected.

  Command: $command

This command can cause irreversible data loss. If you genuinely need to
run it, ask the user for explicit confirmation first. They can run it
directly in their terminal.
EOF
    exit 1
  fi
done

exit 0
