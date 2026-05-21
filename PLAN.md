# atalariq/skills — Setup Plan

**Stack committed:** Go + TypeScript (Bun)

## Goal

Buat repo `atalariq/skills` dari scratch: koleksi agent skills yang kompatibel dengan Opencode dan Hermes Agents, disesuaikan dengan stack dan use case sebagai Software Engineering Student, Backend Developer, dan Aspiring DevOps/SRE.

---

## Phase 1: Repo Scaffolding

**Buat struktur direktori berikut:**

```
atalariq/skills/
├── README.md               ← placeholder: "# atalariq/skills" + deskripsi singkat
├── skills/
│   ├── setup/
│   │   └── SKILL.md
│   ├── planning/
│   │   ├── grill-me/
│   │   │   └── SKILL.md
│   │   ├── grill-with-docs/
│   │   │   └── SKILL.md
│   │   │   → bundle: CONTEXT-FORMAT.md, ADR-FORMAT.md (from mattpocock)
│   │   ├── to-prd/
│   │   │   └── SKILL.md
│   │   └── to-issues/
│   │       └── SKILL.md
│   ├── coding/
│   │   ├── tdd/
│   │   │   └── SKILL.md
│   │   │   → bundle: tests.md, mocking.md, refactoring.md, deep-modules.md, interface-design.md
│   │   └── vertical-slice/
│   │       └── SKILL.md
│   ├── architecture/
│   │   ├── improve-codebase-architecture/
│   │   │   └── SKILL.md
│   │   │   → bundle: DEEPENING.md, HTML-REPORT.md, INTERFACE-DESIGN.md, LANGUAGE.md
│   │   └── api-design-review/
│   │       └── SKILL.md
│   ├── devops/              ← placeholder, deferred (Phase 6)
│   │   ├── setup-ci/
│   │   │   └── SKILL.md    ← "TODO: tulis saat ada proyek konkret — Go/TS/Bun CI scaffolding"
│   │   ├── dockerfile-review/
│   │   │   └── SKILL.md    ← "TODO: tulis saat ada proyek konkret — Dockerfile review checklist"
│   │   └── infra-grill/
│   │       └── SKILL.md    ← "TODO: tulis saat ada proyek konkret — grilling session infra decisions"
│   └── git/
│       └── git-guardrails/
│           └── SKILL.md
│           → bundle: opencode-block-dangerous-git.ts, hermes-block-dangerous-git.sh
```

**Deliverable:** Repo kosong dengan semua direktori dan file placeholder `SKILL.md` (isi frontmatter + `# TODO`). README.md placeholder di root. Semua folder dibikin sekarang, termasuk devops/ (biar struktur roadmap keliatan).

---

## Phase 2: `setup-skills` Skill

Tulis `skills/setup/SKILL.md` terlebih dahulu karena skill lain bergantung padanya.

Basis: `setup-matt-pocock-skills` dari mattpocock (path: `skills/engineering/setup-matt-pocock-skills/`). Adaptasi: rename ke `setup-skills`, generalisasi untuk Opencode + Hermes.

**Apa yang harus dilakukan skill ini saat dipanggil:**

### 2.1 Explore
- `git remote -v` dan `.git/config` — deteksi host (GitHub/GitLab)
- `AGENTS.md` / `CLAUDE.md` — sudah ada? Ada `## Agent skills` block?
- `CONTEXT.md` / `CONTEXT-MAP.md` di root
- `docs/adr/` — sudah ada?
- `docs/agents/` — sudah ada output sebelumnya?

### 2.2 Tanya user (satu per satu):
1. **Issue tracker** — GitHub Issues (default via `gh` CLI), GitLab (`glab`), local markdown (`.scratch/`), atau other (Jira/Linear)
2. **Triage labels** — 5 canonical roles: needs-triage, needs-info, ready-for-agent, ready-for-human, wontfix. Default string = nama role. Bisa override.
3. **Domain docs layout** — single-context (default) atau multi-context (monorepo)

### 2.3 Write:
- `## Agent skills` block di `CLAUDE.md` / `AGENTS.md`:
  ```markdown
  ## Agent skills
  ### Issue tracker
  [summary]. See `docs/agents/issue-tracker.md`.
  ### Triage labels
  [summary]. See `docs/agents/triage-labels.md`.
  ### Domain docs
  [single|multi-context]. See `docs/agents/domain.md`.
  ```
- `docs/agents/issue-tracker.md` — dari template bundled (GitHub/GitLab/local/other)
- `docs/agents/triage-labels.md` — label mapping
- `docs/agents/domain.md` — domain doc consumer rules + layout

**Bundled templates (copy dari Matt, adaptasi):**
- `issue-tracker-github.md`
- `issue-tracker-gitlab.md`
- `issue-tracker-local.md`
- `triage-labels.md`
- `domain.md`

**Note:** Skill ini harus idempotent — bisa di-run ulang tanpa ngerusak existing config. `to-prd`/`to-issues` akan auto-run ini sebagai fallback jika config missing.

**Format SKILL.md:** konvensi mattpocock — judul singkat, deskripsi satu kalimat, instruksi step-by-step, contoh output.

---

## Phase 3: Planning Skills (Copy + Adaptasi dari mattpocock)

Sumber: lokal `tmp-mattpocock-skills/` (clone dari `https://github.com/mattpocock/skills`)

Kategori sendiri (bukan ikut struktur Matt):
| Skill | Sumber di Matt | Kategori Kita |
|-------|---------------|---------------|
| `grill-me` | `skills/productivity/grill-me/` | `planning/` |
| `grill-with-docs` | `skills/engineering/grill-with-docs/` | `planning/` |
| `to-prd` | `skills/engineering/to-prd/` | `planning/` |
| `to-issues` | `skills/engineering/to-issues/` | `planning/` |

### `grill-me`
- Sumber: `skills/productivity/grill-me/SKILL.md`
- Sudah generic, hampir nggak ada yang perlu diubah
- Tidak ada referensi TypeScript-specific

### `grill-with-docs`
- Sumber: `skills/engineering/grill-with-docs/SKILL.md`
- Copy juga bundled: `CONTEXT-FORMAT.md`, `ADR-FORMAT.md`
- Pastikan instruksi membaca `CONTEXT.md` dan `docs/adr/` sesuai struktur dari `setup-skills`
- Catatan: "Jangan tulis setiap jawaban grilling ke CONTEXT.md — hanya tulis istilah domain yang disepakati"
- CONTEXT.md adalah glossary, bukan spec atau scratch pad

### `to-prd`
- Sumber: `skills/engineering/to-prd/SKILL.md`
- Ganti `/setup-matt-pocock-skills` → `/setup-skills`
- Fallback: auto-run `setup-skills` jika config missing
- Hapus referensi Total TypeScript atau workflow spesifik Matt jika ada
- Verifikasi GitHub Issues target via `gh` CLI
- Label: `ready-for-agent` (dari triage config)

### `to-issues`
- Sumber: `skills/engineering/to-issues/SKILL.md`
- Ganti `/setup-matt-pocock-skills` → `/setup-skills`
- Fallback: auto-run `setup-skills` jika config missing
- Verifikasi vertical slice logic masih intact
- Pastikan klasifikasi HITL vs AFK masih ada
- Publish issues via GitHub Issues (`gh` CLI)
- Dependency ordering (blockers first)

---

## Phase 4: Coding Skills

### `tdd`
- Sumber: `skills/engineering/tdd/SKILL.md`
- Copy SEMUA bundled resources: `tests.md`, `mocking.md`, `refactoring.md`, `deep-modules.md`, `interface-design.md`
- Hapus referensi `@total-typescript/shoehorn`
- Skill tetap TS-flavored (current project: Hono backend)
- Tambah appendix singkat "Go testing notes" (table-driven, `go test -race`, `testing.T`) — jangan pre-optimize ke full `tdd-go` dulu
- Filosofi: RED-GREEN-REFACTOR, vertical slices (bukan horizontal), test behavior not implementation, one test at a time

### `vertical-slice`
- Tulis sendiri — tidak ada di mattpocock
- Dipanggil agent sebagai **complement `to-issues`** — sebelum publish issues ke tracker
- Bukan grill session interaktif; **checklist yang di-enforce agent**
- Isi:
  1. Apakah setiap issue menyelesaikan satu path end-to-end? (bukan horizontal slice per layer)
  2. Apakah setiap issue bisa di-deploy/demo secara independen?
  3. Apakah setiap issue punya input/output boundaries yang jelas?
  4. Apakah ada dependency antar issue yang belum ditandai?
  5. Apakah granularitas konsisten? (tidak ada issue yang terlalu besar atau terlalu kecil)
- Kalo item gagal checklist → minta agent pecah ulang atau merge, baru publish

---

## Phase 5: Architecture Skills

### `improve-codebase-architecture`
- Sumber: `skills/engineering/improve-codebase-architecture/SKILL.md`
- Copy penuh + 4 supporting files: `DEEPENING.md`, `HTML-REPORT.md`, `INTERFACE-DESIGN.md`, `LANGUAGE.md`
- Proses 3 phase: Explore → HTML report (Tailwind + Mermaid CDN) → Grilling loop
- Pastikan referensi `CONTEXT.md` dan `docs/adr/` sesuai struktur `setup-skills`
- Pelajari sebagai blueprint untuk agent codebase analysis — teaching tool

### `api-design-review`
- Tulis sendiri
- Dipanggil di antara `to-prd` dan `to-issues` (pas implementation decisions dibahas di PRD)
- Scope: per feature/set endpoint, bukan full API audit
- Checklist reasoning yang di-verify agent (bukan baca OpenAPI/Swagger)
- Checklist:
  1. Naming consistency (plural nouns, no verbs di REST path)
  2. HTTP method semantics (GET idempotent, POST tidak idempotent, PUT idempotent, DELETE idempotent)
  3. Error response format (RFC 7807 Problem Details? atau konsisten dengan existing convention?)
  4. Pagination strategy (cursor-based vs offset-based — konsisten?)
  5. Authentication scope (endpoint ini butuh auth? level apa?)
  6. Rate limiting considerations
  7. Breaking change risk (ada client yang sudah consume endpoint ini?)
  8. Request/response schema konsisten dengan domain vocabulary di CONTEXT.md?

---

## Phase 6: DevOps Skills (Deferred)

Struktur direktori + placeholder SKILL.md dibuat di Phase 1. Isi skill ditulis on-demand saat ada proyek konkret.

### `setup-ci`
- Intent: scaffold GitHub Actions untuk project Go atau TypeScript/Bun
- Tulis saat pertama kali setup CI untuk project PAD atau side project

### `dockerfile-review`
- Intent: checklist review Dockerfile sebelum commit
- Checklist: multi-stage build, non-root user, `.dockerignore`, layer caching, no secrets
- Tulis saat pertama kali bikin Dockerfile untuk project nyata

### `infra-grill`
- Intent: grill session khusus keputusan infra (database, cache, queue, deployment target)
- Tulis saat mulai project yang punya infra decisions non-trivial

---

## Phase 7: Git Safety

### `git-guardrails`
- **Approach #3:** satu SKILL.md, dua bundle implementation:
  - `opencode-block-dangerous-git.ts` — plugin untuk `.opencode/plugins/`
  - `hermes-block-dangerous-git.sh` — script untuk `~/.hermes/config.yaml` hooks block
- Agent detect platform dari context (AGENTS.md vs CLAUDE.md detection)
- **Opencode:** JS/TS plugin dengan `tool.execute.before` hook, intercept bash commands, block destructive git sebelum eksekusi
- **Hermes:** Shell hooks di `hooks:` block + shell script checker
- **Blocked commands:**
  - `git push` (semua variant termasuk `--force`)
  - `git reset --hard`
  - `git clean -f` / `git clean -fd`
  - `git branch -D`
  - `git checkout .` / `git restore .`
  - `git rebase` (tanpa flag konfirmasi)
- **Fallback rule-based:** jika hook nggak applicable, inject aturan ke AGENTS.md/CLAUDE.md via `setup-skills`: "Jangan jalankan perintah git destruktif tanpa konfirmasi eksplisit dari user"

---

## Phase 8: README

Tulis `README.md` lengkap setelah semua skill selesai (Phase 1 cuma placeholder).

Isi:
1. **Intro singkat** — apa ini dan untuk siapa
2. **Workflow utama** — diagram teks: `setup-skills` → `grill-with-docs` → `to-prd` → `api-design-review` → `vertical-slice` → `to-issues` → `tdd`
3. **Daftar skills** per kategori dengan deskripsi satu kalimat
4. **Cara install** — instruksi untuk Opencode (symlink/copy ke `.opencode/`) dan Hermes Agents (symlink ke `~/.hermes/skills/`)
5. **Credits** — attribution ke mattpocock/skills (MIT)

---

## Urutan Pengerjaan

```
Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5 → Phase 7 → Phase 8
                                                              (Phase 6: placeholder di Phase 1, isi on-demand)
```

---

## Catatan untuk Opencode

- Matikan Plan Mode selama mengerjakan ini — tidak diperlukan, skill sendiri yang enforce "jangan eksekusi dulu"
- Jalankan `setup-skills` di setiap repo baru sebelum pakai skill lain
- `grill-with-docs` dan `to-prd` selalu satu conversation
- `to-issues` boleh conversation baru jika context window sudah berat setelah grilling panjang
- Plugins dalam `.opencode/plugins/` (JS/TS) — gunakan `tool.execute.before` untuk git-guardrails
