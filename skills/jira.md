---
title: "Jira Operations"
date: "{{date}}"
tags: ["skill", "jira", "sprint", "tickets"]
category: "skills"
summary: "Jira operations — sprint init, ticket creation, querying. Config in profile.md."
trigger: "User asks to create tickets, init sprint, or query Jira"
integration: "jira"
related: []
needs-split: false
---

All Jira config (project, board, custom fields, sprint convention) lives in `profile.md` under `## Tools > Jira`. Read it before executing any operation.

If config is missing, ask the user and update `profile.md` so future sessions don't re-ask.

---

## Operation: Init Sprint

### Trigger
User says "init sprint", "start my sprint", "what's on my plate", or a new sprint begins.

### Steps

1. Query board (from profile.md) for active sprint. Extract sprint name and date range.
2. Pull all issues assigned to current user in the active sprint. Capture: key, summary, status, priority, epic, story points, issue type.
3. Map tickets to KB projects:
   - Read each `projects/working-on/*/context.md` for scope, tags, and keywords
   - Fuzzy-match tickets by summary, epic, or tags
   - Unmatched tickets go in an "Unmapped" section
4. Check yesterday's daily task file for incomplete items (carryover).
5. Create today's `daily-tasks/{YYYY}/{MM}/{YYYY-MM-DD}.md` with tickets grouped by project.
6. For each project with new tickets, create/update today's project update file with `source: propagated`.

---

## Operation: Create Ticket

### Trigger
User says "create a ticket", "file a story", "make an epic for...".

### Steps

1. Read custom fields and project config from `profile.md`.
2. Ask user for summary and description. Infer issue type from context (Epic, Story, Task, Bug).
3. Apply custom fields from profile (squad, agile team, etc.).
4. Ask whether to add to the current sprint.

### Guidelines
- No story points or deadlines when creating — those are set during grooming.
- Default priority: 2-Medium.
- Confirm squad/team if unclear.
- **Description style:** Concise. Don't pad with sections for the sake of format. Wrap code/project-specific terms in backticks.
- **Description formatting:** Pass description as a plain string with real newlines — do NOT use `\n` escape sequences. They get double-escaped and render as literal `\\n` in Jira.

---

## Operation: Query Tickets

### Trigger
User asks "what's the status of...", "show my open tickets", "what's in progress".

### Steps

1. Determine query scope from user intent:
   - My open tickets: `assignee = currentUser() AND status != Done`
   - Current sprint: `sprint in openSprints() AND assignee = currentUser()`
   - Specific ticket: `key = PROJ-XXXX`
   - By status: `status = "In Progress" AND assignee = currentUser()`
2. Query Jira with appropriate JQL.
3. Return results as a concise summary: key, summary, status, priority.
