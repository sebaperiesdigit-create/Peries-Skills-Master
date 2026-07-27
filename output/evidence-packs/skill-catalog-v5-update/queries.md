# Queries / Scripts

**Date:** 2026-07-24
**Owner:** Repository owner (session user)
**Source system:** Local repository, Node.js (v26.5.0), Bash/Git Bash

## Status
Available

## Scripts written and run

Both scripts were one-off, scratchpad-only (per explicit decision in `decision-log.md`) — not committed to the repository. Their exact source is preserved here as raw evidence.

1. **`raw-extracts/update_v5.js`** — parses `skill-documentation-table-v5.html`, extracts the two embedded JSON `<script>` blocks (`skill-data`, `skill-files-data`), programmatically patches them (refresh row 001, insert row 015 at the correct alphabetical position), and rewrites the file.
2. **`raw-extracts/update_csv.js`** — a hand-written RFC4180 CSV parser/serializer (no external dependency available) that reads `Skills_documentation_table -Final.csv`, replaces row 001 and appends row 015 using the now-current HTML values, and rewrites the CSV.

## Inline diagnostic commands run (not saved as separate files)

- `Grep` for `grill|interrogat|stress-test` across `.claude/skills/` — confirmed no pre-existing duplicate skill before building `grill-me` (from the earlier part of the session)
- Multiple `Read` calls with `offset`/`limit` on `skill-documentation-table-v5.html` — the file's two JSON blocks are single lines of ~40,000 tokens each, too large to read whole
- `Grep` for JS identifiers (`stat-total`, `skillGroups`, `dataColumns`, `sortableCols`, `render()`) — used to understand the page's rendering/sorting logic before deciding where to insert the new row and which stats needed manual edits
- Several inline `node -e "..."` one-liners — inspected the schema of `filesData['014']` (skill-finder) as a template, checked line-ending conventions (CRLF vs LF) in existing entries vs. the real files on disk, and ran the verification checks recorded in `validation-results.md`

## Direct file edits (not scripted — via the Edit tool)

- `skill-documentation-table-v5.html`: stat counts, footer date, `skillGroups` mapping (see `raw-extracts/v5-direct-edits.diff` for exact before/after text)
- `skill-documentation-review-notes.md`: appended §28 documenting this task
