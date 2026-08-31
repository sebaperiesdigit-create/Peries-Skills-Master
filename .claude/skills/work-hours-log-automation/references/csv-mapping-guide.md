# CSV import and column mapping

No biometric-device export format is assumed anywhere in this skill. A CSV of any shape can be imported, but only after its columns are explicitly mapped to this skill's fixed internal field names — never guessed.

## Required internal fields

Every mapping JSON must map all four of these to a real column header in the target CSV:

- `employeeId`
- `workDate`
- `arrivalTime`
- `departureTime`

An optional fifth field, `employeeStatus`, may also be mapped; if it's absent from the mapping (or the CSV cell is blank), every imported row defaults to `Present`. Any mapped value equal to `"Leave"` (case-insensitive) is read as Leave; anything else is read as Present.

## The runtime mapping-confirmation flow

1. Read only the CSV's header row (`CsvImporter.detect_header`) — this never touches the data rows, so it's safe to do before anything is confirmed.
2. If the header already contains columns that obviously match (`employeeId`, `Employee ID`, `emp_id`, etc.), propose that mapping back to the user for a one-click confirmation rather than asking field-by-field.
3. Otherwise, ask via `AskUserQuestion`, once per required field, which real column header corresponds to it — offering the actual header names found in step 1 as the clickable options.
4. Also confirm the date format (default `%Y-%m-%d`) and time format (default `%H:%M`) actually used in the file — don't assume ISO format if the sample rows suggest otherwise.
5. Write the confirmed mapping to a mapping JSON (schema below), then run `cli.py import-csv-preview` to see exactly what would be imported before it ever touches a workbook.

## Mapping JSON schema

```json
{
  "columnMapping": {
    "employeeId": "Emp Code",
    "workDate": "Date",
    "arrivalTime": "In Time",
    "departureTime": "Out Time"
  },
  "dateFormat": "%Y-%m-%d",
  "timeFormat": "%H:%M"
}
```

The left-hand keys are always the fixed internal names above. The right-hand values are the actual column headers found in the specific CSV being imported — these change per source file, per mapping.

## What gets skipped, and why (never silently guessed)

`import-csv-preview` reports every skipped row and the exact reason, and always leaves a warning behind rather than importing a best-guess value:

- **Blank employee ID** — row skipped.
- **Employee ID not found in the employee master** — row skipped; the CSV file is not the source of truth for who's a valid employee, `employee-master.json` is.
- **Work date doesn't parse against the configured date format** — row skipped (the whole row, not just the date, since a row with no reliable date can't be placed anywhere).
- **Duplicate (employee ID, work date) pair within the same file** — only the first occurrence is kept; later ones are skipped and reported.
- **Arrival or Departure time present but doesn't parse against the configured time format** — that one field is treated as missing (blank, subject to the normal missing-scan rule), not the whole row — a bad time doesn't have to invalidate an otherwise-valid Employee ID/date pair.

Always review `import-csv-preview`'s `warnings` list and skipped count before proceeding to a real `generate` run.
