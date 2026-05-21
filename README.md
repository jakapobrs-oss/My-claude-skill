# my-claude-skills

Agent skills loaded by Claude Code.

## Layout

Skills live under `skills/`, grouped into buckets:

- `engineering/` — daily code work
- `productivity/` — daily non-code workflow tools
- `personal/` — tied to my own setup, not promoted
- `in-progress/` — drafts not yet ready to ship
- `deprecated/` — no longer used

Each skill is its own directory containing a `SKILL.md` (with YAML frontmatter — `name` and `description`) and any bundled scripts or reference files.

## Install

Symlink every shippable skill into `~/.claude/skills/`:

```bash
./scripts/link-skills.sh
```

List every `SKILL.md` in the repo:

```bash
./scripts/list-skills.sh
```

## Reference

### Engineering

- **[code-blueprint](./skills/engineering/code-blueprint/SKILL.md)** — Design-first coding discipline: clarify requirements, evaluate alternatives, draw the interface before implementation, and map dependencies and side effects. Works for small features and new modules alike. Refuses to write implementation before the blueprint is confirmed.

### Productivity

_(none yet)_
