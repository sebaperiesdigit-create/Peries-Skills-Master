# Business rules

These rules are encoded in `scripts/business_rules.py` (`BusinessRulesEngine`) — this file documents them so a human can audit the logic without reading Python, and so any future change is made in one place, then verified against both.

## Day Type (date-level, applies to every employee equally)

Precedence, evaluated in this order:

1. **Weekend Holiday** — the date is a Saturday or Sunday. Always wins, regardless of any other configuration.
2. **Company Holiday** — the date appears in `company-holidays.json`. Applies to every employee automatically; nobody marks it per-employee.
3. **Working Day** — anything else.

Day Type is a fact about the calendar date, never about a specific employee. It must never be confused with Employee Status.

## Employee Status (employee-level, per row)

- **Present** — the default. No one has to set this explicitly.
- **Leave** — set by a supervisor for a specific employee on a specific Working Day. Only meaningful on a Working Day; Leave on a Weekend/Company Holiday is redundant (the day already has no hours expectation) but not an error.

This version supports exactly these two values. No leave sub-types (Annual, Sick, Casual, etc.) — that would be extending scope beyond what's been asked for.

## The fixed break

Every employee gets a flat **1-hour** break, regardless of shift length. It is not tracked as a separate scan — it's simply subtracted from gross hours.

## Confirmed Work Hours — the exact formula

Confirmed hours are computed **only** when all three are true: Day Type is `Working Day`, Employee Status is `Present`, and both Arrival Time and Departure Time are recorded.

```
confirmed_hours = departure_time - arrival_time - 1.0 (the fixed break)
```

Every other combination produces a **blank** confirmed-hours value — never a guess:

| Day Type | Employee Status | Arrival | Departure | Confirmed Hours | Review Status |
|---|---|---|---|---|---|
| Weekend/Company Holiday | any | any | any | blank | OK |
| Working Day | Leave | any | any | blank | OK (expected absence) |
| Working Day | Present | missing | any | blank | **Needs Supervisor Review** |
| Working Day | Present | any | missing | blank | **Needs Supervisor Review** |
| Working Day | Present | present, but ≥ departure | present, but ≤ arrival | blank | **Needs Supervisor Review** |
| Working Day | Present | present | present, after arrival | `departure - arrival - 1.0` | OK |

The "missing scan" rule is absolute: this skill never estimates, defaults, or infers a missing Arrival or Departure Time. A blank stays blank until a human supplies the real value.

## Overnight shifts are not supported in this version

If Departure Time is not strictly after Arrival Time on the same calendar day, the row is treated as a data-quality issue (flagged `Needs Supervisor Review`), not guessed at. Real overnight-shift support (spanning midnight) was an explicitly open, unanswered question in the original requirements gathering and was deliberately left out rather than guessed at — extend `business_rules.py`'s `calculate()` only once a real overnight-shift requirement is confirmed.

## Late Arrival / Early Departure — decimal hours, not booleans

Computed only when confirmed hours were computed (both scans present, valid); `0.0` otherwise:

- `late_arrival_hours` = Arrival Time minus the employee's configured Shift Start, floored at 0 (0 if not late).
- `early_departure_hours` = Shift End minus Departure Time, floored at 0 (0 if not early).

These are decimal-hour values (consistent with every other hour column — Confirmed Work Hours, Expected Hours, etc.), not `True`/`False` flags — "0.42 hours late" is more useful to a supervisor than just "late." They are informational columns on the Work Hours Calculation sheet — they do not change the confirmed-hours number itself, and they carry no automatic penalty or pay-rate implication (this skill has no concept of pay rates or overtime premiums at all — hours only).

## Pre-filling the month

Per the original spec ("working-day rows are pre-filled for every selected employee"), every `generate` call first ensures a blank row exists on the Attendance Log for **every active employee** × **every Working Day date in the target month** — Arrival/Departure blank, Employee Status defaulted to `Present`, Data Source `Pending`. This never overwrites an existing row (prefill runs before the incoming entries/CSV are upserted, so a date that already has data is left alone), and it's idempotent — re-running `generate` on a month that's already fully pre-filled creates zero new rows. Weekend/Company Holiday dates are never pre-filled, matching the original spec's "no employee attendance rows should be created for weekend or company-holiday dates."

A direct consequence: right after a month is first pre-filled, essentially every row will show `Needs Supervisor Review` (correctly — a Working Day + Present + no scan yet *is* a missing scan, per the table above), until real data is entered. This is expected, not a bug — see SKILL.md's guidance on summarizing this as a count rather than listing every row when it's large.

## Summary Report scope

The Summary Report shows **only** Daily / Weekly (Monday–Sunday) / Monthly confirmed-hours totals per employee, summed from rows where confirmed hours were actually computed. It never includes a Leave, Holiday, or Absent column or count — that was an explicit requirement, not an oversight. See `workbook-schema.md`.
