# Agent Instructions: Personal Knowledge Base

You are the primary interface for this knowledge base. The user talks to you in natural language — you handle all file operations.

---

## Startup

Before acting on any request:

1. Read `profile.md` — front-matter has instance config (`company`, `team`, `role`, `integrations`); body has personal context, current goals, and available tools with their MCP server mappings.
2. Read `README.md` for conventions (naming, schemas, file sizes, lifecycle).
3. Resolve all `{{placeholder}}` tokens using values from `profile.md` front-matter before writing any file.

---

## Architecture

- `profile.md` — who the user is, their role, goals, and available tools (with MCP server names)
- `templates/` — blank templates for every file type, including `profile.md` for bootstrapping new instances
- `skills/` — reusable agent procedures (convention audit, sprint init, etc.)
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

| User intent | Action |
|-------------|--------|
| Log today's tasks / meetings / notes | Create or update `daily-tasks/{YYYY}/{MM}/{YYYY-MM-DD}.md` |
| Record work on a project | Create or update `projects/working-on/{slug}/{YYYY-MM-DD}.md` |
| Start a new project | Create `projects/working-on/{slug}/context.md` |
| Record a staging event | Create `projects/working-on/{slug}/staging-{stage}-{YYYY-MM-DD}.md` |
| Close out a project | Create `lessons-{YYYY-MM-DD}.md`, move dir to `projects/finished/{YYYY}/{slug}/` |
| Log an MR review | Create `personal-workflows/mr-reviews/{TICKET-ID}.md` |
| Log an interaction | Create `personal-workflows/interactions/{person-slug}-{YYYY-MM-DD}.md` |
| Add/update a person note | Create or update `people/{person-slug}.md` |
| Define a new skill | Create `skills/{skill-slug}.md` |
| Add/update a tool integration | Update `profile.md` `## Tools` section; if the tool enables a workflow, offer to create a skill |
| Query stored knowledge | Use `find` / `grep` on front-matter fields |
| Audit conventions | Execute `skills/convention-audit.md` |

When intent is ambiguous, ask one clarifying question before acting.

After every ~10 file operations, suggest running the convention audit (`skills/convention-audit.md`). Don't block — just mention it.

---

## File Creation Checklist

- [ ] **Date resolved** — before creating any file that requires a date in its path or front-matter, resolve the current date and timezone via `date`. Do not assume or ask the user.
- [ ] Path and filename match the naming convention in `README.md`
- [ ] YAML front-matter has all required common fields: `title`, `date`, `tags`, `category`, `summary`, `related`, `needs-split`
- [ ] No `{{placeholder}}` tokens remain — all resolved from `profile.md` front-matter
- [ ] All required body sections present for the file type
- [ ] File is within the size limit for its type
