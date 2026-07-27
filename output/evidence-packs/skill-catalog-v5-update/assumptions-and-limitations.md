# Assumptions & Limitations

**Date:** 2026-07-24
**Owner:** Repository owner (session user)
**Source system:** Local repository

## Status
Available

## Assumptions

- **Direction of the update.** Interpreted "update the skills and appropriate contents with the v5.html file" as "make the HTML/CSV deliverable reflect the current skill files," not the reverse. Confirmed explicitly via the grill-me interrogation (see `decision-log.md`) rather than left as a silent assumption.
- **Default sort order is array order.** Assumed (then confirmed by reading `render()` in the page's own `<script>`) that when no `sortField` is set, rows display in the literal order they appear in the `skill-data` array — there is no separate default-sort comparator. This is why `grill-me` was spliced into a specific array position rather than just appended.
- **CSV `Files` column stays blank for new rows.** The CSV's `Files` column is blank for all 14 pre-existing rows (the real per-skill download data lives only in the HTML's `skill-files-data` block). Assumed the same convention applies to the new row 015.

## Limitations

- **No live browser verification.** All verification in this task was programmatic (JSON parsing, ID-matching, byte-identical diffing). No browser-automation tool was available in this session, so the actual rendered page — search, filter, sort, and the two new/refreshed download buttons — was not clicked through. A reviewer should still open `v5.html` directly before fully relying on it.
- **CSV staleness only partially addressed.** The CSV was discovered to already be out of sync with the HTML in rows other than 001 (e.g. rows 002/003 still carry pre-v5-rebuild caveat text). Per explicit scope decision, only row 001 was corrected and row 015 was added — this pre-existing staleness in other rows was left as-is and flagged, not fixed.
- **No hub push.** The live Postgres-backed hub page (`page_slug='skill-catalog'`) was not updated or even queried for its current state in this task — per standing project rule, pushes only happen on explicit user go-ahead, which was not given (in fact was explicitly declined: "Keep everything local—do not push to the hub").
- **Single-session evidence pack, no version control diff available.** Several of the files touched (`v5.html`, the CSV) are untracked or newly-staged in git from a broader ongoing restructure, so a `git diff` against a committed baseline would not isolate this task's changes. Raw evidence in this pack instead comes from before/after backups taken immediately before the patch scripts ran (`raw-extracts/`), not from git history.
