---
title: "Convention Audit"
date: "2026-04-22"
tags: ["workflow", "agent", "audit"]
category: "skills"
summary: "Scan the knowledge base for convention violations"
trigger: "User asks to audit the knowledge base, or agent detects potential violations"
integration: ""
related: []
needs-split: false
---

## Trigger
Run this workflow when:
- The user asks to "audit my knowledge base" or "check conventions"
- The agent detects a potential violation during a create/update operation
- Periodic self-check after a batch of file operations

## Inputs
- `kb_root`: Path to the knowledge base root directory (default: current working directory)
- `scope`: Which checks to run — `all` (default), or one of: `structure`, `naming`, `frontmatter`, `size`, `placeholders`

## Steps

### Step 1: Verify Directory Structure

Expected directories:
- `daily-tasks/`
- `projects/working-on/`
- `projects/finished/`
- `skills/`
- `personal-workflows/mr-reviews/`
- `personal-workflows/interactions/`
- `personal-workflows/performance-review/`
- `people/`
- `templates/`

Also verify `profile.md`, `README.md`, and `AGENTS.md` exist at the root.

### Step 2: Check Naming Conventions

Enumerate files and validate paths:
- Daily tasks: `daily-tasks/{YYYY}/{MM}/{YYYY-MM-DD}.md` — directory components match filename date
- Skills: kebab-case slugs
- MR reviews: `personal-workflows/mr-reviews/{TICKET-ID}.md`
- Interactions: `personal-workflows/interactions/{person-slug}-{YYYY-MM-DD}.md`
- People notes: kebab-case slugs
- Project updates: `{YYYY-MM-DD}.md` inside project dir
- Staging: `staging-{slug}-{YYYY-MM-DD}.md`
- Lessons: `lessons-{YYYY-MM-DD}.md`

Flag any file whose path does not conform.

### Step 3: Validate Front-Matter Schemas

Check all `.md` files **except** `README.md`, `AGENTS.md`, `CLAUDE.md`, and `profile.md` (which has its own schema).

Required common fields: `title`, `date`, `tags`, `category`, `summary`.

Type-specific required fields:
- Project context: `status`, `stakeholders`
- Project update: `project`, `source`
- MR review: `ticket-id`, `repository`, `outcome`
- Interaction: `person`
- People note: `person`, `role`, `team`

### Step 4: Check File Size Limits

Soft limits (flag as warning):
- Project files (updates, staging, lessons): 100 lines
- Interaction summaries, MR reviews: 150 lines

Hard limit (flag as violation):
- All files except skills: 200 lines
- Skills are exempt from size limits

### Step 5: Verify `needs-split` Flags

- Over 200 lines but `needs-split: false` → violation
- Under 200 lines but `needs-split: true` → stale flag, review

### Step 6: Check for Unresolved Placeholder Tokens

Scan all files **except** `templates/` for unresolved `{{...}}` tokens. Flag each with file path and line number.

## Output Format

```
## Convention Audit Report
Date: {audit-date}
Scope: {scope-run}

### 1. Directory Structure
Status: PASS | FAIL
Missing: [list or "none"]

### 2. Naming Conventions
Status: PASS | FAIL
Violations:
- {file-path}: {reason}

### 3. Front-Matter Schema
Status: PASS | FAIL
Violations:
- {file-path}: missing [{fields}]

### 4. File Size Limits
Status: PASS | FAIL
Warnings (soft limit):
- {file-path}: {lines} lines (limit: {limit})
Violations (hard limit):
- {file-path}: {lines} lines

### 5. needs-split Flags
Status: PASS | FAIL
Missing flag: {list}
Stale flag: {list}

### 6. Unresolved Placeholders
Status: PASS | FAIL
- {file-path}:{line}: {match}

---
Overall: PASS | FAIL | Total violations: {n} | Action required: {yes|no}
```
