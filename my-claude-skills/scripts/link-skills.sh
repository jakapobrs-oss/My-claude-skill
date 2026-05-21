#!/usr/bin/env bash
# link-skills.sh — symlink every shippable skill into ~/.claude/skills/

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$HOME/.claude/skills/my-claude-skills"

mkdir -p "$TARGET_DIR"

for skill_dir in "$REPO_DIR"/skills/engineering/*/; do
  skill_name="$(basename "$skill_dir")"
  ln -sfn "$skill_dir" "$TARGET_DIR/$skill_name"
  echo "linked: $skill_name"
done

for skill_dir in "$REPO_DIR"/skills/productivity/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name="$(basename "$skill_dir")"
  ln -sfn "$skill_dir" "$TARGET_DIR/$skill_name"
  echo "linked: $skill_name"
done

echo "done — skills linked to $TARGET_DIR"
