# Evidence Pack: Skill-catalog v5.html/CSV update

**Date:** 2026-07-24
**Owner:** Repository owner (session user)
**Source system(s):** Local repository — `C:\Users\LED 269\Desktop\Peries-Skills-Master`

## Index

| Component | Status | File |
|---|---|---|
| Task Brief | Available | [task-brief.md](task-brief.md) |
| Source References | Available | [sources.md](sources.md) |
| Queries/Scripts | Available | [queries.md](queries.md) |
| Raw Extracts | Available | [raw-extracts/](raw-extracts/) |
| Validation Results | Available | [validation-results.md](validation-results.md) |
| Screenshots | Not provided | [screenshots/](screenshots/) |
| Assumptions & Limitations | Available | [assumptions-and-limitations.md](assumptions-and-limitations.md) |
| Decision Log | Available | [decision-log.md](decision-log.md) |
| Final Output | Available | [final-output.md](final-output.md) |

## What this pack documents

Updating `output/skill-documentation/skill-documentation-table-v5.html` (and its source CSV) to reflect two real, same-day skill changes: a refreshed `start` skill (row 001) and a newly-created `grill-me` skill (row 015). Full narrative in [task-brief.md](task-brief.md); every decision behind *how* it was done is in [decision-log.md](decision-log.md), each tied to the evidence that resulted from it.

## Raw evidence contents

- `raw-extracts/csv-diff.patch` — unified diff of the CSV before/after
- `raw-extracts/v5-direct-edits.diff` — the small hand-made HTML edits (stat counts, footer date, group mapping) not covered by the script-generated diff
- `raw-extracts/v5-json-field-diff.md` — field-level before/after for the two touched rows in the HTML's embedded JSON
- `raw-extracts/verification-console-output.txt` — verbatim output from every verification check run
- `raw-extracts/update_v5.js`, `raw-extracts/update_csv.js` — the two one-off scripts that performed the edits (originally scratchpad-only; copied here as evidence, not left in the live repo)

## Redaction

All files in `raw-extracts/` were scanned for credential/secret/email patterns before this pack was assembled — none were found. See [validation-results.md](validation-results.md).
