# Decision Log

**Date:** 2026-07-24
**Owner:** Repository owner (session user)
**Source system:** Local repository — decisions made via a `grill-me` interrogation session (one question at a time, each with a recommended answer)

## Status
Available

Every decision below was made explicitly by the task owner, via AskUserQuestion, during a `grill-me` session that preceded the actual edits. See `raw-extracts/v5-json-field-diff.md` and `raw-extracts/csv-diff.patch` for the resulting evidence.

| # | Decision | Chosen answer | Supporting evidence |
|---|---|---|---|
| 1 | Direction of the update | HTML/CSV should reflect the current skill files, not the reverse | `task-brief.md` |
| 2 | Scope | Limit to `start` (changed today) + adding `grill-me` — no full 15/16-skill re-audit | `raw-extracts/v5-json-field-diff.md` (only rows 001/015 touched) |
| 3 | Refresh `start`'s frozen Files entry? | Yes — `fileContent`/`guideContent` refreshed to match the real, changed `SKILL.md`, breaking from the prior freeze policy for this one row | `raw-extracts/v5-json-field-diff.md`; `validation-results.md` (byte-identical check) |
| 4 | Give `grill-me` a full Files entry? | Yes — filename, guideFilename, guideContent, fileContent, matching the `skill-finder` precedent | `raw-extracts/v5-json-field-diff.md` |
| 5 | `grill-me`'s workflow group | "Planning & Building Skills" (with skill-builder, first-task-mapper, skill-finder) | `raw-extracts/v5-direct-edits.diff` (skillGroups mapping) |
| 6 | `grill-me`'s sort placement | Normal A–Z task-skill sort, not pinned into the Start/New Joinee/Skill Builder trio | `raw-extracts/v5-json-field-diff.md` (row position between first-task-mapper and markdown-document-formatter) |
| 7 | How to physically edit the file | One-off Node script in the scratchpad, discarded after — not hand-edited (too large/risky), not committed as a permanent build tool | `queries.md`; `raw-extracts/update_v5.js` |
| 8 | CSV handling, once found to already be stale independent of this task | Update only row 001 + add row 015; leave other pre-existing stale rows (002, 003, etc.) untouched and flagged rather than fixed | `assumptions-and-limitations.md`; `raw-extracts/csv-diff.patch` |
| 9 | Final go-ahead | "Proceed with the plan exactly as summarized. Keep everything local—do not push to the hub." | `final-output.md` (no hub push performed) |

## Note on this evidence pack itself

One additional decision was made in the course of *building this evidence pack*: which of this session's several completed tasks it should document. The user was asked directly and chose "Skill-catalog v5.html/CSV update" over the earlier "start skill refresh + grill-me creation" work, since the v5 update had the richer, more traceable evidence trail across all 10 components.
