# Personal Knowledge Base

An AI-native knowledge base for engineers. You talk to your AI agent in natural language — it handles all file operations, querying, and cross-referencing using markdown files and YAML front-matter.

![Project Overview](poster.png)

## Why

- **Never lose context.** Projects, interactions, reviews, and daily work are structured and searchable. Come back from vacation and ramp up in minutes.
- **Jira integration.** The agent initializes sprints, creates tickets with your team's custom fields, and maps them to your active projects — all from a single command. *(Requires Jira MCP server.)*
- **Glean search + local cache.** When the agent learns durable facts from Glean (org structure, team mappings, processes), it caches them locally so future sessions don't need to re-search. *(Requires Glean MCP server.)*
- **Reusable skills.** Turn any workflow into a skill file (like Claude's custom instructions). Sprint init, convention audits, machine migration — define once, run anytime.
- **Progressive disclosure.** Small, focused files with YAML front-matter. The agent reads `profile.md` on startup, then navigates to specific files on demand — no loading your entire history into context.
- **Multi-session continuity.** MR reviews, multi-day projects, recurring 1:1s — pick up exactly where you left off because the history lives in files, not chat context.

## What's Automated vs. What Needs You

| Capability | How it works |
|---|---|
| **Log daily tasks** | Tell the agent what you did → it creates/updates today's file |
| **Track projects** | Say "start project X" or describe progress → agent manages project files |
| **Sprint init** | Say "init sprint" → agent pulls your Jira tickets, maps them to projects, creates daily task file |
| **Create Jira tickets** | Describe the ticket → agent creates it with correct project, squad, and custom fields |
| **Record interactions** | Describe a 1:1 or meeting → agent creates an interaction summary |
| **MR reviews** | Tell the agent about a review → it tracks feedback, outcome, and history across sessions |
| **Search Glean** | Ask a question → agent searches Glean and caches durable facts locally |
| **Convention audit** | Say "audit my KB" → agent checks structure, naming, front-matter, and file sizes |
| **Propagation** | When daily tasks mention project work, the agent auto-creates project update files |

Everything above is triggered by natural language. The agent decides which files to create, where to put them, and how to cross-reference — you just talk.

**You handle:** Deciding what's worth recording. The agent doesn't watch your IDE or Slack — you tell it what happened, and it structures the rest.

## Structure

```
├── profile.md                              # your config, role, goals, tool mappings
├── AGENTS.md                               # agent behavior rules
├── templates/                              # file templates (10 types)
├── daily-tasks/{YYYY}/{MM}/{YYYY-MM-DD}.md # daily logs
├── projects/
│   ├── working-on/{slug}/                  # active projects
│   │   ├── context.md                      #   scope, stakeholders, timeline
│   │   └── {YYYY-MM-DD}.md                 #   daily updates
│   └── finished/{YYYY}/{slug}/             # archived projects
├── scripts/                                # internal tooling (generate-bridges.sh)
├── skills/                                 # reusable agent workflows
├── personal-workflows/
│   ├── mr-reviews/                         # code review records
│   ├── interactions/                       # 1:1s, meetings, conversations
│   └── performance-review/                 # self-assessments, gap analyses
└── people/                                 # notes on people you work with
```

## Setup

1. Clone this repo.
2. Tell your AI agent: **"Set up my knowledge base."**
3. Answer a few questions (company, team, role).
4. Start talking — "log my tasks today", "start a new project", "init my sprint".

For **Kiro CLI** users, the setup also creates `~/.kiro/skills/worktrail/SKILL.md` — a bridge skill that auto-loads your KB context every session, regardless of working directory. **Claude Code**, **Cursor**, and other agents read `AGENTS.md` directly (it contains the skill index).

**Claude Code:** `CLAUDE.md` is a symlink to `AGENTS.md` (Claude reads `CLAUDE.md` by default).

**Bridge auto-update:** Whenever you add or remove a skill in `skills/`, the agent automatically regenerates the bridge's skill index. No manual "update agent bridges" command needed — the agent detects the change and syncs.

**Path detection:** The bridge is generated using the actual KB root path (detected at runtime), not a hardcoded location. Clone the repo anywhere and setup will resolve paths correctly.

## Conventions

The full convention reference (naming patterns, YAML schemas, file size limits, project lifecycle) lives in the [AGENTS.md](AGENTS.md) and is designed for agent consumption. The short version:

- **Naming**: All slugs are kebab-case. Files follow strict patterns (see AGENTS.md).
- **Front-matter**: Every content file has YAML front-matter with `title`, `date`, `tags`, `category`, `summary`. This is how the agent indexes and queries.
- **File size**: Hard limit of 200 lines (skills are exempt). The system prefers creating new files over appending.
- **Projects**: Active in `working-on/`, completed in `finished/{YYYY}/`. The `context.md` status field tracks state.

## Requirements

- An AI agent with filesystem access (Kiro, Claude Code, Cursor, etc.)
- MCP servers for integrations you want (Jira, Confluence, Glean — all optional)

# WorkTrail

![Project Overview](poster.png)

Stop re-explaining your work to your AI agent.

WorkTrail is an AI-readable work memory scaffold for engineers. You keep typing naturally to Claude Code, Cursor, Kiro, or any filesystem-aware agent. WorkTrail gives the agent a structured Markdown map of your projects, workflows, reviews, people, tools, test environments, and long-running context.

It is not another app, dashboard, database, daemon, or background watcher. It is a lightweight file structure and set of conventions that helps your agent know where to look, where to write, and how your work fits together.

## What WorkTrail Feels Like

A normal interaction can look like this:

> You: Help me implement ticket `ABC-123`.

> Agent: I checked your `profile.md` and project context. Your frontend repo is in `~/work/frontend`, your backend/orchestrator repo is in `~/work/orchestrator`, and this ticket maps to the current payment onboarding project. I'll inspect the related code, previous branches, and MR history first.

> Agent: I found the relevant flow, reviewed your past MR patterns, and confirmed the logic path. I'm going to implement the backend change, update the frontend behavior, and run the usual checks.

> Agent: The implementation is done. I created a draft MR following your team's conventions. The preview image has been deployed to the cloud environment. Once it is ready, you can open the URL and test it directly.

The point is not that WorkTrail writes code by itself. The point is that your agent no longer starts from zero every session.

It knows where your work lives, how your team works, what you were doing yesterday, which branches and MRs mattered, what changed in a teammate's MR two days ago, which test account to use, which environment is safe to test in, and what evidence belongs in your performance review.

WorkTrail does not replace your workflow. It makes your existing AI agent remember it.

## Why

Most engineers spend a surprising amount of time re-explaining context to AI agents:

- where the frontend, backend, orchestrator, and support repos are
- which project a ticket belongs to
- what the current sprint priorities are
- which test account or test environment to use
- what happened in yesterday's meeting
- what changed in a teammate's MR
- what your manager or reviewer said in a 1:1
- what evidence belongs in your performance review
- how your team prefers tickets, branches, MRs, test plans, and deployments to be handled

WorkTrail turns that repeated copy-paste into durable Markdown memory.

If you often paste the same project context, repo paths, Jira links, review notes, commands, testing steps, credentials, environment URLs, or team conventions into your agent, WorkTrail gives those details a permanent home.

Key benefits:

- Never lose context. Projects, interactions, reviews, and daily work are structured and searchable. Come back from vacation and ramp up in minutes.
- Progressive disclosure. Small, focused files with YAML front-matter. The agent reads `profile.md` on startup, then navigates to specific files on demand — no loading your entire history into context.
- Multi-session continuity. MR reviews, multi-day projects, recurring 1:1s, and long-running tickets can continue across sessions because the history lives in files, not chat context.
- Reusable skills. Turn any workflow into a skill file, similar to Claude custom instructions. Sprint init, MR review summaries, convention audits, machine migration, environment setup, release checks — define once, run anytime.
- Works with whatever your agent can reach. GitLab, Jira, Glean, Google Workspace, Confluence, browser tools, MCP servers, local repos, and internal docs can all become part of the workflow when your agent has access.
- Local and portable by default. Your work memory is Markdown files in your repo or local folder. You own it, move it, sync it, and back it up however you want.

## The Flow

```text
You type normally
        ↓
Your AI agent reads profile.md and AGENTS.md
        ↓
It finds the right project, workflow, people, tickets, reviews, and context files
        ↓
It works through your existing tools and conventions
        ↓
It writes durable updates back to Markdown
        ↓
Next session starts with memory instead of a blank slate
```

WorkTrail is intentionally low-friction. You do not need to open a new product, maintain a dashboard, or manually organize every note. You keep working in chat. The agent handles the structure.

## What's Automated vs. What Needs You

| Capability | How it works |
|---|---|
| Log daily tasks | Tell the agent what you did → it creates or updates today's file |
| Track projects | Say "start project X" or describe progress → agent manages project files |
| Preserve project context | The agent links tickets, decisions, branches, MRs, meetings, and daily updates to the right project |
| Record interactions | Describe a 1:1, meeting, or conversation → agent creates an interaction summary |
| MR reviews | Tell the agent about a review → it tracks feedback, outcome, and history across sessions |
| Performance review | Ask the agent to summarize impact → it gathers project evidence, feedback, reviews, and growth areas |
| Test accounts and environments | Store accounts, URLs, setup notes, reset steps, and caveats so the agent can reuse them later |
| Sprint init | Say "init sprint" → agent can pull your Jira tickets, map them to active projects, and create a daily task file |
| Create Jira tickets | Describe the ticket → agent can create it with the correct project, squad, and custom fields |
| Search Glean | Ask a question → agent can search Glean and cache durable facts locally |
| Convention audit | Say "audit my KB" → agent checks structure, naming, front-matter, and file sizes |
| Propagation | When daily tasks mention project work, the agent can create or update the relevant project files |

Everything above is triggered by natural language. The agent decides which files to create, where to put them, and how to cross-reference them.

You handle the judgment. The agent does not watch your IDE, Slack, browser, or calendar by default. You decide what is worth recording, then the agent structures it.

## What It Can Remember

WorkTrail is useful for anything you repeatedly explain to an AI agent:

- active projects, status, scope, stakeholders, deadlines, and risks
- repo paths, service ownership, frontend/backend/orchestrator mappings
- tickets, branches, MRs, review comments, and deployment notes
- test accounts, test environments, URLs, credentials handling notes, reset steps, and known caveats
- team conventions around Jira, GitLab, MR descriptions, testing, rollout, and screenshots
- meeting notes, 1:1s, decisions, follow-ups, and discussion rationale
- performance-review evidence, impact summaries, feedback, gaps, and growth plans
- personal workflows that can become reusable skills

If you normally copy-paste it into Claude, Cursor, or Kiro more than once, it probably belongs in WorkTrail.

## Structure

```text
├── profile.md                              # your config, role, goals, tool mappings
├── AGENTS.md                               # agent behavior rules
├── templates/                              # file templates (10 types)
├── daily-tasks/{YYYY}/{MM}/{YYYY-MM-DD}.md # daily logs
├── projects/
│   ├── working-on/{slug}/                  # active projects
│   │   ├── context.md                      #   scope, stakeholders, timeline
│   │   └── {YYYY-MM-DD}.md                 #   daily updates
│   └── finished/{YYYY}/{slug}/             # archived projects
├── scripts/                                # internal tooling (generate-bridges.sh)
├── skills/                                 # reusable agent workflows
├── personal-workflows/
│   ├── mr-reviews/                         # code review records
│   ├── interactions/                       # 1:1s, meetings, conversations
│   └── performance-review/                 # self-assessments, gap analyses
└── people/                                 # notes on people you work with
```

## Setup

1. Clone this repo.
2. Tell your AI agent: "Set up my knowledge base."
3. Answer a few questions, such as company, team, role, repos, tools, and workflows.
4. Start typing naturally:
   - "log my tasks today"
   - "start a new project"
   - "init my sprint"
   - "record this MR review"
   - "summarize my recent performance-review evidence"
   - "help me implement ticket ABC-123"

For Kiro CLI users, the setup also creates `~/.kiro/skills/worktrail/SKILL.md` — a bridge skill that auto-loads your KB context every session, regardless of working directory.

Claude Code, Cursor, and other agents read `AGENTS.md` directly. It contains the skill index.

Claude Code: `CLAUDE.md` is a symlink to `AGENTS.md` because Claude reads `CLAUDE.md` by default.

Bridge auto-update: whenever you add or remove a skill in `skills/`, the agent automatically regenerates the bridge's skill index. No manual "update agent bridges" command is needed — the agent detects the change and syncs.

Path detection: the bridge is generated using the actual KB root path, detected at runtime, not a hardcoded location. Clone the repo anywhere and setup will resolve paths correctly.

## Conventions

The full convention reference — naming patterns, YAML schemas, file size limits, project lifecycle, and agent behavior — lives in [AGENTS.md](AGENTS.md) and is designed for agent consumption.

The short version:

- Naming: all slugs are kebab-case. Files follow strict patterns. See `AGENTS.md`.
- Front-matter: every content file has YAML front-matter with `title`, `date`, `tags`, `category`, and `summary`. This is how the agent indexes and queries.
- File size: content files have a hard limit of 200 lines. Skills are exempt. The system prefers creating focused new files over appending forever.
- Projects: active projects live in `working-on/`; completed projects move to `finished/{YYYY}/`. The `context.md` status field tracks state.
- Skills: reusable workflows live in `skills/` so the agent can repeat your preferred way of doing work.

## Requirements

- An AI agent with filesystem access, such as Kiro, Claude Code, Cursor, or a similar local agent
- MCP servers for integrations you want, such as Jira, Confluence, or Glean — all optional

## Design Philosophy

WorkTrail stays small on purpose.

It does not try to become your source of truth for everything. It gives your AI agent a reliable map of the things that matter often enough to be reused.

No dashboard. No lock-in. No database. No background surveillance.

Just structured Markdown that helps your agent remember your work.