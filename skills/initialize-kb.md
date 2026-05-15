---
title: "Initialize Knowledge Base"
date: "2026-05-15"
tags: ["workflow", "agent", "setup"]
category: "skills"
summary: "Interactive setup flow for new knowledge base users with deferred setup support"
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
- `.onboarding-pending.md` exists (resume deferred setup)

## Re-entry

If `profile.md` already exists and has no unresolved `{{...}}` tokens, this is a **partial re-run**. Skip steps the user has already completed:

1. Check `profile.md` — if front-matter has `company`, `team`, `role` filled → skip Step 2
2. Check `profile.md` `## Company Knowledge` — if filled → skip Step 3
3. Check `profile.md` `## Tools` — if tools already listed → ask "Want to add more tools, or skip?"
4. Check `skills/` — if skill files exist → ask "Want to add more workflows, or skip?"

Jump directly to the first incomplete step.

## Deferred Setup

Users can defer any step by saying "later", "skip for now", or "I don't have the token yet".

When anything is deferred:
1. Create `.onboarding-pending.md` at the KB root (if it doesn't exist)
2. Record what's pending with a checklist

When the agent detects `.onboarding-pending.md` on startup, it should ask:
> "You have pending onboarding items. Want to continue setup?"

When all items are complete, **delete `.onboarding-pending.md`**.

### `.onboarding-pending.md` format

```markdown
---
title: "Onboarding Pending"
created: YYYY-MM-DD
---

## Pending Items

- [ ] Set up Jira MCP server (needs API token)
- [ ] Set up Glean MCP server (needs API key)
- [ ] Add sprint cadence to Company Knowledge
- [ ] Define sprint init skill
```

## Prerequisites

Before starting, verify:
1. `README.md` exists at the root (conventions reference)
2. `templates/` directory exists with all 10 templates
3. `templates/profile.md` exists (template source)

If any are missing, inform the user and stop.

## Steps

### Step 1: Welcome & Explain

> "This is a convention-driven personal knowledge base. I'll ask you a few questions to set up your profile and workflows, then you're ready to go. You can defer anything you're not ready for — I'll track it and remind you later."

### Step 2: Collect Profile Info

Ask **one at a time**, waiting for each answer:

1. **Company** — "What company do you work at?"
2. **Team** — "What team are you on?"
3. **Role** — "What's your current role/title?"
4. **Background** (optional) — "Any brief background? (teams, domains, experience)"
5. **Current goals** (optional) — "Any goals you're working toward?"
6. **Notable work** (optional) — "Any highlights worth noting?"

If the user says "skip" to any optional question, use the placeholder text from the template.

### Step 3: Collect Company Knowledge

Ask: "Let me learn some basics about your company so I don't have to look them up every session. You can answer directly, paste info, or if you've set up Glean I can search for these automatically."

**If Glean MCP is configured (listed in `## Tools`):**
> "I see you have Glean set up. Want me to search for company knowledge (fiscal year, sprint cadence, org chart, etc.) automatically? I'll confirm what I find before saving."

If yes: search Glean for each item, present findings, let user confirm/correct, then save to `profile.md` § Company Knowledge.

**If Glean is not configured, or user prefers manual:**

Ask one at a time:

1. **Fiscal year** — "When does your fiscal year start?"
2. **Quarters** — "How are quarters structured?"
3. **Sprint cadence** — "How long are your sprints? What day do they start?"
4. **Release process** — "Any regular deploy days or freeze schedules?"
5. **Org chart** — "Who's your manager? What's your reporting chain up to director/VP?"

For any the user doesn't know, add to `.onboarding-pending.md` and note: "If you set up Glean later, I can search for these automatically."

Fill answers into `profile.md` § Company Knowledge.

### Step 4: Collect Tool Integrations

Present recommended MCP servers:

> "Here are MCP servers that unlock the most value with this KB:"
>
> | MCP Server | What it enables |
> |---|---|
> | **mcp-atlassian** | Sprint init, ticket creation, Confluence wiki search |
> | **glean** | Company knowledge search + local caching |
> | **notion** | Daily task sync to Notion |
> | **google-workspace** | Calendar, docs, email integration |
> | **playwright** / **chrome-devtools** | Browser automation |
> | **gitlab** / **github** | Code review tracking, MR/PR management |
>
> "Which of these do you use or want to set up? You can also add others not on this list."

For each tool the user wants:
- Ask for the MCP server name (suggest from table if applicable)
- Ask for key config values (e.g., Jira project key, board ID, custom fields)
- Record under `## Tools` in `profile.md`

**If the user says "I want X but don't have the token/credentials yet":**
- Add the tool to `profile.md` § Tools with a `# TODO: needs token` comment
- Add to `.onboarding-pending.md`: `- [ ] Set up {tool} MCP server (needs credentials)`
- Tell the user: "I've noted it. When you have the credentials, just say 'continue setup' and I'll help you finish."

If the user says "none" or "later" for all tools, skip — tools can be added anytime.

### Step 5: Collect Workflows for Skills

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

### Step 6: Create profile.md

1. Copy `templates/profile.md` to the root
2. Replace all `{{placeholder}}` tokens with collected values
3. Fill in body sections with collected context
4. Add tool integrations under `## Tools`
5. Add company knowledge under `## Company Knowledge`

### Step 7: Scaffold Directories

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

### Step 8: Create Agent Bridge Skill

Run `./scripts/generate-bridges.sh` — this script:

1. Detects KB root from its own location (no hardcoded paths)
2. Scans `skills/*.md` → extracts `title` and `trigger` from YAML front-matter
3. Updates the `## Skill Index` section in `AGENTS.md` (between auto-generated markers)
4. If `~/.kiro/` exists, generates the Kiro bridge at `~/.kiro/skills/worktrail/SKILL.md` (needs absolute path since it lives outside the repo)

`AGENTS.md` is the universal instruction file — any agent that reads it gets the skill index. The Kiro bridge is the only external file needed (points back to the repo).

When the user adds a new skill later, the agent runs `./scripts/generate-bridges.sh` again.

### Step 9: Confirm & Next Steps

> "You're all set! Here's what I created:"
> - `profile.md` — your config and tools
> - Directory structure — ready for content
> - Skills: {list created skill files, or "none yet"}
> - Agent bridges: {list which bridges were created based on detected agents}
> {if .onboarding-pending.md exists:}
> - **Pending items** — say "continue setup" anytime to finish these:
>   {list pending items}
>
> "Try these:"
> - "Log my tasks for today"
> - "Start a new project called ..."
> - "Init my sprint"
> - "Record a 1:1 with ..."
>
> "When you add new skills, say 'update agent bridges' to regenerate the skill index."
