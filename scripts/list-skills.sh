#!/usr/bin/env bash
# list-skills.sh — list every SKILL.md in the repo

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

find "$REPO_DIR/skills" -name "SKILL.md" | sort | while read -r f; do
  echo "${f#"$REPO_DIR/"}"
done
