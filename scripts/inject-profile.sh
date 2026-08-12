#!/bin/bash
KB="$HOME/Documents/worktrail"

# Active projects with context paths
project_lines=""
for dir in "$KB/projects/working-on"/*/; do
  slug=$(basename "$dir")
  [ "$slug" = ".gitkeep" ] && continue
  project_lines="${project_lines}  - ${slug}: ${dir}context.md\n"
done

# People (slugs, strip .md)
people=$(ls "$KB/people/" 2>/dev/null | grep -v '\.gitkeep' | sed 's/\.md$//' | awk '{printf "%s%s", sep, $0; sep=", "} END{print ""}')

profile_body=$(cat "$KB/profile.md" 2>/dev/null)

# Decision Flow section from AGENTS.md (Primary actions + Cascade rules) —
# kept inline so triggers apply from any cwd, not just when working inside the KB
decision_flow=$(awk '/^## Decision Flow/{f=1} f{print} /^## File Creation Checklist/{exit}' "$KB/AGENTS.md" 2>/dev/null | sed '$d')

# Architecture section (what each directory holds) + Search Strategy line —
# so the agent knows what's recorded in the KB even before reading any file
architecture=$(awk '/^## Architecture/{f=1} f{print} /^## Decision Flow/{exit}' "$KB/AGENTS.md" 2>/dev/null | sed '$d')
search_strategy=$(awk '/^\*\*Search strategy:\*\*/{print; exit}' "$KB/AGENTS.md" 2>/dev/null)

summary="# WorkTrail KB: $KB
Active projects (read context.md for scope, status, decisions):
$(printf '%b' "$project_lines")
People notes: ${people:-none} — read $KB/people/{slug}.md for details

## profile.md
$profile_body

$architecture

$search_strategy

$decision_flow"

printf '%s' "$summary" | jq -Rs '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: ("WorkTrail context:\n" + .)}}'
