# Clickable-Question Retrofit Checklist

Tracks which skills have been brought into compliance with the mandatory clickable-question convention documented in [`skill-builder/reference.md`](../../.claude/skills/skill-builder/reference.md#interaction-convention-clickable-questions-mandatory).

**Rollout model:** documented as a mandatory convention for all new skills immediately. Existing skills are retrofitted individually, whenever each is next audited or edited -- not as a bulk pass. See `project_skill_catalog_new_skill_procedure` / grill-me session, 2026-08-04.

**Status: all 24 skills compliant as of 2026-08-12.** Any new skill added after this date must ship compliant from the start (per skill-builder's Mode 1 discovery/build); this table stays as the audit record and is reopened only if a future skill is found non-compliant.

## Status

| Skill | Status | Notes |
|---|---|---|
| `grill-me` | Compliant (excluded from retrofit) | Already implements the pattern natively as its core mechanism; do not edit unless explicitly requested |
| `skill-builder` | Compliant (2026-08-12) | Retrofitted Discovery Interview Rounds 1-6: finite-answer questions (invocation mode, arguments y/n, delegation style, conversational vs fire-and-forget, output location, final confirmation) moved to `AskUserQuestion`; open-ended ones (goal, trigger phrases, process walkthrough, guardrails) stay free text |
| `skill-finder` | Compliant (2026-08-12) | No conversion needed -- its only user-facing question (Step 1's clarifying question on a vague task) is genuine free text with no finite menu; documented the exemption inline in SKILL.md |
| `evidence-pack-builder` | Compliant (2026-08-12) | Step 2 (overwrite vs versioned) and Step 7 (write/cancel gate) already used `AskUserQuestion`; converted Step 4's screenshot yes/no to clickable. Step 1's task-name question and Step 5's gap-filling questions stay free text (genuine content, not a finite choice) |
| `claude-code-basics` | Compliant (2026-08-12) | Was already mostly compliant (resume choice, self-assessment, topic-controls menu, readiness confirms already used AskUserQuestion). Converted the remaining plain "Ask" prompts (pause-save confirm, comprehension checks, cheat-sheet save, progress-file update) to AskUserQuestion; comprehension checks deliberately omit the "(Recommended)" tag since marking it would give away the quiz answer. Explain-in-your-own-words checks stay free text |
| `customer-email-reply-drafter` | Compliant (2026-08-12) | Converted Step 7's refinement offer (tone/length/formality/none) to AskUserQuestion. Email body, refinement direction, and placeholder content stay free text |
| `product-description-writer` | Compliant (2026-08-12) | Converted Step 8's revise offer (tone/length/none) to AskUserQuestion. Product name, features, and refinement direction stay free text |
| `order-status-summary` | Compliant (2026-08-12) | Added clickable intake-method choice (file path / paste / reuse earlier file) to Step 1, and a clickable recovery choice when required columns are missing. CSV content and column-mapping details stay free text |
| `order-summary-report` | Compliant (2026-08-12) | Same intake-method retrofit as `order-status-summary`: added clickable file-path/paste/reuse-earlier-file choice to Step 1. CSV content and corrected paths stay free text |
| `new-joinee` | Compliant (2026-08-12) | Step 0's resume choice was already AskUserQuestion. Converted Step 1's prior-experience question (maps directly to the Zero/Some/Advanced calibration buckets) and Step 14's save confirmation. Name/role/first-task intake, layer check-ins, and Teach-Back Assessment stay free text (recall/explanation in own words) |
| `start` | Compliant (2026-08-12) | Steps 0 and 2-8's comprehension checks were already AskUserQuestion. Converted the remaining plain-text asks: Step 1's prior-experience question and advanced-skip offer, Step 2's visual-exploration choice, Step 7.5's opt-in, Step 9/11 write confirmations, Step 11's confidence check (bucketed to 3 options matching its own branches) and pause/re-teach branch, and the mid-session pause confirmation. Role intake stays free text |
| `project-discovery` | Compliant (2026-08-12) | Not applicable -- runs with `context: fork` (no back-and-forth with the user), fully read-only/report-only, no question points exist to convert |
| `existing-asset-finder` | Compliant (2026-08-12) | No conversion needed -- its only user-facing question (the Input section's clarifying question on a vague asset request) is genuine free text with no finite menu; documented the exemption inline in SKILL.md |
| `first-task-mapper` | Compliant (2026-08-12) | Steps 1-9 already used AskUserQuestion with drafted options + free-text Other. Converted the one remaining gap: the plain-text save-to-file confirmation |
| `requirements-validator` | Compliant (2026-08-12) | Added clickable intake-method choice (paste text / file path) to the Inputs section. Requirements content stays free text; skill is otherwise report-only with no other question points |
| `markdown-document-formatter` | Compliant (2026-08-12) | Converted the Inputs intake-method choice (paste text / file path) and Step 9's save confirmation to AskUserQuestion. Markdown content stays free text |
| `meeting-note-summariser` | Compliant (2026-08-12) | Added clickable intake-method choice (paste notes / file path) to Step 1. Notes content stays free text; save-to-file happens only if the user spontaneously asks, not via a skill-initiated prompt |
| `aios-structure-build` | Compliant (2026-08-12) | Not applicable -- fully non-interactive user-invoked script runner, no question points exist to convert |
| `aios-structure-organize` | Compliant (2026-08-12) | Step 4's apply confirmation already used AskUserQuestion; made its implicit second option ("No") explicit. No other question points exist |
| `aios-structure-validate` | Compliant (2026-08-12) | Step 4's save-report confirmation already used AskUserQuestion; made its implicit second option ("No") explicit. No other question points exist |
| `record-a-skill-custom` | Compliant (2026-08-12) | Converted every finite-answer gate to AskUserQuestion: intake-mode confirm, conflicting-evidence source pick, spec confirm, scope choice, same-name collision handling, overlap-check retry, EXTEND/MERGE approval (SKILL.md), plus reference.md's Layer 3 redact/exclude/retain confirmation. Workflow intake, corrections, and Mode B walkthrough content stay free text. (Renamed from `record-a-skill` 2026-08-14.) |
| `daily-work-tracker` | Compliant (2026-08-12) | Converted intent disambiguation, view/continue/edit offer, save confirmation, setup confirmation, leave/holiday check, and admin identity-correction confirmation to AskUserQuestion. Date, work-content fields, and identity/reason values stay free text |
| `task-closure` | Compliant (2026-08-12) | Step 7's fixable-issue approval already used AskUserQuestion. Converted Step 6's "anything else outstanding?" check. Task identification stays free text |
| `mcp-access-guide` | Compliant (2026-08-12) | Converted Step 4's walkthrough check-in to AskUserQuestion, offering actual connector names as options when 4 or fewer exist. Step 5's user-initiated connector question stays free text |

## How to retrofit a skill

1. Read the skill's `SKILL.md` in full.
2. Identify every point where it asks the user something.
3. Classify each: decision/config/confirmation/mode-selection/approval/structured-intake-with-options -> must become a clickable `AskUserQuestion` with a marked recommended option and a custom-answer fallback. Genuine free-text content (email bodies, notes, descriptions, file paths with no meaningful menu) -> leave as open text.
4. Edit the skill file, preserving its purpose and workflow.
5. Validate: re-read the edited file, confirm no unrelated content changed.
6. Update this table's Status column to `Compliant` and note the date.
