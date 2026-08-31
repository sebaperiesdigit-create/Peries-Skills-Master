# Workbook schema

One workbook per calendar month: `output/work-hours-log-automation/workbooks/<YYYY-MM>-work-hours-log.xlsx`. Exactly three sheets, each with one distinct role. This exact layout is built and maintained entirely by `scripts/workbook_builder.py` (`WorkbookBuilder`) — never hand-build or hand-edit the file structure.

## Sheet 1 — Attendance Log (the only sheet a human ever edits)

The raw/source-of-truth layer. Adding or correcting a day's attendance always means changing this sheet (via `cli.py generate`, never by opening the file and typing into it directly, so the change goes through the same upsert/backup/audit path every time).

| Column | Source |
|---|---|
| Work Date | The date this row is for |
| Day Type | Computed from `company-holidays.json` + weekday at write time (Weekend Holiday / Company Holiday / Working Day) |
| Employee ID | From `employee-master.json` |
| Employee Name | From `employee-master.json` |
| Department | From `employee-master.json` |
| Shift Start | From `employee-master.json` |
| Shift End | From `employee-master.json` |
| Arrival Time | Manually entered or CSV-imported; blank if not yet scanned |
| Departure Time | Manually entered or CSV-imported; blank if not yet scanned |
| Employee Status | Present (default) or Leave |
| Data Source | Manual or CSV Import |
| Review Status | OK or Needs Supervisor Review — kept in sync with Sheet 2's computed value every time the workbook is regenerated |
| Notes | Optional free text |

**Upsert behavior**: a new (Work Date, Employee ID) pair appends a new row. An existing pair updates in place — but an incoming record with a blank Arrival or Departure Time **never** overwrites an existing non-blank value on that row. This is what makes it safe to import a partial CSV (e.g. only departures, filed after arrivals were entered that morning) without ever losing data already on file.

## Sheet 2 — Work Hours Calculation (fully derived — never hand-edited)

Every `generate` run clears this sheet completely and rebuilds it from Sheet 1's current contents, so it can never drift out of sync with the source data.

| Column | Meaning |
|---|---|
| Work Date, Employee ID, Employee Name | Carried from Sheet 1 |
| Day Type | Recomputed from the holiday calendar |
| Employee Status | Carried from Sheet 1 |
| Arrival Time, Departure Time | Carried from Sheet 1 |
| Gross Hours | Departure − Arrival, before the break deduction (blank unless both scans present) |
| Break Hours | Always 1.0 when computed, otherwise blank |
| Confirmed Work Hours | See `business-rules.md` for the exact formula |
| Expected Hours | Shift End − Shift Start, from the employee master |
| Late Arrival, Early Departure | Boolean flags, see `business-rules.md` |
| Review Status | OK or Needs Supervisor Review |

## Sheet 3 — Summary Report (fully derived — never hand-edited)

Three stacked tables, each with its own title row and header row, in this order:

1. **Daily Totals** — Employee ID, Employee Name, Work Date, Daily Work Hours
2. **Weekly Totals** — Employee ID, Employee Name, Week Start, Week End, Weekly Work Hours (Monday–Sunday week)
3. **Monthly Totals** — Employee ID, Employee Name, Month, Monthly Work Hours

**No other columns are ever added to this sheet.** In particular: no Leave, Holiday, or Absent column or count. This is an explicit, deliberate requirement, not an oversight — the Summary Report answers "how many hours did each employee actually work," nothing else. Only rows where confirmed hours were actually computed contribute to any of these three totals.
