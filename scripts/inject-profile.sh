#!/bin/bash
KB="$HOME/Documents/worktrail"

# Identity from profile.md frontmatter
company=$(awk '/^---$/{f++} f==1 && /^company:/{gsub(/^company: *"|"$/,""); sub(/^company: */,""); print; exit}' "$KB/profile.md" 2>/dev/null)
team=$(awk '/^---$/{f++} f==1 && /^team:/{gsub(/^team: *"|"$/,""); sub(/^team: */,""); print; exit}' "$KB/profile.md" 2>/dev/null)
role=$(awk '/^---$/{f++} f==1 && /^role:/{gsub(/^role: *"|"$/,""); sub(/^role: */,""); print; exit}' "$KB/profile.md" 2>/dev/null)

# Active projects with context paths
project_lines=""
for dir in "$KB/projects/working-on"/*/; do
  slug=$(basename "$dir")
  [ "$slug" = ".gitkeep" ] && continue
  project_lines="${project_lines}  - ${slug}: ${dir}context.md\n"
done

# People (slugs, strip .md)
people=$(ls "$KB/people/" 2>/dev/null | grep -v '\.gitkeep' | sed 's/\.md$//' | awk '{printf "%s%s", sep, $0; sep=", "} END{print ""}')

summary="# WorkTrail KB: $KB
Who: $role at $company ($team)
Active projects (read context.md for scope, status, decisions):
$(printf '%b' "$project_lines")
People notes: ${people:-none} — read $KB/people/{slug}.md for details
Skills: read $KB/skills/{name}/SKILL.md when trigger matches"

printf '%s' "$summary" | jq -Rs '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: ("WorkTrail context:\n" + .)}}'
