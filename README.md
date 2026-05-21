# atalariq/skills

Koleksi agent skills untuk **OpenCode** dan **Hermes Agents** — dirancang untuk workflow Software Engineering Student, Backend Developer, dan Aspiring DevOps/SRE. Stack fokus: **Go** dan **TypeScript (Bun)**.

## Workflow Utama

```
setup-skills  →  grill-with-docs  →  to-prd  →  api-design-review  →  vertical-slice  →  to-issues  →  tdd
   (init)        (domain model)    (spec)    (endpoint check)       (slice verify)    (breakdown)   (implement)
```

1. **`setup-skills`** — inisialisasi struktur proyek: issue tracker, triage labels, domain doc layout
2. **`grill-with-docs`** — stress-test plan against domain model, sharpen terminology, update CONTEXT.md inline
3. **`to-prd`** — synthesize PRD dari conversation context, publish ke issue tracker
4. **`api-design-review`** — verifikasi API design decisions sebelum issues dibuat
5. **`vertical-slice`** — enforcement gate: pastikan setiap issue adalah true vertical slice
6. **`to-issues`** — break PRD menjadi independently-grabbable issues (HITL vs AFK)
7. **`tdd`** — implement tiap issue dengan RED-GREEN-REFACTOR loop

## Skills per Kategori

### Setup
| Skill | Deskripsi |
|-------|-----------|
| [`setup-skills`](skills/setup/SKILL.md) | Scaffold per-repo config: issue tracker, triage labels, domain layout. Run sekali di awal. |

### Planning
| Skill | Deskripsi |
|-------|-----------|
| [`grill-me`](skills/planning/grill-me/SKILL.md) | Grilling session — interview relentlessly tentang plan/design |
| [`grill-with-docs`](skills/planning/grill-with-docs/SKILL.md) | Grilling + update CONTEXT.md dan ADRs inline as decisions crystallize |
| [`to-prd`](skills/planning/to-prd/SKILL.md) | Synthesize PRD dari conversation context → publish ke issue tracker |
| [`to-issues`](skills/planning/to-issues/SKILL.md) | Break PRD menjadi vertical slice issues (tracer bullets) |

### Coding
| Skill | Deskripsi |
|-------|-----------|
| [`tdd`](skills/coding/tdd/SKILL.md) | RED-GREEN-REFACTOR loop — test behavior, not implementation. TS + Go appendix |
| [`vertical-slice`](skills/coding/vertical-slice/SKILL.md) | Pre-publish checklist: pastikan setiap issue adalah true vertical slice |

### Architecture
| Skill | Deskripsi |
|-------|-----------|
| [`improve-codebase-architecture`](skills/architecture/improve-codebase-architecture/SKILL.md) | Surface architectural friction, propose deepening opportunities — with HTML report |
| [`api-design-review`](skills/architecture/api-design-review/SKILL.md) | Checklist-based API design review: naming, HTTP semantics, error format, auth, pagination |

### DevOps
| Skill | Deskripsi |
|-------|-----------|
| [`setup-ci`](skills/devops/setup-ci/SKILL.md) | `🚧 Deferred` — scaffold CI pipeline (Go/TS) |
| [`dockerfile-review`](skills/devops/dockerfile-review/SKILL.md) | `🚧 Deferred` — Dockerfile review checklist |
| [`infra-grill`](skills/devops/infra-grill/SKILL.md) | `🚧 Deferred` — infrastructure decision grilling |

### Git
| Skill | Deskripsi |
|-------|-----------|
| [`git-guardrails`](skills/git/git-guardrails/SKILL.md) | Block destructive git commands (push --force, reset --hard, clean -f, rebase) — Opencode plugin + Hermes shell hook |

## Cara Install

### OpenCode

Copy skill folder ke project atau global plugin directory:

```bash
# Per-project
cp -r skills/<skill-name> .opencode/skills/<skill-name>/

# Global
cp -r skills/<skill-name> ~/.config/opencode/skills/<skill-name>/
```

Untuk `git-guardrails` plugin, copy `.ts` file:

```bash
cp skills/git/git-guardrails/opencode-block-dangerous-git.ts .opencode/plugins/git-guardrails.ts
```

### Hermes Agents

Symlink skill folder ke Hermes skills directory:

```bash
ln -s $(pwd)/skills/<skill-name> ~/.hermes/skills/<skill-name>
```

Untuk `git-guardrails` hook:

```bash
chmod +x skills/git/git-guardrails/hermes-block-dangerous-git.sh
# Configure in ~/.hermes/config.yaml hooks block
```

## Credits

Beberapa skill diadaptasi dari [mattpocock/skills](https://github.com/mattpocock/skills) (MIT License):

| Skill | Sumber |
|-------|--------|
| `setup-skills` | `setup-matt-pocock-skills` |
| `grill-me` | `grill-me` |
| `grill-with-docs` | `grill-with-docs` |
| `to-prd` | `to-prd` |
| `to-issues` | `to-issues` |
| `tdd` | `tdd` |
| `improve-codebase-architecture` | `improve-codebase-architecture` |

Modifikasi untuk kompatibilitas OpenCode + Hermes, dan disesuaikan dengan stack Go + TypeScript.

## License

MIT — sama seperti upstream [mattpocock/skills](https://github.com/mattpocock/skills).
