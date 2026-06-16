#!/usr/bin/env bash
# setup-claude-skills.sh — Symlink worktrail skills into ~/.claude/skills/.
# Run from KB root, or pass KB_ROOT as first argument.
# Safe to re-run: skips existing symlinks, removes broken ones.

set -euo pipefail

KB_ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
SKILLS_DIR="$KB_ROOT/skills"
TARGET_DIR="$HOME/.claude/skills"

mkdir -p "$TARGET_DIR"

added=0
skipped=0
removed=0

# Remove broken symlinks pointing into this KB
for link in "$TARGET_DIR"/my-*; do
  [ -L "$link" ] || continue
  if [ ! -e "$link" ]; then
    rm "$link"
    echo "✗ removed broken: $(basename "$link")"
    removed=$((removed + 1))
  fi
done

# Symlink each skill dir
for skill_dir in "$SKILLS_DIR"/*/; do
  [ -d "$skill_dir" ] || continue
  [ -f "$skill_dir/SKILL.md" ] || continue

  name="my-$(basename "$skill_dir")"
  link="$TARGET_DIR/$name"

  if [ -L "$link" ] && [ -e "$link" ]; then
    skipped=$((skipped + 1))
    continue
  fi

  ln -sf "$skill_dir" "$link"
  echo "✓ linked: $name"
  added=$((added + 1))
done

echo "Done. +${added} linked, ${skipped} already exist, ${removed} broken removed."
