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

### Step 0: How to Query Glean

When calling the Glean `chat` tool, prompt for **detailed, structured responses** — not high-level summaries. Glean defaults to human-friendly summaries, but the agent needs specifics.

**Prompting rules:**
- Ask for lists, names, dates, and concrete values — not overviews
- Request tree/hierarchy format for org charts and structures
- Ask for all items, not "top 3" or "key highlights"
- If the first response is too vague, follow up with a more specific question

**Examples:**

Bad: "What's the release process?"
Good: "What are the exact release days, code freeze times, and deploy schedule? Include specific days of the week and times with timezone."

Bad: "Who's on the team?"
Good: "List all engineers on the {{team}} team with their full names and titles. Show the reporting chain from IC to VP level."

### Step 1: Check if Already Cached

Search local files for the fact:
```
grep -ri "<key term>" people/ projects/ skills/ daily-tasks/
```

If already present and accurate, stop — no action needed.

### Step 2: Determine Where to Cache

| Fact type | Cache location |
|-----------|---------------|
| Company-wide facts (fiscal year, org acronyms, policies) | `profile.md` § Company Knowledge |
| Person info (role, team, reporting) | `people/{person-slug}.md` |
| Org/team structure, team mappings | `people/` or relevant project `context.md` |
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

**Don't cache:** "Current on-call for {team} is {person} this week" → ephemeral, skip
