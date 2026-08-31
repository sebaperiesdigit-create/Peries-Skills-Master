# `cli.py` reference

`scripts/cli.py` is the one surface that actually does anything in this skill — reads config, applies business rules, writes the workbook. SKILL.md's conversational workflow is a thin, beginner-friendly layer over these same four commands; nothing about the calculation or workbook logic lives in prose or in the model's own judgment.

Invoke as: `python "<this skill's folder>\scripts\cli.py" <command> [options]` — resolve `<this skill's folder>` from the base directory Claude Code reports for this skill at invocation, never hardcode it.

Every command prints one JSON object to stdout. Exit codes: `0` success, `1` validation/input error, `2` locked period without a valid override, `3` file/path not found.

## `generate`

The main command — upserts Sheet 1, fully rebuilds Sheets 2 and 3, backs up the prior workbook, and saves.

| Flag | Required | Notes |
|---|---|---|
| `--employee-master` | yes | path to `employee-master.json` |
| `--holiday-config` | yes | path to `company-holidays.json` |
| `--month` | yes | `YYYY-MM`, the target workbook |
| `--workbook-dir` | no | default `output/work-hours-log-automation/workbooks` |
| `--lock-state` | no | default `output/work-hours-log-automation/_config/period-lock.json` |
| `--audit-log` | no | default `output/work-hours-log-automation/_audit-log.md` |
| `--entries-json` | one of this or `--csv` required | manual/normalized entries, see schema below |
| `--csv`, `--mapping-json` | see above | CSV import path; `--mapping-json` required if `--csv` is given |
| `--override-name`, `--override-reason` | only if the month is locked | both required together to write to a locked month |
| `--dry-run` | no | computes and reports everything with **zero** file writes — no workbook, no backup, no audit entry, even against a locked month with a valid override |

Rows whose `workDate` falls outside `--month` are skipped with a warning, never silently written into the wrong month's workbook.

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

`--month`, `--locked-by` (both required), `--lock-state` (optional, same default as above). Marks a month locked — no override needed for this action itself, it's the routine end-of-period step.

## `status`

Read-only, never blocked by a lock. `--month` (required), `--workbook-dir`, `--lock-state` (both optional, same defaults). Reports whether the month is locked, whether its workbook exists, its path, and — if it exists — how many rows currently carry `Needs Supervisor Review`.

## Deferred: Scheduling

No trigger is wired up in this version — no Windows Task Scheduler job, no Claude Code `schedule` routine. Every command above already takes fixed, explicit arguments and produces machine-readable JSON, specifically so that a future scheduler of any kind can call it directly and headlessly, with no Claude Code conversational layer involved at all. The intended future shape, for reference only:

```
python cli.py generate --employee-master <path> --holiday-config <path> --month <YYYY-MM>
```
run on a recurring schedule (e.g. end of each working day) by whatever scheduling mechanism is chosen later — a Windows Scheduled Task invoking this command directly, or a Claude Code `schedule` routine invoking the skill with fixed arguments. Building that trigger is explicitly out of scope for this version; nothing here should be treated as already wired up.
