# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

Peries-Skills-Master is a content repository for Claude Code **skills** — it contains no application code, build system, or tests. Everything here is Markdown (skill instructions, reference docs) plus one HTML preview file. There is nothing to build, lint, compile, or run.

## Repository layout (important: non-standard)

Claude Code's actual discovery convention is `.claude/skills/<skill-name>/SKILL.md` — a directory per skill, named to match the skill's frontmatter `name:` field, with any supporting files alongside it in that same directory.

This repo does **not** follow that convention yet. Instead:

- `.claude/skills/skill-files/` — every skill's content flattened into one shared folder, one file per skill, named `SKILL_<name_with_underscores>.md` (e.g. `name: first-task-mapper` → `SKILL_first_task_mapper.md`).
- `.claude/skills/references/` — supporting/reference docs flattened the same way, named `<purpose>_<associated-skill-name>.md` (e.g. `reference_skill_builder.md`, `company-workflow_new_joinee.md`).

**Consequence:** as of the last audit, none of the skills in this repo are actually discoverable or invocable by Claude Code, because none of them sit at `.claude/skills/<name>/SKILL.md`. Relative links inside skill files (e.g. `SKILL_skill_builder.md` → `[reference.md](reference.md)`) are broken for the same reason — the linked files aren't co-located. Some reference files (`glossary_new_joinee.md`, `company-workflow_start.md`) are orphaned — not linked from any SKILL file. A `templates/` folder referenced by `SKILL_new_joinee.md` (`templates/certificate-template.md`, `templates/cheat-sheet-template.md`) does not exist anywhere in the repo.

**Do not fix this structure proactively.** The user is aware of it and has not approved the full restructure (moving files into per-skill folders, fixing broken links, creating the missing `templates/` folder). Only perform that restructure if the user explicitly asks to make the skills actually work/discoverable, or frames a request as "fix the structure."

### The one approved recurring maintenance task: "rename"

When the user says "rename" (or a similar short trigger) after adding new files under `.claude/skills/`, do this narrow check for every file added since the last pass — nothing more:

1. Read each new/changed file's YAML frontmatter `name:` field.
2. Compare it to the filename, using the sibling convention above (`SKILL_<name>.md` in `skill-files/`, `<purpose>_<skill-name>.md` in `references/`).
3. Rename any file whose name doesn't match its own frontmatter `name:` (or, for references, its associated skill) so it follows the sibling convention. Use plain rename (`mv`); only use `git mv` if the files are already tracked by git (check `git status` first).
4. Do **not** move files into per-skill subfolders, fix broken relative links, or create the missing `templates/` folder as part of this — those all belong to the larger restructure described above and require separate, explicit approval.

## Skill file conventions (per `reference_skill_builder.md`)

These are the rules the skills in this repo follow when authoring/editing them — the canonical reference lives at `.claude/skills/references/reference_skill_builder.md`, sourced from https://code.claude.com/docs/en/skills.

- Frontmatter `name` — lowercase, hyphens, max 64 chars, matches what would be the directory name.
- Frontmatter `description` — written as "Use when someone asks to [action], [action], or [action]." This is what Claude uses to decide whether to auto-invoke the skill, so it must contain the natural keywords a user would actually say.
- Only set additional frontmatter fields (`argument-hint`, `disable-model-invocation`, `allowed-tools`, `context: fork` + `agent`, `model`, `hooks`) when the skill actually needs them — don't add frontmatter just because it's available.
- Keep each `SKILL.md` under 500 lines; move detailed reference material into a separate supporting file and link to it.
- `$ARGUMENTS`, `$N` / `$ARGUMENTS[N]` are the substitution placeholders for arguments passed via `/skill-name`.
- When building a new skill, run the Discovery Interview process described in `SKILL_skill_builder.md` before writing any files — don't skip straight to authoring.
- When auditing an existing skill, always read it first, then run the Frontmatter / Content / Integration / Quality checklist in `SKILL_skill_builder.md`.

## Skill inventory

| Skill file | Purpose |
|---|---|
| `SKILL_start.md` | Lean interactive onboarding (four-layer model: Data/MCP/Claude+Skills/Output) |
| `SKILL_new_joinee.md` | Thorough onboarding for absolute beginners (seven-layer model, adds Human Review + Evidence) |
| `SKILL_first_task_mapper.md` | Converts a vague task request into a concrete execution map |
| `SKILL_project_discovery.md` | Read-only tour/inspection of a project for beginners |
| `SKILL_existing_asset_finder.md` | Checks whether something already exists before it gets built (runs in a forked `Explore` subagent) |
| `SKILL_skill_builder.md` | Builds new skills (via Discovery Interview) or audits existing ones against the checklist above |
| `SKILL_customer_email_reply_drafter.md` | Drafts replies to customer emails (orders, refunds, delivery, product questions) |
| `SKILL_meeting_note_summariser.md` | Summarizes/recaps meeting notes into structured minutes |
| `SKILL_markdown_document_formatter.md` | Cleans up and polishes a Markdown document's structure |
| `SKILL_order_status_summary.md` | Summarizes order status / delayed-order buckets from a CSV |
| `SKILL_order_summary_report.md` | Revenue totals and top-selling products from an orders CSV |
| `SKILL_product_description_writer.md` | Turns product features into e-commerce listing copy |
| `SKILL_requirements_validator.md` | Reviews and improves requirements docs / acceptance criteria |

The two onboarding skills (`SKILL_start.md`, `SKILL_new_joinee.md`) only write files under `output/onboarding/`, and only after explicit user confirmation at each write — see the "File-Writing Safety" section inside each of those skill files before modifying them.

## Reference file inventory

| Reference file | Associated skill(s) |
|---|---|
| `reference_skill_builder.md` | `SKILL_skill_builder.md` — full frontmatter field reference, invocation control matrix, advanced patterns (hooks, `context: fork`, dynamic context injection), troubleshooting |
| `company-workflow_new_joinee.md` | `SKILL_new_joinee.md` — detailed seven-layer teaching content, by-role workflows |
| `company-workflow_start.md` | Written for `SKILL_start.md`'s four-layer model, but currently orphaned (not linked from any SKILL file) |
| `glossary_new_joinee.md` | Term glossary for onboarding; currently orphaned (not linked from any SKILL file) |
| `skill_documentation_dashboard_preview.html` | Standalone HTML preview, not linked from any skill |
