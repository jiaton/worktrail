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

## Conventions

The full convention reference (naming patterns, YAML schemas, file size limits, project lifecycle) lives in the [AGENTS.md](AGENTS.md) and is designed for agent consumption. The short version:

- **Naming**: All slugs are kebab-case. Files follow strict patterns (see AGENTS.md).
- **Front-matter**: Every content file has YAML front-matter with `title`, `date`, `tags`, `category`, `summary`. This is how the agent indexes and queries.
- **File size**: Hard limit of 200 lines (skills are exempt). The system prefers creating new files over appending.
- **Projects**: Active in `working-on/`, completed in `finished/{YYYY}/`. The `context.md` status field tracks state.

## Requirements

- An AI agent with filesystem access (Kiro, Claude Code, Cursor, etc.)
- MCP servers for integrations you want (Jira, Confluence, Glean — all optional)
