---
name: daily-work-tracker
description: Use when someone asks to record their daily work, update today's tracker, review or view a work entry, edit a past entry, set up daily-work-tracker for the first time, check completion status, or correct employee identity in the tracker.
argument-hint: [today|YYYY-MM-DD|view [date]|edit [date]|setup|status [date]|admin-update-identity]
allowed-tools: Read, Write, Glob, Bash(powershell -NoProfile -ExecutionPolicy Bypass -File *)
---

# Daily Work Tracker

Maintain one verified daily status entry per employee and work date. Never mark a day complete until its entry is saved and verified.

## Required references

- Read [references/policy.md](references/policy.md) before setup, saving, editing, skipping, or identity administration.
- Use [assets/daily-entry-template.md](assets/daily-entry-template.md) for entries.
- Use [assets/employee-config.example.json](assets/employee-config.example.json) when explaining configuration.
- Use scripts in `scripts/` for deterministic marker and config operations.

## Storage locations

- Durable records live in the repo under `output/daily-work-tracker/` (reviewable, safe to commit):
  - Config: `output/daily-work-tracker/_config/employee.json`
  - Entries: `output/daily-work-tracker/<employee-id>/<year>/<YYYY-MM-DD>.md`
  - Audit log: `output/daily-work-tracker/_admin-audit-log.md`
- Completion markers are ephemeral, machine-local runtime state at `%LOCALAPPDATA%\daily-work-tracker\markers\<employee-id>\<date>.done`. Never treat a marker as the record of truth — the entry file is always the real record. Never commit markers.

## Interpret the request

Parse `$ARGUMENTS` against this vocabulary:

- no date or `today`: record or continue today's entry
- `YYYY-MM-DD`: record or continue that work date
- `view [date]`: show an entry without changing it
- `edit [date]`: revise work content while preserving revision history
- `setup`: guide first-time configuration
- `status [date]`: check the completion marker
- `admin-update-identity`: perform a self-attested identity correction (see below)

Use the employee's local date when none is supplied. When the date is ambiguous, ask directly as free text (a date value has no finite menu). When the intent is ambiguous, ask via `AskUserQuestion` with the most likely candidates as options — typically **Record/continue today's entry** / **View an entry** / **Edit an entry** / **Check status** — and use the question's free-text option for less common intents (setup, admin-update-identity).

## Workflow

1. Confirm the requested action and work date.
2. Run `scripts/start-tracker.ps1` to initialize the local marker directory, clean markers older than 90 days, and report whether employee config exists:
   ```
   powershell -NoProfile -ExecutionPolicy Bypass -File "<this skill's folder>\scripts\start-tracker.ps1"
   ```
   Resolve `<this skill's folder>` from the base directory Claude Code reports for this skill at invocation — never hardcode a path.
3. If configuration is missing, run first-time setup (below) before continuing with any other action.
4. Load employee identity from `output/daily-work-tracker/_config/employee.json`. Never substitute the Windows username, and never ask the employee to retype their ID once configured.
5. If the work date is a Saturday or Sunday, tell the employee tracking is weekdays-only and stop — no entry, no marker.
6. Locate the canonical entry file for the employee and work date:
   - if none exists, begin from `assets/daily-entry-template.md`;
   - if one exists, ask via `AskUserQuestion`: **View it** / **Continue it** / **Edit it** — never create a competing second entry for the same date.
7. Gather only work-related fields: working times, completed work, work in progress, blockers, evidence/notes, and next actions (all free text). Accept either conversational Q&A (what did you do / what's next / any blockers) or a pasted free-form update.
8. Show the complete proposed entry or revision. Allow corrections (free text).
9. Ask via `AskUserQuestion` for explicit save confirmation: **Yes, save it (Recommended)** / **No, let me fix something first**.
10. Validate required identity, date, work content, and destination path.
11. Save safely:
    - preserve prior content when revising (append to Edit History, never erase);
    - write the entry file;
    - read it back and verify the expected content is present;
    - only after verification passes, call:
      ```
      powershell -NoProfile -ExecutionPolicy Bypass -File "<this skill's folder>\scripts\check-completion.ps1" -EmployeeId "<employee-id>" -Date "<YYYY-MM-DD>" -MarkComplete
      ```
      Omit `-MarkComplete` when only checking status (e.g. for the `status [date]` action) rather than marking a date complete.
12. Report the work date, employee ID, saved path, verification result, and marker result.

If the user cancels, or any validation/write/verification step fails, stop without creating or refreshing the completion marker.

## First-time setup

1. Ask for the official employee name and employee ID (free text).
2. Show both values back exactly as entered.
3. Explain that later identity changes go through `admin-update-identity`, not an ordinary edit.
4. Ask via `AskUserQuestion`: **Yes, that's correct (Recommended)** / **No, let me re-enter it**.
5. Save to `output/daily-work-tracker/_config/employee.json` only after confirmation.

## Missing weekday entries and leave/holiday status

When `status` or `view` finds a weekday with no entry, ask via `AskUserQuestion`: "Was this a leave or public holiday day?" — options **Yes** / **No**.

- If yes: write a skip-status record (not a full entry) noting the reason, and do not create a completed marker.
- If no: report it as a genuinely missing entry.

There is no holiday calendar in this system — every skip is employee-declared at the time it's noticed, not looked up automatically.

## Editing

Employees may edit work content, including after completion. Preserve the original created timestamp; add a dated revision record under Edit History summarizing what changed. Never let an ordinary edit change the employee name or ID — that requires `admin-update-identity`. After a verified revision, refresh the marker so it points to the valid entry. Never erase historical entries because identity later changes.

## Administrator identity correction

This is a self-attestation gate, not a real authorization check — Claude Code has no identity backend to verify anyone's authorization against. Treat it as confirmation-and-audit-log control, not access control, and say so plainly if asked.

1. Ask for the current employee ID on file, the corrected name and ID, the acting administrator's name/role, and a reason (all free text).
2. Show the proposed change exactly as entered and ask via `AskUserQuestion`: **Yes, apply this correction (Recommended)** / **No, cancel**.
3. Run `scripts/update-employee-config.ps1`, which updates only `output/daily-work-tracker/_config/employee.json` and appends a record to `output/daily-work-tracker/_admin-audit-log.md`:
   ```
   powershell -NoProfile -ExecutionPolicy Bypass -File "<this skill's folder>\scripts\update-employee-config.ps1" -OldEmployeeId "<current-id>" -NewEmployeeId "<new-id>" -NewEmployeeName "<new-name>" -AdminName "<admin-name>" -Reason "<reason>"
   ```
4. Never rewrite past daily entries — historical files keep whatever name/ID was current when they were written.

## Completion standard

Close successfully only when:

- the canonical entry exists at the approved path;
- read-back verification passes;
- a marker exists for the date (or a skip-status record for a declared leave/holiday);
- no duplicate entry was created;
- the employee receives the exact saved path and status.

Otherwise state what failed and the safest next action.

## Deferred (not built in this version)

Reminder automation is intentionally out of scope for now: no install-reminders/uninstall-reminders/show-reminder scripts, no Windows Scheduled Task, no toast-notification module dependency (e.g. BurntToast). The intended future design, for reference: a Scheduled Task fires at 17:50 and 18:00 on weekdays; each occurrence first checks `scripts/check-completion.ps1` and stays silent if a valid marker already exists; a toast shows "Run" (opens Windows Terminal and starts `/daily-work-tracker`) and "Not now" (dismisses only that notification). Completion must never be inferred from a dismissal, timeout, or shutdown. Build this as a separate follow-up once the rest of this skill is stable in practice.

## Notes

- Never delete a daily entry file.
- Never write any file without showing the exact content and getting explicit confirmation first.
- Don't build or reference the deferred reminder scripts above — they don't exist yet.
- Clickable-question convention: intent disambiguation, the view/continue/edit offer, save confirmation, setup confirmation, the leave/holiday check, and the admin identity-correction confirmation all use `AskUserQuestion`. Date disambiguation, work-content fields, and identity/reason values (name, ID, admin name/role, reason) stay free text — genuine data, not a finite menu.
