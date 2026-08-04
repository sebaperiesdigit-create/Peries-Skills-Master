# Clickable-Question Retrofit Checklist

Tracks which skills have been brought into compliance with the mandatory clickable-question convention documented in [`skill-builder/reference.md`](../../.claude/skills/skill-builder/reference.md#interaction-convention-clickable-questions-mandatory).

**Rollout model:** documented as a mandatory convention for all new skills immediately. Existing skills are retrofitted individually, whenever each is next audited or edited -- not as a bulk pass. See `project_skill_catalog_new_skill_procedure` / grill-me session, 2026-08-04.

## Status

| Skill | Status | Notes |
|---|---|---|
| `grill-me` | Compliant (excluded from retrofit) | Already implements the pattern natively as its core mechanism; do not edit unless explicitly requested |
| `skill-builder` | Pending | |
| `skill-finder` | Pending | |
| `evidence-pack-builder` | Pending | |
| `claude-code-basics` | Pending | |
| `customer-email-reply-drafter` | Pending | Needs the decision-vs-free-text boundary applied carefully -- email body stays free text |
| `product-description-writer` | Pending | |
| `order-status-summary` | Pending | CSV path is data intake -- likely stays free text unless a "use last uploaded file" style choice fits |
| `order-summary-report` | Pending | Same CSV-path consideration as `order-status-summary` |
| `new-joinee` | Pending | Already partly interactive -- check existing questions against the convention rather than assuming full rebuild |
| `start` | Pending | Same as `new-joinee` |
| `project-discovery` | Pending | |
| `existing-asset-finder` | Pending | |
| `first-task-mapper` | Pending | |
| `requirements-validator` | Pending | |
| `markdown-document-formatter` | Pending | |
| `meeting-note-summariser` | Pending | Raw meeting notes intake stays free text |
| `aios-structure-build` | Pending | |
| `aios-structure-organize` | Pending | Already asks for explicit confirmation -- check against clickable-question requirement |
| `aios-structure-validate` | Pending | |
| `record-a-skill` | Pending | |
| `daily-work-tracker` | Pending | Daily work description stays free text; setup/config choices should go clickable |
| `task-closure` | Pending | |
| `mcp-access-guide` | Pending | |

## How to retrofit a skill

1. Read the skill's `SKILL.md` in full.
2. Identify every point where it asks the user something.
3. Classify each: decision/config/confirmation/mode-selection/approval/structured-intake-with-options -> must become a clickable `AskUserQuestion` with a marked recommended option and a custom-answer fallback. Genuine free-text content (email bodies, notes, descriptions, file paths with no meaningful menu) -> leave as open text.
4. Edit the skill file, preserving its purpose and workflow.
5. Validate: re-read the edited file, confirm no unrelated content changed.
6. Update this table's Status column to `Compliant` and note the date.
