# Period lock and audit trail

This is `work-hours-log-automation`'s own, fully independent enterprise control — its own state file, its own audit log, its own override gate. It shares no code, no file format, and no cross-reference with any other skill in this repo.

## Why this exists

A standard control in real Time & Attendance systems: once a month's hours have been reported on or handed to payroll, silent edits become a compliance risk. Locking a period and requiring a named, reasoned, logged override for any further change turns "someone quietly changed a number" into "there's a dated, attributable record of exactly who changed what and why."

## What "locked" actually means

Locking a month blocks `cli.py generate` from writing to that month's workbook unless a valid override is supplied. It does **not** block `cli.py status` (read-only) or `import-csv-preview` (writes only to a separate preview file, never touches a workbook).

## Honest limitation — read this before assuming it's real access control

This is a **self-attestation and audit-log control**, not real authorization. Nothing in this skill verifies that the "override name" typed in is actually the person typing it, or that they're actually authorized to unlock a period. There is no identity backend here to check against. If a user or supervisor asks whether this actually prevents unauthorized changes: say plainly that it does not — it creates a permanent, honest record of who claimed to make a change and why, which is valuable for audit and accountability, but is not a security boundary.

## Lock-state schema — `output/work-hours-log-automation/_config/period-lock.json`

```json
{
  "lockedMonths": {
    "2026-07": {
      "lockedAt": "2026-08-05T08:00:00+05:30",
      "lockedBy": "Supervisor Name"
    }
  }
}
```

A month absent from `lockedMonths` is implicitly unlocked. Lock a month with `cli.py lock --month <YYYY-MM> --locked-by "<name>"`.

## The override workflow

When `cli.py generate --month <m>` is run against a locked month:

- Without `--override-name` and `--override-reason`: the command exits with code `2` and writes nothing — no workbook change, no backup, no audit entry.
- With both supplied: the write proceeds normally (backup, upsert, sheet rebuild, save), and **exactly one** new section is appended to the audit log — never on a `--dry-run`, even if a valid override was supplied, since a dry run makes no real change to justify logging.

In the conversational skill workflow, this maps to: if `cli.py status` reports the target month locked, ask via `AskUserQuestion` whether to proceed with a named override (collecting the acting person's name and a reason as plain free text — genuine data, not a finite menu) or to stop.

## Audit-log format — `output/work-hours-log-automation/_audit-log.md`

Append-only. One section per override event. Prior entries are never edited or deleted by this skill.

```
## 2026-08-31T14:57:49+05:30
- Month: 2026-09
- Overridden by: Supervisor Test
- Reason: Correcting a missed scan
- Action: generate on locked period 2026-09
```
