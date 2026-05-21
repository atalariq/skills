import type { Plugin } from "@opencode-ai/plugin"

const BLOCKED_PATTERNS = [
  /git\s+push/,
  /git\s+reset\s+--hard/,
  /git\s+clean\s+-f/,
  /git\s+branch\s+-D/,
  /git\s+checkout\s+\./,
  /git\s+restore\s+\./,
  /git\s+rebase/,
]

export const GitGuardrails: Plugin = async () => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool !== "bash") return

      const command = output.args?.command
      if (!command) return

      for (const pattern of BLOCKED_PATTERNS) {
        if (pattern.test(command)) {
          throw new Error(
            `BLOCKED: Destructive git command detected.\n\n` +
            `Command: ${command}\n` +
            `Pattern: ${pattern}\n\n` +
            `This command can cause irreversible data loss. If you genuinely need to run it, ` +
            `ask the user for explicit confirmation first. ` +
            `They can run it directly in their terminal.`
          )
        }
      }
    },
  }
}
