---
name: vertical-slice
description: Pre-publish checklist that verifies every issue is a true vertical slice before it hits the issue tracker. Run automatically as a complement to to-issues.
---

# Vertical Slice Verification

Before publishing any issue to the tracker, verify that each one passes this checklist. Do NOT publish issues that fail. Instead, rework them until they pass.

## Checklist

For each proposed issue, verify all five:

1. **End-to-end path** — Does this issue complete a full path through every layer (schema → logic → API/UI → tests)? It must NOT be a horizontal slice of only one layer.

2. **Independent demoability** — Can this issue be deployed, verified, or demonstrated on its own without depending on other in-progress work? The answer must be yes.

3. **Clear I/O boundaries** — Are the inputs and outputs of this issue well-defined? Another developer (or agent) picking it up should know exactly what they start with and what "done" looks like.

4. **Dependencies marked** — If this issue genuinely depends on another, is that dependency explicitly stated? If no dependencies, is it marked "can start immediately"?

5. **Consistent granularity** — Is this issue roughly the same size as other issues in the batch? No oversized epics disguised as single issues, no trivial one-liners inflated to look meaningful.

## What to do on failure

If any issue fails the checklist:

- **Too big** → Split into smaller vertical slices. Each child must also pass this checklist.
- **Horizontal** → Re-slice. A backend-only ticket with no UI/test path is not a vertical slice. Add the missing layers or merge with the complementary frontend ticket.
- **Unclear boundaries** → Ask the user to clarify. Do not guess.
- **Unmarked dependency** → Identify the blocker and mark it.

## When to run

Run this automatically after drafting issues with `to-issues`, BEFORE publishing them to the issue tracker. This is an enforcement gate, not an optional review.

Do not ask the user "should I run vertical-slice?" — just run it. If issues pass, proceed to publish. If they fail, fix them and re-verify.
