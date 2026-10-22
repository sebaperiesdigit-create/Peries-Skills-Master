# Work Hours Log Automation — Complete Chat Handoff

**Project:** Digit Web Lanka Work Hours Log Automation (demo)  
**Prepared:** 31 August 2026  
**Status:** Requirements clarified; demo workbook and demo skill were drafted. Installation into the user's own Codex environment is still pending.

## 1. Original assignment and intended benefit

The assigned task is to reduce manual work in recording employee attendance and calculating work hours for one department, initially assumed to be **Postage** at Digit Web Lanka.

The normal source will eventually be a face-scanning/biometric device export. It records only:

- Arrival time
- Departure time

The business benefit is: maintain accurate, organised employee work-hour records with less manual effort.

For the **demo**, the supervisor manually enters or changes Arrival and Departure every day. Employee master details must already be filled when the workbook is created.

## 2. Confirmed business rules

| Area | Confirmed rule |
|---|---|
| Break time | Every employee has a fixed total break of **1 hour**. Lunch and tea are not separately scanned. |
| Shifts | Employees can have different shift start/end times. |
| Daily hours | `Departure − Arrival − 1 hour`. |
| Missing scan | Do not guess hours. Keep confirmed hours blank and flag **Needs Supervisor Review**. |
| Weekends | Saturday and Sunday are compulsory holidays for everyone. |
| Company holiday | A company-provided holiday applies to everyone on that date. |
| Other weekdays | Working Days. |
| Employee leave | On a Working Day, a supervisor marks the employee **Leave**. Otherwise the default is **Present**. |
| Holiday vs leave | A holiday is a date-level rule for everyone. Leave is an employee-level rule. They must not be treated as the same thing. |
| Summary | Only employee Daily, Weekly and Monthly work-hour totals. Do **not** add Leave, Holiday or Absent columns to the Summary sheet. |

## 3. Required workbook structure — exactly three sheets

### Sheet 1 — Employee Attendance Log

Purpose: Source log and configuration. This is the only sheet a supervisor should manually update in the demo.

Recommended columns:

| Column | Source / rule |
|---|---|
| Work Date | Monthly work-date row |
| Day Type | `Weekend Holiday`, `Company Holiday`, or `Working Day` |
| Employee ID | Pre-filled from employee master |
| Employee Name | Pre-filled from employee master |
| Department | Pre-filled from employee master |
| Shift Start | Pre-filled from employee master |
| Shift End | Pre-filled from employee master |
| Arrival Time | Manually entered in demo; biometric export in production |
| Departure Time | Manually entered in demo; biometric export in production |
| Employee Status | `Present` by default; supervisor changes to `Leave` if required |
| Data Source | `Manual Demo` now; `Biometric Export` later |
| Review Status | `Ready`, `Needs Supervisor Review`, or relevant review result |
| Notes | Optional supervisor note |

Configuration on the same sheet should contain the selected department/employee scope, the one-hour break, and the company-holiday date list.

Working-day rows are pre-filled for every selected employee. No employee attendance rows should be created for weekend or company-holiday dates.

### Sheet 2 — Work Hours Calculation

Purpose: Auditable, row-level calculation from Sheet 1. It should reference Sheet 1 and show Day Type, employee identity, shift, status/review result, gross hours, fixed break, confirmed work hours, expected hours, late arrival and early departure.

Only valid **Present + Working Day** rows with both Arrival and Departure receive confirmed hours. Leave, holidays and unresolved scans do not add confirmed hours.

### Sheet 3 — Summary Report

Purpose: Per-employee totals, refreshed whenever the log changes.

Required columns only:

| Employee ID | Employee Name | Daily Work Hours | Weekly Work Hours | Monthly Work Hours |
|---|---|---:|---:|---:|

The report updates daily and provides daily, weekly and month-to-date totals for each employee.

## 4. Automation approach chosen for the demo

- Storage: **Excel workbook** is the recommended demo format because the existing/manual workflow is Excel-based and the three related sheets remain in one file.
- Workbook frequency: one workbook per month.
- Current input: an **employee master file** with ID, name, department, shift start and shift end.
- Current daily action: supervisor fills only Arrival and Departure and changes Employee Status to Leave when needed.
- Future input: biometric/device export, mapped after the real export file is received.
- Output: updated monthly workbook in the chosen output folder.
- Backup: create a `backups` subfolder inside the output folder and make a timestamped backup before an update.

## 5. Scheduling recommendation

For the manual demo, two triggers are useful:

1. **08:15 AM, weekdays** — pre-fill/check the current working-day rows.
2. **06:30 PM, weekdays** — calculate/rebuild the report after normal departure time.

Skip Saturday, Sunday and configured company holidays. The final schedule must be confirmed with the department because some shifts may end after 6:30 PM.

Important: A Codex skill is instructions and workflow guidance. It does **not** run automatically by itself. A scheduler must invoke Codex with the skill and known file paths, or a separate local production runner must perform the workbook update.

## 6. Demo skill created

**Skill name:** `demo-work-hours-log-automation`  
**Display name:** Demo Work Hours Log

It is explicitly a demo skill, not the final company skill. Its instructions require Codex to:

- Ask for the absolute employee-master input path and output-folder path.
- Validate the input and output location.
- Create backups automatically under `backups/`.
- Build the three-sheet monthly workbook.
- Pre-fill employee details and working-day rows.
- Preserve manual Arrival/Departure changes and existing data when updating.
- Apply the fixed break, Day Type, leave, and review rules above.

### Installation problem discovered

The skill was initially created in the assistant's temporary Codex workspace. That does **not** make it appear in the user's own Codex skill list or ordinary ChatGPT browser chat.

An installable ZIP package was prepared. The user must download it and extract the complete folder into their own local Codex skills folder, then restart Codex.

Expected local structure:

```text
%USERPROFILE%\\.codex\\skills\\demo-work-hours-log-automation\\
  SKILL.md
  agents\\openai.yaml
  references\\workbook-schema.md
```

Then invoke it in Codex Desktop/CLI with:

```text
$demo-work-hours-log-automation
```

This local custom-skill method does not make the skill appear in a normal ChatGPT web chat.

## 7. Files created in this chat

| File | Purpose | State |
|---|---|---|
| `Postage_Work_Hours_2026-09_Demo.xlsx` | Three-sheet demo Excel workbook | Created; earlier version needs final Day Type/prefill alignment check before presenting as final. |
| `demo_biometric_export.csv` | Sample future biometric-export input | Created for early demo. |
| `run_work_hours_demo.mjs` | Early standalone CSV-to-workbook demo script | Legacy proof of concept; no longer the chosen demo operation because the user wants a Codex skill. |
| `README.md` | Earlier demo notes | Created; may contain outdated script-oriented guidance. |
| `demo-work-hours-log-automation.zip` | Local Codex skill package | Created and ZIP-tested; user requested this exact package to install manually. |

## 8. Known gaps / do not claim complete yet

1. The actual biometric export headers and sample rows have not been provided. Do not hard-code final import mapping yet.
2. The real supervisor template and formal requirement document have not been provided.
3. The original workbook needs a final verification/update so its Sheet 1 uses the final **Day Type** design and employee master prefill behaviour exactly as agreed.
4. The initial `run_work_hours_demo.mjs` reflects earlier decisions and should not be treated as the production scheduler or final integration.
5. No external scheduling has been created. A scheduler needs its own approved execution method and paths.
6. Real company holiday management and department/employee selection must be confirmed with the supervisor.

## 9. Recommended next actions

1. Install the demo skill ZIP in the user's own Codex environment and confirm it appears after restart.
2. Create/finalise a separate employee-master demo file with dummy employees, departments and shifts.
3. Rebuild/verify the demo workbook using the final 13-column Attendance Log mapping and the exact 5-column Summary Report.
4. Test manually with one normal Present day, one Leave day, one missing departure, one weekend, and one company holiday.
5. When received, analyse the real biometric export and the supervisor's workbook before building the final company skill.
6. Decide the final scheduler/runtime only after the actual storage location and company permissions are known.

## 10. Questions still requiring supervisor confirmation

1. Which department(s) and which employees are in scope initially?
2. What are the exact biometric-export columns and time/date format?
3. Is the device export produced as CSV, Excel, a shared folder file, or another source?
4. What are the authorised company-holiday dates and who maintains them?
5. What shifts exist, including overnight shifts if any?
6. What time should the end-of-day update run for the latest shift?
7. Are corrections allowed after the daily report, and who can make them?
8. Where will the production workbook and backups be stored?
9. Is the monthly workbook required to include every employee or only a selected department/ID list?
10. What should happen when a biometric scan is duplicated, late, or missing?

## 11. User preferences relevant to continuation

- Use simple, beginner-friendly language.
- Keep explanations direct; no fluff.
- Do not invent attendance data or work hours for missing scans.
- Keep the Summary Report focused on hours only.
- Treat this as a demo until the real documents and exports are supplied.

