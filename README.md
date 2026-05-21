# atalariq/skills

[![skills.sh](https://skills.sh/b/atalariq/skills)](https://skills.sh/atalariq/skills)

A personal collection of agent skills for **OpenCode** and **Hermes Agents** — designed for Software Engineering, Backend Development, and DevOps/SRE workflows. Focus stack: **Go** and **TypeScript (Bun)**.

Built on the [Agent Skills](https://agentskills.io/) open standard. Several skills adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).

## Quick Install

```bash
npx skills add atalariq/skills
```

Requires the [`skills` CLI](https://github.com/vercel-labs/skills) (from Vercel). Works with 55+ AI coding agents including OpenCode, Claude Code, Cursor, and Codex.

## Core Workflow

These skills form a pipeline from project setup through design, planning, and implementation:

```
setup-skills  →  grill-with-docs  →  to-prd  →  api-design-review  →  vertical-slice  →  to-issues  →  tdd
   (init)        (domain model)    (spec)    (endpoint check)       (slice verify)    (breakdown)   (implement)
```

1. **[`setup-skills`](skills/setup/SKILL.md)** — Initialize project structure: issue tracker, triage labels, domain doc layout. Run once per repo.
2. **[`grill-with-docs`](skills/grill-with-docs/SKILL.md)** — Stress-test your plan against the domain model, sharpen terminology, update `CONTEXT.md` inline as decisions crystallize.
3. **[`to-prd`](skills/to-prd/SKILL.md)** — Synthesize a PRD from the conversation context and publish it to your issue tracker.
4. **[`api-design-review`](skills/api-design-review/SKILL.md)** — Verify API design decisions before issues are created (naming, HTTP semantics, auth, pagination, error format).
5. **[`vertical-slice`](skills/vertical-slice/SKILL.md)** — Enforcement gate: ensure every issue is a true vertical slice before publishing.
6. **[`to-issues`](skills/to-issues/SKILL.md)** — Break the PRD into independently-grabbable issues using tracer-bullet vertical slices (HITL vs AFK).
7. **[`tdd`](skills/tdd/SKILL.md)** — Implement each issue with RED-GREEN-REFACTOR. Test behavior, not implementation. TS examples + Go appendix.

## All Skills

### Setup
| Skill | Description |
|-------|-------------|
| [`setup-skills`](skills/setup/SKILL.md) | Scaffold per-repo config: issue tracker, triage labels, domain docs. Run first. |

### Planning
| Skill | Description |
|-------|-------------|
| [`grill-me`](skills/grill-me/SKILL.md) | Grilling session — interview relentlessly about a plan or design. |
| [`grill-with-docs`](skills/grill-with-docs/SKILL.md) | Grilling + update CONTEXT.md and ADRs inline as decisions crystallize. |
| [`to-prd`](skills/to-prd/SKILL.md) | Synthesize PRD from conversation context → publish to issue tracker. |
| [`to-issues`](skills/to-issues/SKILL.md) | Break PRD into vertical slice issues (tracer bullets). |

### Coding
| Skill | Description |
|-------|-------------|
| [`tdd`](skills/tdd/SKILL.md) | RED-GREEN-REFACTOR loop. TS examples + Go appendix. |
| [`vertical-slice`](skills/vertical-slice/SKILL.md) | Pre-publish checklist: verify every issue is a true vertical slice. |

### Architecture
| Skill | Description |
|-------|-------------|
| [`improve-codebase-architecture`](skills/improve-codebase-architecture/SKILL.md) | Surface architectural friction, propose deepening opportunities — with HTML report. |
| [`api-design-review`](skills/api-design-review/SKILL.md) | Checklist-based API design review: naming, HTTP semantics, errors, auth, pagination. |

### DevOps
| Skill | Description |
|-------|-------------|
| [`setup-ci`](skills/setup-ci/SKILL.md) | `🚧 Deferred` — scaffold CI pipeline for Go or TypeScript/Bun. |
| [`dockerfile-review`](skills/dockerfile-review/SKILL.md) | `🚧 Deferred` — Dockerfile review checklist. |
| [`infra-grill`](skills/infra-grill/SKILL.md) | `🚧 Deferred` — infrastructure decision grilling. |

### Git
| Skill | Description |
|-------|-------------|
| [`git-guardrails`](skills/git-guardrails/SKILL.md) | Block destructive git commands — Opencode plugin (.ts) + Hermes shell hook (.sh). |

## Quick Walkthrough

Here's a hands-on example of using these skills end-to-end for a new backend feature.

### 1. Initialize the project

```
/setup-skills
```

The agent scans your repo (git remote, existing CLAUDE.md/AGENTS.md) and asks three questions:

- **Issue tracker**: GitHub Issues (default) — we'll use `gh` CLI
- **Triage labels**: Stick with defaults (needs-triage, needs-info, ready-for-agent, ready-for-human, wontfix)
- **Domain docs**: Single-context layout (one CONTEXT.md at repo root)

It creates `docs/agents/` with configuration files and adds a block to `AGENTS.md`. Now all other skills know where to read/write issues and domain vocabulary.

### 2. Design the feature

You have a rough idea: *"Users should be able to generate API keys for programmatic access."*

```
/grill-with-docs

I want users to be able to create and manage API keys for programmatic access to their data.
```

The agent grills you:
- "Is an API key per-user or per-organization?"
- "Does 'manage' mean create/revoke/list, or also rotate?"
- "What scope does a key have? Read-only? Read-write? Admin?"

As decisions are made, it updates `CONTEXT.md`:
```
API Key — a per-user credential for programmatic access. Has a scope (read, write, admin)
and a lifecycle (active, revoked). One user can have multiple active keys.
```

### 3. Produce a PRD

```
/to-prd
```

The agent synthesizes everything from the conversation into a structured PRD:

- **Problem Statement** — Users need programmatic access but sharing passwords is insecure
- **User Stories** — 8 stories covering key creation, listing, revocation, scoping, expiry
- **Implementation Decisions** — Module sketch, endpoint contracts, auth flow
- **Testing Decisions** — What to test (behavior) and what to mock (system boundaries)

It publishes the PRD as a GitHub issue with the `ready-for-agent` label.

### 4. Review API design

Before creating implementation issues, the agent runs `api-design-review` automatically:

```
⚠️ API design issues found:
1. Naming: PUT /api-key/:id conflicts with domain vocabulary — use /api-keys/:id
2. Pagination: GET /api-keys returns all keys — add cursor-based pagination
3. Auth: POST /api-keys requires user:write scope, not just user:read
```

You fix these, then proceed.

### 5. Break into issues

```
/to-issues
```

The agent drafts vertical slices and quizzes you:

| # | Title | Type | Blocked by |
|---|-------|------|------------|
| 1 | POST /api-keys — create with scope and expiry | AFK | None |
| 2 | GET /api-keys — list with cursor pagination | AFK | #1 |
| 3 | DELETE /api-keys/:id — revoke key | AFK | #1 |
| 4 | Auth middleware — API key validation | HITL | None |

Before publishing, the agent silently runs `vertical-slice` to verify each issue is independently deployable. Issues that pass get published in dependency order.

### 6. Implement with TDD

```
/tdd
```

For issue #1 ("POST /api-keys — create with scope and expiry"):

```typescript
// RED: test fails
test("user can create API key with read scope", async () => {
  const key = await createApiKey(user.id, { scope: "read" });
  expect(key.scope).toBe("read");
  expect(key.createdAt).toBeInstanceOf(Date);
});

// GREEN: minimal code to pass
async function createApiKey(userId, opts) {
  return db.apiKeys.create({ userId, scope: opts.scope, status: "active" });
}

// REFACTOR: extract duplication, deepen modules
```

Repeat for each issue — one RED→GREEN cycle at a time, vertical slice by vertical slice.

---

**Result**: You've gone from a vague idea to deployed, tested feature in 6 skills — each one enforcing quality at its specific gate.

## Manual Installation

If you prefer not to use the CLI:

### OpenCode

```bash
# Clone the repo
git clone https://github.com/atalariq/skills

# Symlink skills to OpenCode skills directory
ln -s $(pwd)/skills/setup ~/.config/opencode/skills/setup
ln -s $(pwd)/skills/planning/grill-me ~/.config/opencode/skills/grill-me
# ... repeat for each skill

# Or install as OpenCode plugins (for git-guardrails)
cp skills/git-guardrails/opencode-block-dangerous-git.ts .opencode/plugins/git-guardrails.ts
```

### Hermes Agents

```bash
git clone https://github.com/atalariq/skills

# Symlink skills
ln -s $(pwd)/skills/setup ~/.hermes/skills/setup
ln -s $(pwd)/skills/planning/grill-me ~/.hermes/skills/grill-me
# ... repeat for each skill

# Configure git-guardrails hook
chmod +x skills/git-guardrails/hermes-block-dangerous-git.sh
# Add to ~/.hermes/config.yaml hooks block
```

## Credits

Several skills adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT License):

| Skill | Source |
|-------|--------|
| `setup-skills` | adapted from `setup-matt-pocock-skills` |
| `grill-me` | direct copy (already generic) |
| `grill-with-docs` | adapted (added domain-term-only rule) |
| `to-prd` | adapted (`/setup-skills` + auto-run fallback) |
| `to-issues` | adapted (`/setup-skills` + auto-run fallback) |
| `tdd` | adapted (Go appendix added) |
| `improve-codebase-architecture` | adapted (cross-refs fixed, Explore generalized) |

Custom skills: `vertical-slice`, `api-design-review`, `git-guardrails`, DevOps placeholders.

## License

MIT — same as upstream [mattpocock/skills](https://github.com/mattpocock/skills).
