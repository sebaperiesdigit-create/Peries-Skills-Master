---
name: first-task-mapper
description: Use when someone says I need to do X but I'm not sure how, help me plan this task, break down this request, what do I need to complete this, map this for me, or asks a vague or incomplete work request. Converts vague requests into clear execution maps.
argument-hint: [vague request or task description]
allowed-tools:
  - Read
  - Glob
  - Grep
  - Question
---

## What This Skill Does

Converts a vague work request into a clear, safe execution map. For each field in the map, it labels the confidence level so the employee can distinguish verified facts from missing information. Finishes with a readiness decision and a recommended next action. The skill plans only — it never executes the mapped task.

## Process

Ask clarifying questions conversationally to fill in each field. Label every important field as one of:

- **Confirmed** — The employee explicitly confirmed this
- **Assumption** — Reasonable inference, not yet confirmed
- **Unknown** — Cannot be determined from available information
- **Not confirmed** — Exists but not yet verified with the employee

If $ARGUMENTS is provided, use it as the initial request. Otherwise ask the employee to describe their request.

### Step 1: Restate & Confirm

Restate your understanding of the request back to the employee. Ask: "Is this correct?" If they say no, clarify before proceeding.

### Step 2: Identify Business Goal

Ask: "What is the real goal here? What problem are you trying to solve?"

Label: Confirmed / Assumption / Unknown

### Step 3: Define Expected Result & Output Format

Ask: "What should the final result look like? (a report, a list, a file, an email, something else?)"

Label: Confirmed / Assumption / Unknown

### Step 4: Identify Source of Truth

Ask: "Where does the data live? (a database, a spreadsheet, a file, a person?)"

Check project files for hints (CLAUDE.md, configs), but do not guess. If unclear, ask.

Label: Confirmed / Assumption / Unknown

### Step 5: Identify Required MCP Connector

Inspect MCP configuration files (read-only) to see what connectors exist. Report safe details only:
- Connector name
- Whether configuration appears present

**NEVER display raw config values, passwords, API keys, tokens, or connection strings.**

If the needed connector does not appear configured, flag it: "No matching MCP connector detected — this may block execution."

Label: Confirmed / Assumption / Unknown / Not confirmed

### Step 6: Check for Existing Skill or SOP

Inspect `.claude/skills/` for any existing skill that could handle this task. Read only the frontmatter of each SKILL.md. If a matching skill exists, note it. If none exists, state: "No existing skill found for this task — a new one may be needed."

Label: Confirmed / Assumption / Unknown

### Step 7: Define Allowed Actions & Permissions

Ask: "What are you allowed to do? Any restrictions on what Claude can modify?"

Check CLAUDE.md for documented rules or restrictions.

Label: Confirmed / Assumption / Unknown | Use "Not confirmed" rather than inventing a permission.

### Step 8: Define Validation Method

Ask: "How will you check the output is correct? Any specific criteria?"

Label: Confirmed / Assumption / Unknown | Use "Not confirmed" rather than inventing a validation rule.

### Step 9: Identify Reviewer & Completion Evidence

Ask: "Who needs to review the result? What counts as 'done'?"

Label: Confirmed / Assumption / Unknown / Not confirmed — use "Not confirmed" rather than inventing a reviewer.

### Step 10: Readiness Decision

Based on all labeled fields, determine readiness:

| Decision | Meaning |
|----------|---------|
| **READY** | All critical fields confirmed |
| **READY WITH ASSUMPTIONS** | Some fields are assumptions — proceed with caution |
| **BLOCKED** | Critical fields unknown — cannot proceed |
| **NEEDS APPROVAL** | Permissions or reviewer not confirmed |
| **NEEDS CONNECTOR** | Required MCP connector not found |
| **NEEDS SOURCE CONFIRMATION** | Data source not confirmed |

Add one recommended next action based on the decision.

## Output Format

After gathering all information, present the execution map in chat using this structure:

```
## Execution Map: [task name]

**Request:** [restated request] — [Confirmed]

### Business Goal
[goal] — [Confirmed/Assumption/Unknown]

### Expected Result
[result and format] — [Confirmed/Assumption/Unknown]

### Source of Truth
[data source] — [Confirmed/Assumption/Unknown]

### Required MCP Connector
[connector] — [Confirmed/Assumption/Unknown/Not confirmed]

### Existing Skill or SOP
[skill name or "None found"] — [Confirmed/Assumption/Unknown]

### Allowed Actions & Permissions
[permissions] — [Confirmed/Assumption/Unknown/Not confirmed]

### Validation Method
[criteria] — [Confirmed/Assumption/Unknown/Not confirmed]

### Reviewer & Completion Evidence
[reviewer and evidence] — [Confirmed/Assumption/Unknown/Not confirmed]

### Readiness Decision: **[DECISION]**

**Recommended next action:** [one concrete step]
```

After showing the map in chat, ask: *"Does this look correct? I can save it to output/first-task-mapper/ for your records."*

Write only after the user explicitly confirms. When saving, use the file path:

`output/first-task-mapper/[task-name]-execution-map.md`

Write only inside `output/first-task-mapper/` — never elsewhere.

## Notes

- NEVER execute the mapped task — this skill only creates the plan
- NEVER modify project files, .claude/ configuration, MCP settings, or any project source
- NEVER display raw config values, passwords, API keys, tokens, or connection strings
- NEVER assume a reviewer, source, permission, or validation rule — use "Not confirmed" instead
- NEVER write outside `output/first-task-mapper/`
- Always show the execution map in chat first; save to file only after user confirms
- If the request is too vague, ask focused clarifying questions — never guess
- Inspect CLAUDE.md and existing skills before suggesting new workflows
- If project documentation is missing, flag it as a limitation and continue with questions
