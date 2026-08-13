# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

Peries-Skills-Master is a content repository for Claude Code **skills** — it contains no application code, build system, or tests. Everything here is Markdown (skill instructions, reference docs) plus a couple of HTML deliverables. There is nothing to build, lint, compile, or run. The one exception is `daily-work-tracker/scripts/*.ps1`, small deterministic PowerShell helpers (marker read/write, config update) that the skill invokes directly — they're not part of a build/test pipeline.

## Repository layout

Skills follow Claude Code's real discovery convention: `.claude/skills/<skill-name>/SKILL.md` — one directory per skill, named to match the skill's frontmatter `name:` field, with that skill's supporting files alongside it in the same directory. `.claude/skills/` contains **only** these 25 skill folders — nothing else. All 25 are discoverable/invocable as of the last restructure.

```
.claude/skills/
  <skill-name>/SKILL.md         # one folder per skill (25 total), skill definitions only
  new-joinee/company-workflow.md, glossary.md
  start/company-workflow.md
  skill-builder/reference.md
  mcp-access-guide/references/connector-registry.md
  new-joiner-guide/references/mini-aios-new-joiner-complete-guide.md, .pdf, .docx

output/                         # generated deliverables live here, NOT under .claude/skills/
  skill-documentation/
    inputs/                     # source data used to build a deliverable (e.g. the skills CSV)
    skill-documentation-table-v5.html      # current/live deliverable
    skill-documentation-review-notes.md
    archive/                   # superseded versions, kept for history, not current
```

**Convention:** `.claude/skills/` is Claude Code's skill-discovery path — keep it limited to skill definitions. Task deliverables, CSVs, generated HTML/reports, and their archived prior versions belong under a top-level `output/<task-or-skill-name>/` folder instead, matching the convention already documented inside the skills themselves (e.g. `onboarding-output/`, `output/[skill-name]/`).

### Historical note

This repo previously kept every skill flattened into shared `skill-files/` and `references/` folders (disambiguated by filename, e.g. `SKILL_first_task_mapper.md`), which meant none of them were actually discoverable by Claude Code, and it also kept task deliverables (`inputs/`, `outputs/`) as siblings of the skill folders inside `.claude/skills/`. Both were restructured: skills moved into the per-skill-folder layout above, and deliverables moved out to top-level `output/skill-documentation/`. Two gaps left open by that restructure have since been fixed directly: `new-joinee/SKILL.md` no longer links to a nonexistent `templates/` folder — its cheat-sheet and certificate templates are now inlined in Step 14, the same pattern `start/SKILL.md` already used; and both onboarding skills now write exclusively to `onboarding-output/` (previously `start` used `output/onboarding/`). `output/skill-documentation/archive/` holds superseded versions of the skill-documentation-table HTML deliverable (`skill-documentation-table.html`, `-v2`, `-v3`, `-v4`) and the old pre-restructure dashboard preview (`skill_documentation_dashboard_preview.html`) — `skill-documentation-table-v5.html` is the current/live version, rebuilt from `output/skill-documentation/inputs/Skills_documentation_table -Final.csv` once the skills were confirmed discoverable.

### The "rename" maintenance task

When the user says "rename" (or a similar short trigger) after adding a new skill file, check that its frontmatter `name:` matches its directory name (`.claude/skills/<name>/SKILL.md`), and that any new supporting file's name reflects its purpose. Fix mismatches with `git mv` if tracked, plain rename otherwise (check `git status` first). Don't reorganize further than that without being asked.

## Skill file conventions (per `skill-builder/reference.md`)

These are the rules the skills in this repo follow when authoring/editing them — the canonical reference lives at `.claude/skills/skill-builder/reference.md`, sourced from https://code.claude.com/docs/en/skills.

- Frontmatter `name` — lowercase, hyphens, max 64 chars, matches the directory name.
- Frontmatter `description` — written as "Use when someone asks to [action], [action], or [action]." This is what Claude uses to decide whether to auto-invoke the skill, so it must contain the natural keywords a user would actually say.
- Only set additional frontmatter fields (`argument-hint`, `disable-model-invocation`, `allowed-tools`, `context: fork` + `agent`, `model`, `hooks`) when the skill actually needs them — don't add frontmatter just because it's available.
- Keep each `SKILL.md` under 500 lines; move detailed reference material into a separate supporting file in the same folder and link to it.
- `$ARGUMENTS`, `$N` / `$ARGUMENTS[N]` are the substitution placeholders for arguments passed via `/skill-name`.
- When building a new skill, run the Discovery Interview process described in `skill-builder/SKILL.md` before writing any files — don't skip straight to authoring.
- When auditing an existing skill, always read it first, then run the Frontmatter / Content / Integration / Quality checklist in `skill-builder/SKILL.md`.

## Skill inventory

| Skill (folder) | Purpose |
|---|---|
| `start` | Lean interactive onboarding (four-layer model: Data/MCP/Claude+Skills/Output) — recommended first step; soft-suggests `new-joinee` at close for deeper, role-specific follow-up |
| `new-joinee` | Thorough onboarding for absolute beginners (seven-layer model, adds Human Review + Evidence), including role-specific skill recommendations — soft-follows `start` if already completed (shortens the four-layer recap), otherwise fully standalone |
| `new-joiner-guide` | Coaches a Mini-AIOS company joiner through the company-specific **Mini-AIOS New Joiner Complete Guide** (checked in at `references/` as a runtime `.md` transcription, with the original `.pdf`/`.docx` kept for provenance) — Day One setup, task workflow, publishing, daily work log, handover, governance (GREEN/AMBER/RED), troubleshooting. Deliberately standalone: does not cross-reference or soft-follow `start`/`new-joinee` (those stay generic/role-agnostic; this one is Mini-AIOS-specific and operational) |
| `first-task-mapper` | Converts a vague task request into a concrete execution map |
| `project-discovery` | Read-only tour/inspection of a project for beginners |
| `existing-asset-finder` | Checks whether something already exists before it gets built (runs in a forked `Explore` subagent) |
| `skill-builder` | Builds new skills (via Discovery Interview) or audits existing ones against the checklist above |
| `customer-email-reply-drafter` | Drafts replies to customer emails (orders, refunds, delivery, product questions) |
| `meeting-note-summariser` | Summarizes/recaps meeting notes into structured minutes |
| `markdown-document-formatter` | Cleans up and polishes a Markdown document's structure |
| `order-status-summary` | Summarizes order status / delayed-order buckets from a CSV |
| `order-summary-report` | Revenue totals and top-selling products from an orders CSV |
| `product-description-writer` | Turns product features into e-commerce listing copy |
| `requirements-validator` | Reviews and improves requirements docs / acceptance criteria |
| `skill-finder` | Compares a proposed task against the skill catalog and recommends USE EXISTING / USE WITH PARAMETERS / EXTEND EXISTING / COMBINE EXISTING SKILLS / CREATE NEW / ESCALATE (read-only, chat-only) |
| `grill-me` | Stress-tests any plan/design one question at a time (with a recommended answer) until every decision, dependency, assumption, risk, and branch is resolved |
| `evidence-pack-builder` | Builds a traceable evidence pack for completed work (task brief, sources, queries, raw extracts, validation, screenshots, assumptions, decision log, final output) — reusable across departments |
| `mcp-access-guide` | Teaches beginners how MCP connects Claude to company systems via one interactive diagram; verifies connector availability, never handles credentials or modifies config |
| `task-closure` | Verifies whether a task is genuinely ready to close — nine dimensions checked against evidence (requirement-level traceability, freshness-checked), returns exactly one of COMPLETE / COMPLETE WITH LIMITATIONS / REVIEW REQUIRED / BLOCKED / INCOMPLETE; never modifies/publishes/deletes without per-action approval |
| `claude-code-basics` | Interactive, slash-command-only beginner lesson in the physical mechanics of VS Code + Claude Code (folders, Explorer, paths, panel, slash commands, prompts, terminal, tool results, real permission/edit-approval UI) — complements `start`/`new-joinee`'s conceptual architecture teaching rather than duplicating it |
| `daily-work-tracker` | Guides an employee through creating/viewing/editing a daily status entry (what was done, what's next, blockers), first-time setup, completion status checks, and a self-attested admin identity correction; reminder/notification automation is deferred (see its `SKILL.md` "Deferred" section) |
| `record-a-skill` | Records an existing workflow from supported evidence (transcripts, screenshots, event logs, example inputs/outputs, SOPs) or a live guided text walkthrough, reconstructs it as a confirmed reusable specification with provenance/confidence tagging, screens for sensitive content, checks for overlap via `existing-asset-finder`, and hands the confirmed spec to `skill-builder` (Mode 1 or Mode 2) to build or extend the actual skill; user-only (`disable-model-invocation: true`), never auto-invoked |
| `aios-structure-build` | Scaffolds the frozen AIS-OS starter-kit baseline into an empty target directory, hash-verifying every bundled template before writing and every written file after, with automatic rollback on any failure; portable (works installed personally or project-locally unmodified); user-only, never auto-invoked |
| `aios-structure-organize` | Additively repairs an existing AIS-OS project — dry-run plan of what's missing, explicit confirmation, then creates only the missing items; never overwrites, deletes, or moves anything that already exists; user-only, never auto-invoked |
| `aios-structure-validate` | Read-only structural check of an existing AIS-OS project against the frozen baseline (missing items, structural drift, non-empty placeholders, anti-pattern clutter), each with a concrete fix; only possible write is an optional, explicitly-consented saved report; user-only, never auto-invoked |

The two onboarding skills (`start`, `new-joinee`) only write files under `onboarding-output/`, and only after explicit user confirmation at each write — see the "File-Writing Safety" / "Guardrails" section inside each skill's `SKILL.md` before modifying them.

`daily-work-tracker` writes durable records (entries, employee config, admin audit log) only under `output/daily-work-tracker/`, always after explicit user confirmation; ephemeral completion markers live outside the repo at `%LOCALAPPDATA%\daily-work-tracker\markers\` and are never committed. Its `admin-update-identity` action is a self-attestation + audit-log control, not a real authorization check — Claude Code has no identity backend to verify against.

`record-a-skill` writes only under `output/record-a-skill/<task-slug>/`, always after explicit per-write confirmation: `raw/` and `_staging/` are git-ignored (original evidence copies and temporary extraction material never enter Git history), while `analysis/` and `workflow-specification.md` are committed only after redaction, review, and explicit approval. It never runs `git add`/`commit`/`push`/publish itself, never defaults a skill's install scope (project vs. personal — always an explicit user choice), and never edits a final generated or extended skill directly — that is always delegated to `skill-builder`.
