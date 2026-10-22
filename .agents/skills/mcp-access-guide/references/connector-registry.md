# Connector Registry

Maintained reference of MCP connectors available to this organization. This file is a **template** — populate it as connectors are verified. Never store passwords, tokens, connection strings, or other secrets in this file or anywhere in this skill.

If a field cannot be confirmed, write `Needs confirmation`. Do not guess.

---

## How to use this file

- The `mcp-access-guide` skill reads this file to fill in connector details that live tool inspection cannot confirm (e.g., system owner, escalation contact, prohibited actions).
- Update `Verification date` whenever a row is reviewed. Stale entries (no review in 90+ days) should be re-verified before being labeled "Registry verified."
- `Evidence source` should say *how* the entry was confirmed (e.g., "Confirmed with IT admin, 2026-05-01", "Read from connector settings page").

---

## Registry Template

| Field | Value |
|---|---|
| Connector name | |
| Company system | |
| Verified availability | Needs confirmation |
| Accessible data | |
| Permission level | |
| Prohibited actions | |
| System owner | Needs confirmation |
| Escalation contact | Needs confirmation |
| Verification date | |
| Evidence source | |

---

## Example Entry (illustrative — replace with real data)

| Field | Value |
|---|---|
| Connector name | Example CRM Connector |
| Company system | Example CRM |
| Verified availability | Needs confirmation |
| Accessible data | Contact records, deal stages (example only) |
| Permission level | Read-only (example only) |
| Prohibited actions | No record deletion, no bulk export (example only) |
| System owner | Needs confirmation |
| Escalation contact | Needs confirmation |
| Verification date | Needs confirmation |
| Evidence source | Demo only — not yet reviewed |

---

## Adding a new connector

Copy the Registry Template table, fill in every field you can confirm, and mark anything else `Needs confirmation`. Do not mark `Verified availability` as confirmed unless a live tool check or a documented admin confirmation backs it up.
