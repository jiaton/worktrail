# Agent Instructions: Personal Knowledge Base

You are the primary interface for this knowledge base. The user talks to you in natural language — you handle all file operations.

---

## Startup

Before acting on any request:

1. Read `profile.md` — front-matter has instance config (`company`, `team`, `role`, `integrations`); body has personal context, current goals, and available tools with their MCP server mappings.
2. Read `README.md` for conventions (naming, schemas, file sizes, lifecycle).
3. If `.onboarding-pending.md` exists, ask: "You have pending onboarding items. Want to continue setup?" If yes, run `skills/initialize-kb/SKILL.md` in re-entry mode.
4. Resolve all `{{placeholder}}` tokens using values from `profile.md` front-matter before writing any file.

**Search rule:** Always search from the KB root (this repo) with no artificial depth limits. The repo is small — never constrain `max_depth` when looking for files or content.

**Search strategy:** Directory and file names are the primary index. When looking something up, **list the relevant directory first** (e.g., `projects/working-on/`) to match by name — the user may abbreviate or misspell. Use `grep` only for content inside files (ticket IDs, tags, terms), not for finding projects/people/files by name.

---

## Architecture

- `profile.md` — who the user is, their role, goals, and available tools (with MCP server names)
- `templates/` — blank templates for every file type, including `profile.md` for bootstrapping new instances
- `skills/` — reusable agent procedures. Each skill lives at `skills/{name}/SKILL.md`. Read the relevant one directly when its trigger matches — never invoke via `Skill()` or slash commands.
- `projects/` — active and finished project records
- `daily-tasks/` — optional daily task logs
- `personal-workflows/` — records of events (MR reviews, interaction summaries)
- `people/` — notes on people the user works with

If you make any structural change (rename directories, add new file types, change conventions), update this file and `README.md` to reflect it. This includes:
- Adding or renaming directories
- Adding new file types or personal workflow categories
- Changing the decision flow (new intents, new actions)
- Adding or removing tools in `profile.md`
- Modifying naming conventions or front-matter schemas

---

## Decision Flow

A single request often triggers multiple actions. Don't treat this as a lookup table — treat it as a cascade. After any primary action, always evaluate what else should fire.

### Primary actions

| User intent | Primary action |
|-------------|----------------|
| Log today's tasks / meetings / notes | Create or update `daily-tasks/{YYYY}/{MM}/{YYYY-MM-DD}.md` |
| Record work on a project | Create or update `projects/working-on/{slug}/{YYYY-MM-DD}.md` |
| Update project context / docs only | Update `projects/working-on/{slug}/context.md` |
| Start a new project | Create `projects/working-on/{slug}/context.md` |
| Record a staging event | Create `projects/working-on/{slug}/staging-{stage}-{YYYY-MM-DD}.md` |
| Close out a project | Create `lessons-{YYYY-MM-DD}.md`, move dir to `projects/finished/{YYYY}/{slug}/` |
| Log an MR review | Create `personal-workflows/mr-reviews/{TICKET-ID}.md` |
| Log an interaction | Create `personal-workflows/interactions/{person-slug}-{YYYY-MM-DD}.md` |
| Add/update a person note | Create or update `people/{person-slug}.md` |
| Define a new skill | Create `skills/{skill-slug}/SKILL.md` → run `./scripts/setup-claude-skills.sh` to symlink into `~/.claude/skills/my-{name}` |
| Add/update a tool integration | Update `profile.md` `## Tools` section; offer to create a skill if it enables a workflow |
| Query stored knowledge | Follow the **Search Strategy** section above |
| Audit conventions | Read `skills/convention-audit/SKILL.md` and execute |

### Cascade rules (always evaluate after primary action)

1. **Notion sync** — if work happened (tasks completed, decisions made, progress made), append to Notion (see `skills/jira/SKILL.md` § Notion Daily Tasks Sync). Skip for doc reorganization, context-only edits, or structural KB changes.

2. **Notable Work** — if work is significant (shipped something, unblocked a project, completed a major task), ask: "Is this worth adding to `profile.md` § Notable Work?" Keep entries one line.

3. **daily-tasks** — if project work was logged but no daily-tasks entry exists for today, create one summarizing the session.

4. **context.md freshness** — if project work changes the technical approach, status, or decisions, update `context.md` to reflect current state.

When intent is ambiguous, ask one clarifying question before acting.

When unsure about people's full names, roles, org structure, or company knowledge, search Glean or Confluence user search before guessing. Check `people/` files first for cached info. Use Confluence user search for account IDs when writing Confluence pages with `@` mentions.

After every ~10 file operations, suggest running the convention audit (`skills/convention-audit/SKILL.md`). Don't block — just mention it.

---

## File Creation Checklist

- [ ] **Date resolved** — before creating any file that requires a date in its path or front-matter, resolve the current date and timezone via `date`. Do not assume or ask the user.
- [ ] Path and filename match the naming convention in `README.md`
- [ ] YAML front-matter has all required common fields: `title`, `date`, `tags`, `category`, `summary`, `related`, `needs-split`
- [ ] No `{{placeholder}}` tokens remain — all resolved from `profile.md` front-matter
- [ ] All required body sections present for the file type
- [ ] File is within the size limit for its type

---

## Skills

Skills live in `skills/{name}/SKILL.md`. Read the relevant one when its trigger matches. Don't load all upfront.

| Skill | Path | Trigger |
|---|---|---|
| Convention Audit | `skills/convention-audit/SKILL.md` | User asks to audit the knowledge base, or agent detects potential violations |
| Initialize Knowledge Base | `skills/initialize-kb/SKILL.md` | User runs setup for the first time, or profile.md still contains {{placeholder}} tokens |
| Example | `skills/example/SKILL.md` | Template — copy to create a new skill |
| *(your skills)* | `skills/{name}/SKILL.md` | *(defined per-instance in profile.md § Tools)* |
