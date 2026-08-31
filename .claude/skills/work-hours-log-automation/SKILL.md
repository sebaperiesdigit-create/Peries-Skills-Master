---
name: work-hours-log-automation
description: Use when someone asks to log daily attendance, record arrival and departure times, import an attendance CSV, generate or update the monthly work-hours workbook, review confirmed work hours, or lock/unlock a pay period for corrections.
argument-hint: [YYYY-MM|status [YYYY-MM]|lock [YYYY-MM]]
allowed-tools: Read, Write, AskUserQuestion, Glob, Bash(python .claude/skills/work-hours-log-automation/scripts/cli.py *)
---

# Work Hours Log Automation

Maintain a monthly, three-sheet attendance workbook — a source Attendance Log a supervisor edits, a derived Work Hours Calculation sheet, and a derived Summary Report of hours only. Applies a fixed set of business rules (a flat 1-hour break, missing-scan flagging, holiday-vs-leave distinction) consistently, and never guesses a number that wasn't actually recorded.

This skill has no concept of pay rates, payroll amounts, or overtime pay — it produces confirmed work hours only.

## Required references

- Read [references/business-rules.md](references/business-rules.md) before explaining or applying any calculation.
- Read [references/workbook-schema.md](references/workbook-schema.md) before describing the workbook's structure.
- Read [references/csv-mapping-guide.md](references/csv-mapping-guide.md) before a CSV import.
- Read [references/period-lock-and-audit.md](references/period-lock-and-audit.md) before locking a period or handling a locked-period edit.
- Read [references/cli-reference.md](references/cli-reference.md) for the full `cli.py` command reference and the deferred-scheduling design.
- Use `assets/*.example.json` as the starting templates for first-time configuration.

All calculation and workbook writing happens in `scripts/cli.py` and the modules it imports — never compute hours or write workbook content directly; always call the script and relay its JSON output. Resolve `<this skill's folder>` in every command below from the base directory Claude Code reports for this skill at invocation — never hardcode a path.

## Storage locations

- Config (git-tracked, user-edited except `period-lock.json`): `output/work-hours-log-automation/_config/employee-master.json`, `.../company-holidays.json`, `.../period-lock.json`.
- Workbooks (git-tracked): `output/work-hours-log-automation/workbooks/<YYYY-MM>-work-hours-log.xlsx`, with backups under `.../workbooks/backups/`.
- Audit log (git-tracked, append-only): `output/work-hours-log-automation/_audit-log.md`.

Nothing about a specific company, department, or employee is built into this skill or its scripts — every one of those values lives in the two config files above.

## Interpret the request

Parse `$ARGUMENTS`:

- no argument, or `YYYY-MM`: generate/update that month's workbook (current month if none given)
- `status [YYYY-MM]`: read-only check — lock state, whether the workbook exists, outstanding review-flag count
- `lock YYYY-MM`: mark a month locked, once its data is finalized

When the intent is ambiguous, ask via `AskUserQuestion` with the likely candidates as options (**Log/update this month's attendance** / **Check status** / **Lock a finished month**) and a free-text fallback for anything else.

## Workflow

1. **First-run check.** If `output/work-hours-log-automation/_config/employee-master.json` or `.../company-holidays.json` is missing, walk through First-time setup (below) before anything else.
2. **Resolve the target month.** Use `$ARGUMENTS` if given; otherwise ask as free text, suggesting the current month as the default (a month value has no finite menu, so this stays free text).
3. **Check status first**, always:
   ```
   python "<this skill's folder>\scripts\cli.py" status --month <YYYY-MM> --workbook-dir output/work-hours-log-automation/workbooks --lock-state output/work-hours-log-automation/_config/period-lock.json
   ```
   If the request was `status`, report the result and stop here.
   If the month is locked and the request is to log/update data, go to Locked-period handling below before continuing.
4. **Choose input method** via `AskUserQuestion`: **Enter today's attendance conversationally (Recommended)** / **Import from a CSV file**.
5. **Manual branch** — ask only for what's genuinely missing: for each employee mentioned, gather Arrival Time, Departure Time (either may be "not yet" / missing), and Employee Status (Present is the default — only ask if there's reason to think it might be Leave) as plain free text. Assemble an entries JSON matching the schema in `references/cli-reference.md` and write it to a scratch path.
6. **CSV branch** — see CSV import below.
7. **Dry run first, always:**
   ```
   python "<this skill's folder>\scripts\cli.py" generate --employee-master output/work-hours-log-automation/_config/employee-master.json --holiday-config output/work-hours-log-automation/_config/company-holidays.json --month <YYYY-MM> --entries-json <path> [--csv <path> --mapping-json <path>] [--override-name "<name>" --override-reason "<reason>"] --dry-run
   ```
   Show the proposed `added`/`updated` counts and any `needsSupervisorReview` entries in chat before asking to save.
8. **Save confirmation** via `AskUserQuestion`: **Yes, save it (Recommended)** / **No, let me fix something first**.
9. **Real write** — re-run the same `generate` command from step 7, without `--dry-run`.
10. **Report the result** plainly: saved workbook path, backup path (if one was made), rows added/updated, and every outstanding `Needs Supervisor Review` entry.

## First-time setup

1. Explain that two config files are needed before anything else: the employee master (who's tracked, their department, shift) and the company-holiday list.
2. Show `assets/employee-master.example.json` and `assets/company-holidays.example.json` as starting shapes.
3. Gather the real employee list and holiday dates conversationally (free text — this is genuine data, not a finite menu).
4. Show the complete proposed JSON content back before writing anything.
5. Ask via `AskUserQuestion`: **Yes, save this configuration (Recommended)** / **No, let me change something**.
6. Write both files to `output/work-hours-log-automation/_config/` only after confirmation.

## CSV import

1. Ask for the CSV file path (free text).
2. Read only its header row (via `import-csv-preview`'s underlying `detect_header`, or by reading the first line directly) — don't touch data rows yet.
3. If the columns aren't obviously named for `employeeId`/`workDate`/`arrivalTime`/`departureTime`, ask via `AskUserQuestion`, once per field, which actual column header maps to it — never guess a mapping. See `references/csv-mapping-guide.md` for the exact flow and the mapping JSON schema.
4. Confirm date/time format if the sample values suggest something other than the `%Y-%m-%d`/`%H:%M` defaults.
5. Run:
   ```
   python "<this skill's folder>\scripts\cli.py" import-csv-preview --csv <path> --mapping-json <path> --employee-master output/work-hours-log-automation/_config/employee-master.json --out <scratch-path>
   ```
6. Show `importedCount`, `skippedCount`, and every warning in chat before proceeding — a skipped row is never silently dropped without being reported.
7. Continue to Workflow step 7 using `--csv`/`--mapping-json` on the `generate` call (or the produced normalized-entries file as `--entries-json`).

## Locked-period handling

If `status` reports the target month locked and the request is to add or change data: explain plainly that this is a self-attestation control, not real access verification (see `references/period-lock-and-audit.md`), then ask via `AskUserQuestion`: **Proceed with a named override (Recommended if this is a genuine, approved correction)** / **Stop, don't change a locked month**. If proceeding, collect the acting person's name and a reason as free text, and pass both as `--override-name`/`--override-reason` on every `generate` call for this request (including the dry run — the dry run itself never logs anything, but needs the flags to preview correctly).

## Locking a finished month

Only after the user explicitly asks to lock a month (e.g. "this month is finalized," "lock July"):
```
python "<this skill's folder>\scripts\cli.py" lock --month <YYYY-MM> --locked-by "<name>" --lock-state output/work-hours-log-automation/_config/period-lock.json
```
Ask for the locking person's name as free text first; confirm via `AskUserQuestion` (**Yes, lock it (Recommended)** / **No, not yet**) before running the command.

## Notes

- Never compute hours, classify a Day Type, or write workbook content directly — always call `cli.py` and relay its output.
- Never guess a missing Arrival or Departure Time. A blank stays blank and is flagged `Needs Supervisor Review`.
- Never save without an explicit `AskUserQuestion` save confirmation, shown against the dry-run preview first.
- Never treat the period lock as real access control — it's a self-attestation and audit-log control; say so plainly if asked.
- Clickable-question convention: intent disambiguation, input-method choice, CSV column-mapping confirmation, save confirmation, setup confirmation, locked-period override choice, and lock confirmation all use `AskUserQuestion`. Employee data (names, IDs, times, holiday dates, override reasons) stays free text — genuine data, not a finite menu.
- Ask only for what's genuinely missing — don't re-ask for an employee's department/shift once it's in the employee master, and don't ask about Employee Status unless there's a real reason to think it isn't the Present default.
- No scheduling trigger exists yet in this version — see `references/cli-reference.md`'s Deferred: Scheduling section. If asked whether this runs automatically, say plainly that it doesn't; a scheduler would need to be wired up separately.
