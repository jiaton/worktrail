# WorkTrail

![Project Overview](poster.png)

Stop re-explaining your work to your AI agent.

WorkTrail is a lightweight Markdown memory map for engineers. You keep typing naturally to Claude Code, Cursor, Kiro, or any filesystem-aware agent. WorkTrail gives the agent a structured way to remember your projects, repos, workflows, reviews, people, test environments, and long-running context.

No new app. No dashboard. No database. Just organized files your agent knows how to navigate.

## What It Feels Like

> You: Help me implement ticket `ABC-123`.

> Agent: I checked your profile and project context. Your frontend repo is in `~/work/frontend`, your backend/orchestrator repo is in `~/work/orchestrator`, and this ticket maps to the current onboarding project. I’ll inspect the related code, previous branches, and MR history first.

> Agent: The logic is clear. I implemented the change, followed your team’s MR convention, created a draft MR, and deployed a preview image. Once it is ready, you can open the URL and test it directly.

WorkTrail does not replace your workflow. It makes your existing AI agent remember it.

## Why It Matters

Engineers keep repeating the same context to AI agents:

- repo paths, service ownership, and frontend/backend/orchestrator mappings
- ticket context, branches, MRs, review feedback, and deployment notes
- test accounts, test environments, URLs, reset steps, and caveats
- meeting notes, 1:1s, decisions, and follow-ups
- performance-review evidence, impact summaries, and growth areas
- team conventions around Jira, GitLab, Glean, Google Workspace, and internal tools

WorkTrail turns that repeated copy-paste into durable Markdown memory.

If you paste the same thing into Claude, Cursor, or Kiro more than once, it probably belongs in WorkTrail.

## How It Works

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

The agent does not watch your IDE, Slack, browser, or calendar by default. You decide what is worth recording; the agent structures it.

## What It Can Do

| Capability | How it works |
|---|---|
| Daily tasks | Tell the agent what you did → it updates today’s file |
| Projects | Say “start project X” or describe progress → it manages project files |
| MR reviews | Tell the agent about a review → it tracks feedback and history across sessions |
| Performance review | Ask for impact evidence → it gathers projects, reviews, feedback, and growth areas |
| Test context | Store accounts, URLs, setup notes, reset steps, and environment caveats |
| Reusable skills | Turn repeated workflows into agent playbooks |
| Optional integrations | Use MCP servers for Jira, Confluence, Glean, or other tools your agent can reach |

## Structure

```text
├── profile.md                              # your role, goals, repos, tools, mappings
├── AGENTS.md                               # agent behavior rules
├── templates/                              # file templates
├── daily-tasks/{YYYY}/{MM}/{YYYY-MM-DD}.md # daily logs
├── projects/
│   ├── working-on/{slug}/                  # active projects
│   │   ├── context.md                      # scope, stakeholders, timeline
│   │   └── {YYYY-MM-DD}.md                 # daily updates
│   └── finished/{YYYY}/{slug}/             # archived projects
├── scripts/                                # internal tooling
├── skills/                                 # reusable agent workflows
├── personal-workflows/
│   ├── mr-reviews/                         # code review records
│   ├── interactions/                       # 1:1s, meetings, conversations
│   └── performance-review/                 # self-assessments, gap analyses
└── people/                                 # notes on people you work with
```

## Setup

1. Clone this repo.
2. Tell your AI agent: `Set up my knowledge base.`
3. Answer a few questions about your company, team, role, repos, tools, and workflows.
4. Start typing naturally:
   - `log my tasks today`
   - `start a new project`
   - `init my sprint`
   - `record this MR review`
   - `summarize my recent performance-review evidence`
   - `help me implement ticket ABC-123`

For Kiro CLI users, setup can create `~/.kiro/skills/worktrail/SKILL.md` so the KB context loads across working directories.

Claude Code, Cursor, and other agents read `AGENTS.md` directly. `CLAUDE.md` is a symlink to `AGENTS.md` because Claude Code reads `CLAUDE.md` by default.

## Conventions

The full convention reference lives in [AGENTS.md](AGENTS.md). Short version:

- Slugs use kebab-case.
- Content files use YAML front-matter with `title`, `date`, `tags`, `category`, and `summary`.
- Content files have a 200-line limit; skills are exempt.
- Active projects live in `projects/working-on/`; completed projects move to `projects/finished/{YYYY}/`.
- Skills live in `skills/` and act like reusable agent playbooks.

## Requirements

- An AI agent with filesystem access, such as Kiro, Claude Code, Cursor, or a similar local agent
- Optional MCP servers for integrations such as Jira, Confluence, or Glean