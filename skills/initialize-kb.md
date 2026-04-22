---
title: "Initialize Knowledge Base"
date: "{{date}}"
tags: ["workflow", "agent", "setup"]
category: "skills"
summary: "Interactive setup flow for new knowledge base users"
trigger: "User runs setup for the first time, or profile.md still contains {{placeholder}} tokens"
integration: ""
related: []
needs-split: false
---

## Trigger

Run this workflow when:
- The user says "initialize", "set up", or "get started"
- The agent detects `profile.md` contains unresolved `{{...}}` tokens
- No `profile.md` exists at the knowledge base root
- The user wants to add tools or skills after initial setup

## Re-entry

If `profile.md` already exists and has no unresolved `{{...}}` tokens, this is a **partial re-run**. Skip steps the user has already completed:

1. Check `profile.md` — if front-matter has `company`, `team`, `role` filled → skip Step 2
2. Check `profile.md` `## Tools` — if tools already listed → ask "Want to add more tools, or skip?"
3. Check `skills/` — if skill files exist → ask "Want to add more workflows, or skip?"

Jump directly to the first incomplete step.

## Prerequisites

Before starting, verify:
1. `README.md` exists at the root (conventions reference)
2. `templates/` directory exists with all 10 templates
3. `templates/profile.md` exists (template source)

If any are missing, inform the user and stop.

## Steps

### Step 1: Welcome & Explain

> "This is a convention-driven personal knowledge base. I'll ask you a few questions to set up your profile and workflows, then you're ready to go."

### Step 2: Collect Profile Info

Ask **one at a time**, waiting for each answer:

1. **Company** — "What company do you work at?"
2. **Team** — "What team are you on?"
3. **Role** — "What's your current role/title?"
4. **Background** (optional) — "Any brief background? (teams, domains, experience)"
5. **Current goals** (optional) — "Any goals you're working toward?"
6. **Notable work** (optional) — "Any highlights worth noting?"

If the user says "skip" to any optional question, use the placeholder text from the template.

### Step 3: Collect Tool Integrations

Ask: "What tools do you use that have MCP servers? (e.g., Jira, Confluence, Glean, GitHub, Slack)"

For each tool the user mentions:
- Ask for the MCP server name
- Ask for any key config values (e.g., Jira project key, board ID, custom fields)
- Record under `## Tools` in `profile.md`

If the user doesn't know or says "none", skip — tools can be added later.

### Step 4: Collect Workflows for Skills

Ask: "What recurring workflows do you want the agent to handle? For example:"
- Sprint initialization (pull tickets, map to projects)
- Ticket creation with custom fields
- Machine migration checklists
- Code review tracking
- Anything you do repeatedly that could be a reusable instruction

For each workflow the user describes:
1. Ask clarifying questions to understand the trigger, steps, and expected output
2. Create a skill file using `templates/skill.md` at `skills/{workflow-slug}.md`
3. Fill in the trigger, steps, inputs, and output format based on the conversation

If the user says "none" or "later", skip — skills can be added anytime.

### Step 5: Create profile.md

1. Copy `templates/profile.md` to the root
2. Replace all `{{placeholder}}` tokens with collected values
3. Fill in body sections with optional context
4. Add tool integrations under `## Tools`

### Step 6: Scaffold Directories

Ensure all required directories exist with `.gitkeep` files:

```
daily-tasks/.gitkeep
projects/working-on/.gitkeep
projects/finished/.gitkeep
skills/.gitkeep
personal-workflows/mr-reviews/.gitkeep
personal-workflows/interactions/.gitkeep
people/.gitkeep
```

### Step 7: Confirm & Next Steps

> "You're all set! Here's what I created:"
> - `profile.md` — your config and tools
> - Directory structure — ready for content
> - Skills: {list created skill files, or "none yet"}
>
> "Try these:"
> - "Log my tasks for today"
> - "Start a new project called ..."
> - "Init my sprint"
> - "Record a 1:1 with ..."
