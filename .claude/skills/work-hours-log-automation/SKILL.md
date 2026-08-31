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

Everything this skill writes — config, workbooks, backups, audit log — lives under **one base folder the user chooses**, anywhere on disk (a company shared drive, a Documents folder, or inside this repo if they prefer). It is asked for once and remembered automatically after that; see First-time setup.

```
python "<this skill's folder>\scripts\cli.py" get-location
```
returns the remembered base folder (or `null` if never set) plus every derived path below, so this command is always the first thing to run — never guess or hardcode a path.

- Config (user-edited except `period-lock.json`): `<base folder>/_config/employee-master.json`, `.../company-holidays.json`, `.../period-lock.json`.
- Workbooks: `<base folder>/workbooks/<YYYY-MM>-work-hours-log.xlsx`, with backups under `.../workbooks/backups/`.
- Audit log (append-only): `<base folder>/_audit-log.md`.

Because the base folder can be anywhere, it is **not necessarily git-tracked** — durability relies on this skill's own backup-before-write behavior, not on version control. The one thing that *is* fixed and machine-local (never asked about, never git-tracked) is the tiny pointer file recording which base folder was chosen — see `references/cli-reference.md`'s `set-location`/`get-location` entries.

Nothing about a specific company, department, or employee is built into this skill or its scripts — every one of those values lives in the config files above, wherever the user chose to keep them.

## Interpret the request

Parse `$ARGUMENTS`:

- no argument, or `YYYY-MM`: generate/update that month's workbook (current month if none given)
- `status [YYYY-MM]`: read-only check — lock state, whether the workbook exists, outstanding review-flag count
- `lock YYYY-MM`: mark a month locked, once its data is finalized

When the intent is ambiguous, ask via `AskUserQuestion` with the likely candidates as options (**Log/update this month's attendance** / **Check status** / **Lock a finished month**) and a free-text fallback for anything else.

## Workflow

1. **First-run check.** Run `cli.py get-location`. If `baseFolder` is `null`, or its `_config/employee-master.json` / `company-holidays.json` don't exist yet, walk through First-time setup (below) before anything else.
2. **Identify the operator, once per session.** Before the first `generate` call this session, ask "Who's making this entry?" as free text (no finite set of good answers) if not already given in conversation. Remember it for every `generate` call in this session — don't re-ask for later entries in the same session.
3. **Resolve the target month.** Use `$ARGUMENTS` if given; otherwise ask as free text, suggesting the current month as the default (a month value has no finite menu, so this stays free text).
4. **Check status first**, always (using the paths from step 1's `get-location`):
   ```
   python "<this skill's folder>\scripts\cli.py" status --month <YYYY-MM> --workbook-dir <base folder>/workbooks --lock-state <base folder>/_config/period-lock.json
   ```
   If the request was `status`, report the result and stop here.
   If the month is locked and the request is to log/update data, go to Locked-period handling below before continuing.
5. **Choose input method** via `AskUserQuestion`: **Enter today's attendance conversationally (Recommended)** / **Import from a CSV file**.
6. **Manual branch** — one employee at a time:
   1. Ask which employee this entry is for via `AskUserQuestion`, offering every active employee from the master as a clickable option (plus **Done — no more entries** once at least one has been logged this run).
   2. For the chosen employee, ask Arrival Time then Departure Time as separate free-text turns (either may be "not yet" / missing — no finite set of good answers for a specific time).
   3. Ask Employee Status only if there's a real reason to think it isn't the Present default (e.g. the user said "mark X on leave"); when it does need asking, use `AskUserQuestion`: **Present (Recommended)** / **Leave**.
   4. Loop back to step 1 until the user picks **Done**.

   Assemble the collected rows into an entries JSON matching the schema in `references/cli-reference.md` and write it to a scratch path.
7. **CSV branch** — see CSV import below.
8. **Dry run first, always:**
   ```
   python "<this skill's folder>\scripts\cli.py" generate --employee-master <base folder>/_config/employee-master.json --holiday-config <base folder>/_config/company-holidays.json --month <YYYY-MM> --workbook-dir <base folder>/workbooks --lock-state <base folder>/_config/period-lock.json --audit-log <base folder>/_audit-log.md --operator-name "<operator>" --entries-json <path> [--csv <path> --mapping-json <path>] [--override-name "<name>" --override-reason "<reason>"] --dry-run
   ```
   Show the proposed `added`/`updated`/`prefilledBlankRows` counts in chat before asking to save. For `needsSupervisorReview`: if it's short (say, under ~10), list the actual entries; if it's long — expected right after a month is first pre-filled, since every not-yet-entered Working Day row is correctly flagged until filled in (see `references/business-rules.md`) — report just the count, not a wall of entries, and say why it's high.
9. **Save confirmation** via `AskUserQuestion`: **Yes, save it (Recommended)** / **No, let me fix something first**.
10. **Real write** — re-run the same `generate` command from step 8, without `--dry-run`.
    - If this exits with code `4` (someone else saved this workbook in the meantime — see `references/period-lock-and-audit.md`'s Concurrency guard), don't treat it as a normal error: say plainly that another operator just saved this month, and re-run steps 8–10 from scratch so the new data applies on top of theirs rather than being discarded.
11. **Report the result** plainly: saved workbook path, backup path (if one was made), rows added/updated, and the outstanding `Needs Supervisor Review` count (or list, per step 8's rule).

## First-time setup

Explain briefly that two config files are needed (employee master, company holidays) before anything else, plus a folder to keep everything in.

**Before entering either list, ask directly for a file path** (plain free text — a path has no finite set of good answers, so this is never a clickable menu): "Do you already have employee details in a file? If so, give me the path — otherwise say so and we'll add them one by one here." Ask the equivalent for the holiday list too (asked again after the employee list, right before entering holidays): "Do you have a file with company holiday dates, or should we add them one by one?"

- **If a path is given** (either list): read it. For CSV with non-obvious headers, confirm the column mapping one field at a time via `AskUserQuestion` (same spirit as the CSV import mapping flow below — never guess which column is which). Once parsed, show the **complete derived list** back in one review (not a per-row loop — the point of supplying a file is not re-typing it), and confirm with a single `AskUserQuestion`: **Yes, use this list as read (Recommended)** / **No, let me fix something** (falls through to the one-by-one flow below for corrections). This file-derived path never runs through `cli.py` — Claude reads/parses it directly and writes the resulting config JSON itself, same as the one-by-one path does.
- **If no file** (typical first time): gather **one employee / one holiday at a time**, each field its own turn — never one bulk free-text request for "the employee list." For each field below: free text where no menu could honestly represent the answer (ID, name, date), `AskUserQuestion` with a recommended option everywhere a sensible finite set exists.

**Per employee, in this order:**
1. Employee ID — free text. Offer a one-click shortcut first via `AskUserQuestion`: **Auto-generate the next ID (Recommended)** (e.g. `EMP-001`, incrementing per employee added this session) / **I'll enter a specific ID** (falls through to free text).
2. Employee Name — free text (no finite set of good answers).
3. Department — free text for the first employee. From the second employee onward, ask via `AskUserQuestion` using every department entered so far as clickable options, plus **A new department** (falls through to free text).
4. Shift Start — `AskUserQuestion`: common presets seen so far this session (or `08:00` / `09:00` / `09:30` if none yet) plus **A different time** (falls through to free text `HH:MM`).
5. Shift End — same pattern as Shift Start (presets `17:00` / `18:00` / a different time).
6. Show this one employee's full row back and confirm via `AskUserQuestion`: **Yes, add this employee (Recommended)** / **No, let me redo this one**.
7. After each confirmed employee, ask via `AskUserQuestion`: **Add another employee (Recommended until at least one exists)** / **Done — that's everyone**.

**Once the employee list is done, ask for the output location** (plain free text — no default is ever suggested, an explicit path is always required): "Where should this skill keep its configuration, workbooks, and audit log? Give me a full folder path — it can be anywhere on disk, it doesn't have to be inside this repo." Show the path back and confirm via `AskUserQuestion`: **Yes, use this folder (Recommended)** / **No, let me give a different path**. Once confirmed, run:
```
python "<this skill's folder>\scripts\cli.py" set-location --base-folder "<the confirmed path>"
```
This creates the folder structure and remembers the choice (a small machine-local pointer file — see `references/cli-reference.md`) so the user is never asked again on this machine. All following steps in this setup write into `<base folder>/_config/`.

**Per company holiday, in the same one-at-a-time style, after the base folder is set:**
1. Ask via `AskUserQuestion` whether there are any company holidays to add yet: **Yes, add one (Recommended)** / **No holidays yet — I can add them later**.
2. Date — free text (`YYYY-MM-DD`; no finite set of good answers).
3. Holiday name — free text.
4. Confirm the single holiday back via `AskUserQuestion`: **Yes, add it (Recommended)** / **No, let me redo this one**.
5. After each confirmed holiday, ask via `AskUserQuestion`: **Add another holiday** / **Done adding holidays (Recommended)**.

Once both lists are complete (whichever source each came from): show the full proposed `employee-master.json` and `company-holidays.json` content back in one final review, then ask via `AskUserQuestion`: **Yes, save this configuration (Recommended)** / **No, let me change something** (routes back into whichever flow above needs fixing). Write both files to `<base folder>/_config/` only after that confirmation. `assets/employee-master.example.json` and `assets/company-holidays.example.json` are the shapes being built toward — reference them for format, don't just dump them at the user as a fill-in-the-blank template.

## CSV import

1. Ask for the CSV file path (free text).
2. Read only its header row (via `import-csv-preview`'s underlying `detect_header`, or by reading the first line directly) — don't touch data rows yet.
3. If the columns aren't obviously named for `employeeId`/`workDate`/`arrivalTime`/`departureTime`, ask via `AskUserQuestion`, once per field, which actual column header maps to it — never guess a mapping. See `references/csv-mapping-guide.md` for the exact flow and the mapping JSON schema.
4. Confirm date/time format if the sample values suggest something other than the `%Y-%m-%d`/`%H:%M` defaults.
5. Run:
   ```
   python "<this skill's folder>\scripts\cli.py" import-csv-preview --csv <path> --mapping-json <path> --employee-master <base folder>/_config/employee-master.json --out <scratch-path>
   ```
6. Show `importedCount`, `skippedCount`, and every warning in chat before proceeding — a skipped row is never silently dropped without being reported.
7. Continue to Workflow step 7 using `--csv`/`--mapping-json` on the `generate` call (or the produced normalized-entries file as `--entries-json`).

## Locked-period handling

If `status` reports the target month locked and the request is to add or change data: explain plainly that this is a self-attestation control, not real access verification (see `references/period-lock-and-audit.md`), then ask via `AskUserQuestion`: **Proceed with a named override (Recommended if this is a genuine, approved correction)** / **Stop, don't change a locked month**. If proceeding, collect the acting person's name and a reason as free text, and pass both as `--override-name`/`--override-reason` on every `generate` call for this request (including the dry run — the dry run itself never logs anything, but needs the flags to preview correctly).

## Locking a finished month

Only after the user explicitly asks to lock a month (e.g. "this month is finalized," "lock July"):
```
python "<this skill's folder>\scripts\cli.py" lock --month <YYYY-MM> --locked-by "<name>" --lock-state <base folder>/_config/period-lock.json
```
Ask for the locking person's name as free text first; confirm via `AskUserQuestion` (**Yes, lock it (Recommended)** / **No, not yet**) before running the command.

## Never leave the user without a next step

Every response that hands control back to the user — after setup completes, after a workbook save is reported, after a status check, after any checkpoint — must end with a clickable `AskUserQuestion` offering the sensible next actions (e.g. **Log attendance for a month** / **Check status** / **Lock a finished month** / **Add another employee to the master**, trimmed to whatever's actually relevant right now), never a bare open-ended question with no menu. The user should never be left wondering what to say next.

## Notes

- Never compute hours, classify a Day Type, or write workbook content directly — always call `cli.py` and relay its output.
- Never guess a missing Arrival or Departure Time. A blank stays blank and is flagged `Needs Supervisor Review`.
- Never save without an explicit `AskUserQuestion` save confirmation, shown against the dry-run preview first.
- Never treat the period lock as real access control — it's a self-attestation and audit-log control; say so plainly if asked.
- Clickable-question convention, one item at a time: intent disambiguation, input-method choice, CSV column-mapping confirmation, save confirmation, lock confirmation, locked-period override choice, every per-employee/per-holiday "add another?" and confirm-this-one step in First-time setup, shift-time presets, department selection (once at least one exists), which-employee-is-this-entry-for during manual entry, and Employee Status (when it needs asking at all) all use `AskUserQuestion` with a recommended option. Only fields with no finite set of good answers stay free text: Employee ID (unless auto-generated), Employee Name, a brand-new department, a specific date, holiday name, exact arrival/departure times, and override/lock reasons.
- Ask only for what's genuinely missing — don't re-ask for an employee's department/shift once it's in the employee master, and don't ask about Employee Status unless there's a real reason to think it isn't the Present default.
- No scheduling trigger exists yet in this version — see `references/cli-reference.md`'s Deferred: Scheduling section. If asked whether this runs automatically, say plainly that it doesn't; a scheduler would need to be wired up separately.
