---
title: "Glean Knowledge Cache"
date: "2026-04-20"
tags: ["workflow", "agent", "glean", "cache", "knowledge"]
category: "skills"
summary: "Cache durable facts learned from Glean searches into local knowledge base files"
trigger: "Agent learns a new durable fact from a Glean search"
integration: ""
related: []
needs-split: false
---

## Trigger
Run this workflow when:
- A Glean search returns a durable fact not already cached locally (org structure, acronyms, team mappings, process definitions)
- The user explicitly asks to cache something from Glean

Do NOT cache:
- Ephemeral data (on-call rotations, sprint status, meeting agendas, ticket states)
- Large documents — link to them instead
- Anything that changes weekly or more frequently

## Decision Criteria

Ask: **"Will this fact still be true in 3+ months?"**
- Yes → cache it
- No / unsure → leave it as a live Glean lookup

## Steps

### Step 1: Check if Already Cached

Search local files for the fact:
```
grep -ri "<key term>" people/ projects/ skills/ daily-tasks/
```

If already present and accurate, stop — no action needed.

### Step 2: Determine Where to Cache

| Fact type | Cache location |
|-----------|---------------|
| Person info (role, team, reporting) | `people/{person-slug}.md` |
| Org/team structure, acronyms | `people/` or relevant project `context.md` |
| Process or convention | `skills/{skill-slug}.md` |
| Project-specific context | `projects/working-on/{slug}/context.md` |

### Step 3: Write the Cached Fact

- If updating an existing file, append under a `## Reference` or relevant section
- If creating a new file, use the appropriate template
- Include a brief source note: `(source: Glean, YYYY-MM-DD)`
- Keep it concise — one to three lines per fact

### Step 4: Confirm

Tell the user what was cached and where, so they can correct if needed.

## Examples

**Cache:** "ACME Platform = Payments, Identity, Ledger — org-level grouping at {{company}}" → append to a relevant people note or project context with `(source: Glean, YYYY-MM-DD)`

**Don't cache:** "Current on-call for BORN is Prateek this week" → ephemeral, skip
