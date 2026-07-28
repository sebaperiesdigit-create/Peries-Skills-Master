# Daily Work Tracker — Policy Reference

Detailed rules supporting [SKILL.md](../SKILL.md). Read this before setup, saving, editing, skipping, or identity administration.

## Path conventions

| Artifact | Path | Committed to git? |
|---|---|---|
| Employee config | `output/daily-work-tracker/_config/employee.json` | Yes |
| Daily entry | `output/daily-work-tracker/<employee-id>/<year>/<YYYY-MM-DD>.md` | Yes |
| Admin audit log | `output/daily-work-tracker/_admin-audit-log.md` | Yes |
| Completion marker | `%LOCALAPPDATA%\daily-work-tracker\markers\<employee-id>\<YYYY-MM-DD>.done` | No — machine-local runtime state only |

Do not invent alternate paths. Do not move entries or config to `%LOCALAPPDATA%` — only markers belong there. Do not put markers in the repo.

## Employee config schema

See [../assets/employee-config.example.json](../assets/employee-config.example.json). Fields:

- `employeeName` (string) — official name, entered and confirmed during setup or corrected via `admin-update-identity`.
- `employeeId` (string) — official ID, same rule.
- `createdAt` (ISO 8601 timestamp) — set once at first-time setup, never changed afterward.

## Identity rules

- Identity is company-controlled data. Ordinary `create`/`view`/`edit`/`status` actions must never change `employeeName` or `employeeId`.
- Never substitute the Windows OS username for the employee identity, even as a fallback or suggestion.
- Only `admin-update-identity` may change `employeeName` or `employeeId`, and only after the confirmation and audit steps in SKILL.md.
- `admin-update-identity` is a self-attestation control. It requires a named acting administrator and a stated reason, and it logs both — it does not and cannot cryptographically verify that the person is actually authorized. If asked whether this is a real security control, say plainly that it is not.

## Save and verification sequence

For any entry write (new entry, continuation, or edit):

1. Show the complete proposed content to the employee.
2. Get explicit confirmation to save (a plain "yes"/"save it", not an assumed continuation).
3. Write the file.
4. Read the file back and confirm the content that was shown matches what was written.
5. Only after step 4 succeeds, call `scripts/check-completion.ps1 -MarkComplete`.

If any step from 2–4 fails or the employee cancels, stop. Do not create or refresh the marker. Report exactly what failed.

## Editing rules

- Edits append to the entry's `## Edit History` section; they never delete or rewrite the original "Completed Work" / "Work In Progress" / "Blockers" content that was previously saved. If content changes, add a new dated bullet describing the change instead of altering prior text in place.
- The original `Created` timestamp in the entry header is never modified by an edit.
- After a verified edit, refresh the completion marker for that date so it stays valid.

## Skip-status (leave/holiday) rules

- Weekends (Saturday, Sunday) are never tracked — no entry, no marker, no skip record, no question asked.
- For a weekday with no entry, ask once whether it was leave/holiday. If yes, write a short skip-status note in place of a full entry (date, employee ID, reason, timestamp) and do not create a completion marker for that date. If no, report the date as genuinely missing — do not fabricate a placeholder entry.
- There is no automatic holiday calendar. Every skip is a one-time employee declaration at the moment it is noticed, not a recurring rule.

## Admin audit log format

Append-only Markdown file. Each correction adds one dated section:

```
## 2026-07-28T14:32:00+00:00
- Administrator: <name/role as stated>
- Reason: <reason as stated>
- Previous: <name> (<id>)
- New: <name> (<id>)
```

Never delete or edit prior audit entries. Never rewrite historical daily entry files to reflect a corrected identity — they keep whatever name/ID was current when they were written.

## What this skill must never do

- Never delete a daily entry file, under any action.
- Never write a file without first showing its exact content and getting explicit confirmation.
- Never let a non-admin action change employee name or ID.
- Never treat a completion marker as authoritative over the entry file — if they disagree, the entry file wins and the marker should be refreshed or removed.
- Never build, reference, or invoke the deferred reminder/notification scripts (see SKILL.md "Deferred" section) — they are intentionally not implemented in this version.
