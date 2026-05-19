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

If `profile.md` already exists and has no unresolved `{{...}}` tokens, this is a **partial re-run**:

1. Check `profile.md` — if front-matter has `company`, `team`, `role` filled → skip Step 1
2. Check if the agent's own bridge already exists → if yes, setup is complete; ask if they want to update anything

If the profile exists but no bridge exists for the current agent, jump directly to Step 4 (create bridge).

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

### Step 1: Welcome & Collect Basics

Present a single prompt:

> "This is a personal knowledge base that grows as you work. I'll remember your projects, workflows, reviews, and context across sessions so you don't have to repeat yourself."
>
> "To get started, tell me a bit about yourself — your company, team, role, and anything else you'd like me to know. Everything else fills in naturally as we work together."

Wait for the user's response, then parse it into `profile.md`. Accept natural language — the user doesn't need to structure anything. Extract whatever they provide (role, repos, people, tools, conventions) and put it in the right sections.

If something is ambiguous, ask **one** clarifying follow-up at most. Don't prompt for things they didn't mention — those will come up organically in future sessions.

### Step 1b: MCP Server Discovery & Setup

After collecting profile info, check what MCP servers are already available to the agent. Use the agent's own tool list to determine which integrations are currently connected.

> "Let me check what tools I already have access to..."

Inspect available tools and report:

> "I currently have access to: {list connected MCP servers, e.g., mcp-atlassian, glean, google-workspace, notion}."
>
> "Based on your role, these additional integrations would be useful:"
> {list relevant suggestions not yet connected — e.g., if they mentioned GitLab repos but no gitlab MCP, suggest it}
>
> "Want me to help set any of these up?"

**If the user wants to set up an MCP server:**

1. Ask for the required credentials (API token, base URL, etc.) or environment variable names if they prefer to use env vars
2. Write the MCP server entry into the agent's config file (the agent knows its own config location)
3. Verify the connection works by attempting a simple call (e.g., list projects for Jira, search for the user's name in Glean)

**If the user says "I don't have the token yet":**
- Add to `.onboarding-pending.md`: `- [ ] Set up {tool} MCP server (needs credentials)`
- Tell them: "Just say 'continue setup' when you have it."

Record all configured tools under `## Tools` in `profile.md` with their MCP server name and key config values (project keys, board IDs, custom field IDs, etc.).

### Step 2: Create profile.md

1. Copy `templates/profile.md` to the root
2. Replace all `{{placeholder}}` tokens with collected values
3. Fill in body sections with collected context
4. Add tool integrations under `## Tools`
5. Add company knowledge under `## Company Knowledge`

### Step 3: Scaffold Directories

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

### Step 4: Create Agent Bridge

1. Run `./scripts/generate-bridges.sh` to update the `## Skill Index` in `AGENTS.md`.
2. Create a bridge skill/instruction in the agent's own skill directory that points back to this KB root. The bridge should instruct the agent to read `profile.md` and `AGENTS.md` on every session start, include the skill index, and list key paths (daily tasks, projects, people). The agent knows where its own skills live — create the file there.

### Step 5: Confirm & Next Steps

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
