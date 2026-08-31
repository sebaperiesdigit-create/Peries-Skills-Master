# `cli.py` reference

`scripts/cli.py` is the one surface that actually does anything in this skill — reads config, applies business rules, writes the workbook. SKILL.md's conversational workflow is a thin, beginner-friendly layer over these same commands; nothing about the calculation or workbook logic lives in prose or in the model's own judgment.

Every path below (`--employee-master`, `--workbook-dir`, etc.) is relative to a base folder the user chose during setup — there is no built-in default location. Always resolve it first with `get-location` (see below) rather than guessing or hardcoding a path.

Invoke as: `python "<this skill's folder>\scripts\cli.py" <command> [options]` — resolve `<this skill's folder>` from the base directory Claude Code reports for this skill at invocation, never hardcode it.

Every command prints one JSON object to stdout. Exit codes: `0` success, `1` validation/input error, `2` locked period without a valid override, `3` file/path not found, `4` the workbook changed on disk since it was loaded (another operator saved first — see `period-lock-and-audit.md`'s Concurrency guard; the fix is always to re-run the same command).

## `generate`

The main command — upserts Sheet 1, fully rebuilds Sheets 2 and 3, backs up the prior workbook, and saves.

| Flag | Required | Notes |
|---|---|---|
| `--employee-master` | yes | path to `employee-master.json` |
| `--holiday-config` | yes | path to `company-holidays.json` |
| `--month` | yes | `YYYY-MM`, the target workbook |
| `--workbook-dir` | yes | `<base folder>/workbooks` |
| `--lock-state` | yes | `<base folder>/_config/period-lock.json` |
| `--audit-log` | yes | `<base folder>/_audit-log.md` |
| `--operator-name` | yes | who is running this save — recorded on every audit-log entry, not just overrides (see `period-lock-and-audit.md`) |
| `--entries-json` | one of this or `--csv` required | manual/normalized entries, see schema below |
| `--csv`, `--mapping-json` | see above | CSV import path; `--mapping-json` required if `--csv` is given |
| `--override-name`, `--override-reason` | only if the month is locked | both required together to write to a locked month |
| `--dry-run` | no | computes and reports everything with **zero** file writes — no workbook, no backup, no audit entry, even against a locked month with a valid override |

Rows whose `workDate` falls outside `--month` are skipped with a warning, never silently written into the wrong month's workbook. Immediately before an actual (non-dry-run) save, the workbook on disk is re-checked against what was loaded at the start of the command — if it changed (another operator saved first), the command exits `4` without writing anything; see `period-lock-and-audit.md`'s Concurrency guard.

**Entries JSON schema** (also what `import-csv-preview --out` produces, so its output can be fed straight back in as `--entries-json`):

```json
[
  {
    "employeeId": "EMP-001",
    "workDate": "2026-09-07",
    "arrivalTime": "09:10",
    "departureTime": "17:50",
    "employeeStatus": "Present",
    "notes": ""
  }
]
```
`arrivalTime`/`departureTime` may be `null` for a missing scan. `employeeStatus` is `"Present"` or `"Leave"`.

## `import-csv-preview`

Validates and maps a CSV **without touching any workbook** — always run this before `generate --csv` to review what would actually be imported.

`--csv`, `--mapping-json`, `--employee-master` (all required) → writes a normalized entries JSON to `--out` (required), and prints `importedCount`, `skippedCount`, and the full `warnings` list.

## `lock`

`--month`, `--locked-by`, `--lock-state` (all required). Marks a month locked — no override needed for this action itself, it's the routine end-of-period step.

## `status`

Read-only, never blocked by a lock. `--month`, `--workbook-dir`, `--lock-state` (all required). Reports whether the month is locked, whether its workbook exists, its path, and — if it exists — how many rows currently carry `Needs Supervisor Review`.

## `set-location` / `get-location`

The base folder — where config, workbooks, and the audit log all live — is chosen once by the user (asked as a direct free-text question, no default ever suggested) and remembered from then on, so nothing else in this skill ever needs to ask again.

- `set-location --base-folder "<path>"` — creates the `_config/`, `workbooks/`, and `workbooks/backups/` subfolders under the given path if they don't exist, and saves the choice to a small pointer file. Prints the resolved `baseFolder` and every derived path (`employeeMaster`, `companyHolidays`, `lockState`, `workbookDir`, `auditLog`).
- `get-location` (no arguments) — returns the remembered `baseFolder` and derived paths, or `{"baseFolder": null, "paths": null}` if nothing has been set yet on this machine. Always call this first, in every session, before assuming any path.

The pointer file itself lives at a fixed, machine-local, non-repo location (`%LOCALAPPDATA%\work-hours-log-automation\location.json` on Windows) — it is never git-tracked and never part of the base folder itself, since the base folder might not even be inside this repo. The base folder it points to is **not necessarily git-tracked either** — it can be any folder on disk the user chose, including a company shared drive. Durability there relies on this skill's own backup-before-write behavior (see `workbook-schema.md`), not on version control.

## Deferred: Scheduling

No trigger is wired up in this version — no Windows Task Scheduler job, no Claude Code `schedule` routine. Every command above already takes fixed, explicit arguments and produces machine-readable JSON, specifically so that a future scheduler of any kind can call it directly and headlessly, with no Claude Code conversational layer involved at all. The intended future shape, for reference only:

```
python cli.py generate --employee-master <base folder>/_config/employee-master.json --holiday-config <base folder>/_config/company-holidays.json --month <YYYY-MM> --workbook-dir <base folder>/workbooks --lock-state <base folder>/_config/period-lock.json --audit-log <base folder>/_audit-log.md --operator-name "<scheduled job identity>"
```
run on a recurring schedule (e.g. end of each working day) by whatever scheduling mechanism is chosen later — a Windows Scheduled Task invoking this command directly, or a Claude Code `schedule` routine invoking the skill with fixed arguments. Building that trigger is explicitly out of scope for this version; nothing here should be treated as already wired up.
