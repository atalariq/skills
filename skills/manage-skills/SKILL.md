---
name: manage-skills
description: Create new agent skills, review existing ones for quality, and run grill sessions to improve skill design. Use when user wants to create, review, improve, or get grilled about a skill.
---

# Manage Skills

Three modes — the agent detects which one the user needs from context.

## Mode 1: Create a New Skill

### Process

1. **Gather requirements** — ask the user:
   - What task or domain does the skill cover?
   - What specific use cases should it handle?
   - Does it need executable scripts or just instructions?
   - Any reference materials to include?

2. **Draft the skill** — create:
   - `SKILL.md` with concise instructions and YAML frontmatter (`name`, `description`)
   - Additional reference files if content exceeds 100 lines
   - Utility scripts if deterministic operations needed

3. **Review with user** — present draft and ask:
   - Does this cover your use cases?
   - Anything missing or unclear?
   - Should any section be more or less detailed?

### Skill Structure

```
skill-name/
├── SKILL.md          # Main instructions (required)
├── references/       # Detailed docs (if needed)
├── templates/        # Template files (if needed)
└── scripts/          # Utility scripts (if needed)
    └── helper.sh
```

### SKILL.md Template

```md
---
name: skill-name
description: Brief description of capability. Use when [specific triggers].
---

# Skill Name

## Quick start

[Minimal working example]

## Workflow

[Step-by-step process with checklists for complex tasks]

## Advanced features

[Link to separate files: See [REFERENCE.md](references/REFERENCE.md)]
```

### Description Requirements

The description is **the only thing your agent sees** when deciding which skill to load. It's surfaced in the system prompt alongside all other installed skills.

**Goal**: Give the agent just enough info to know:
1. What capability this skill provides
2. When and why to trigger it (specific keywords, contexts, file types)

**Format**:
- Max 1024 chars
- Write in third person
- First sentence: what it does
- Second sentence: "Use when [specific triggers]"

**Good example**:
```
Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when user mentions PDFs, forms, or document extraction.
```

**Bad example**:
```
Helps with documents.
```

The bad example gives the agent no way to distinguish this from other document skills.

### When to Add Scripts

Add scripts when:
- Operation is deterministic (validation, formatting)
- Same code would be generated repeatedly
- Errors need explicit handling

### When to Split Files

Split into separate files when:
- SKILL.md exceeds 100 lines
- Content spans distinct domains
- Advanced features are rarely needed

---

## Mode 2: Review an Existing Skill

Run when the user says "review skill X" or "check my skill." Do NOT modify the skill — only report findings.

### Process

1. **Read the SKILL.md** — load the full skill content
2. **Verify against this checklist**:

#### Metadata
- [ ] Has `name` in YAML frontmatter
- [ ] Has `description` in YAML frontmatter with triggers ("Use when...")
- [ ] Description is under 1024 characters
- [ ] Description is in third person

#### Structure
- [ ] SKILL.md is under 100 lines (split to bundled files if not)
- [ ] Instructions are clear and step-by-step (not vague prose)
- [ ] No time-sensitive info hardcoded
- [ ] Terminology is consistent throughout

#### Progressive Disclosure
- [ ] Agent can understand what the skill does from description alone
- [ ] Core instructions are in SKILL.md, advanced details in bundled files
- [ ] Bundled files are referenced by relative paths

#### Quality
- [ ] Concrete examples are included (not abstract descriptions)
- [ ] Edge cases or error conditions are addressed
- [ ] No platform-specific assumptions unless intentional
- [ ] References to external files use correct relative paths

3. **Report** — present findings as a list. Mark each item as ✅ pass or ⚠️ needs attention. End with a **Top recommendation**: the one highest-impact fix.

Example output:
```
Skill review: tdd

✅ Metadata: name + description present, under 1024 chars
✅ Structure: SKILL.md is 126 lines (close to 100 — consider splitting)
⚠️ Progressive disclosure: description mentions "red-green-refactor" but not that it includes Go appendix
✅ Quality: concrete examples in tests.md and mocking.md

Top recommendation: Update description to mention Go appendix so Go users know it supports them too.
```

---

## Mode 3: Grill the Skill Design

Run when the user wants to improve a skill through questioning. Based on the `grill-me` pattern but focused specifically on skill design decisions.

### Process

Ask one question at a time. Walk the design tree — resolve each decision before moving to the next.

#### Round 1: Scope
- What specific problem does this skill solve? Can you state it in one sentence?
- What is explicitly OUT of scope? What should the agent NOT do?
- If another skill overlaps with this one, how do they differ?

#### Round 2: Triggers
- What exact keywords or contexts should trigger this skill?
- Are there false-positive triggers? (e.g., "deploy" triggering a deploy skill when user just said "deploy a joke")
- What does the agent see in the description that makes it pick THIS skill over others?

#### Round 3: Instructions
- Walk through the ideal flow: what does the agent do first, second, third?
- Where does the agent need to stop and ask the user?
- What does the agent do when something goes wrong?
- Are there decisions the agent should NOT make on its own?

#### Round 4: Bundled Resources
- Does this skill need scripts? Or are instructions sufficient?
- Would any bundled file be read more than once? (If not, inline it)
- Are all relative paths correct?

End the grill session by asking: "What's the one thing you'd change about this skill after this conversation?"
