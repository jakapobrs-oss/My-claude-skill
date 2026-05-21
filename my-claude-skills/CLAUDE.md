Skills are organized into bucket folders under `skills/`:

- `engineering/` — daily code work
- `productivity/` — daily non-code workflow tools
- `personal/` — tied to my own setup, not promoted
- `in-progress/` — drafts not yet ready to ship
- `deprecated/` — no longer used

Every skill in `engineering/` or `productivity/` must have a reference in the top-level `README.md` and an entry in `.claude-plugin/plugin.json`. Skills in `personal/`, `in-progress/`, and `deprecated/` must not appear in either.

Each skill entry in the top-level `README.md` must link the skill name to its `SKILL.md`.

Each bucket folder has a `README.md` that lists every skill in the bucket with a one-line description, with the skill name linked to its `SKILL.md`.

When adding a new skill, always update all three in the same commit:
1. `README.md` (top-level)
2. `skills/<bucket>/README.md`
3. `.claude-plugin/plugin.json`
