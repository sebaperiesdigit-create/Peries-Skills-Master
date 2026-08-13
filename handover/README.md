# Handover — Peries-Skills-Master

Living overview of this repo's current state. Update this file whenever something here goes stale — don't let it drift the way some memory files have (see "Known corrections" below). For a detailed, dated account of how the project got here, see `sessions/`.

## What this repo is

A content repository for Claude Code **skills** — no application code, build system, or tests. Everything is Markdown (skill instructions, reference docs) plus a couple of HTML deliverables, and one skill (`daily-work-tracker`) with three small PowerShell helper scripts. Full description and conventions: `CLAUDE.md` at the repo root — read that first, it's the actual source of truth for structure/conventions; this file is a narrative supplement, not a replacement.

## Current state (as of 2026-08-13)

- **25 skills**, one folder per skill at `.claude/skills/<name>/SKILL.md`, all discoverable/invocable. Full inventory table: `CLAUDE.md`.
- **Skill catalog**: `output/skill-documentation/skill-documentation-table-v5.html` (self-contained HTML deliverable) + `output/skill-documentation/inputs/Skills_documentation_table -Final.csv` (source data) + `output/skill-documentation/skill-documentation-review-notes.md` (dated changelog, §1–§61 as of today — this is the authoritative detailed history of every catalog edit, more granular than this handover folder for that specific subsystem).
- **Live hub**: http://varman-aios-hub-varmens.vercel.app/view/hub_pages/skill-catalog — a Vercel app reading `varman_aios.hub_pages` (member_name='peries', page_slug='skill-catalog') via Postgres. Pushed from `output/skill-documentation/` with `node --env-file=.env push_to_hub.js "skill-documentation-table-v5.html" "skill-catalog" "Peries Skill Catalog — Claude Code Skills Reference"`.
- **Top-level folders**: `.claude/skills/` (skill definitions only), `output/` (generated deliverables, e.g. `output/skill-documentation/`, `output/skill-builder/`), `onboarding-output/` (written by the `start`/`new-joinee` onboarding skills), `PROMPT/` (early project prompt spec + a skill-installation test report, mostly historical), `handover/` (this folder, added 2026-08-13).

## Two standing trigger phrases (say these verbatim to invoke the workflow)

- **"update skill docs"** (or "add to skill catalog" / "sync the skill catalog") → diff `.claude/skills/*` against the catalog's Skill IDs, add any missing skill (or re-sync an edited one) to `v5.html` + the CSV, log a new review-notes section. Local-only, does not push.
- **"push hub"** (or "sync hub" / "publish catalog") → diff local `v5.html` vs. the live hub content, ask permission with one clickable question, push if approved, log the push, show the live URL.

Full technical procedure for both (JSON schema of `v5.html`'s 4 embedded `<script>` blocks, `tryPhrase` derivation rule, verification method): see the `project_skill_catalog_*` memory files.

## Known open issues (deliberately not fixed — disclosed, not hidden)

- **CSV corruption, 2 rows**: `output/skill-documentation/inputs/Skills_documentation_table -Final.csv` rows for `new-joinee` (002) and `skill-finder` (014) each have an unescaped-comma/quote-count bug that shifts columns by one. Known and left alone per standing policy — don't fix as a drive-by unless asked.
- **`skill-builder`'s `skill-files-data['003']`** (the catalog's single-file "download SKILL.md" button) is stale — still describes the pre-restructure flat layout, doesn't match current `SKILL.md`. Disclosed gap, same policy as above.
- **2 of 4 sandbox-test findings from 2026-07-29 still open**: `order-status-summary` has no taxonomy bucket for a normal in-progress order; `markdown-document-formatter` detects code-fence issues but has no fix rule for them. (The other 2 — `project-discovery`'s frontmatter-parsing scope, `mcp-access-guide`'s missing "installed but not authenticated" connector label — were fixed 2026-08-03.)
- **`HUB_DATABASE_URL` credential rotation flagged, never confirmed done.** The password was typed in plaintext into a chat transcript multiple times during original 2026-07-24 setup. Lives in `output/skill-documentation/.env` (git-ignored). If rotated, only that file needs updating.
- **`record-a-skill` → `record-a-skill-custom` rename**: requested 2026-08-03 to preempt a possible name collision with an official Anthropic skill, then explicitly postponed by the user. No files touched. Scoping (7 affected files) already done if it's picked back up — see `project_record_a_skill_rename_postponed` memory.
- **23 of 25 skills still pending the mandatory clickable-question (`AskUserQuestion`) retrofit**, tracked in `output/skill-builder/clickable-question-retrofit-checklist.md`. Rollout is deliberately not a bulk pass — each skill gets retrofitted individually when it's next audited/edited. `grill-me` is permanently exempt (already compliant by design).

## Known corrections (memory hygiene)

The auto-memory system occasionally drifts from reality — memories are point-in-time notes, not live state. Corrected on 2026-08-13 while building this handover: `project_sandbox_test_findings_2026-07-29.md` had 2 of its 4 findings marked unfixed when they'd actually been resolved days earlier (2026-08-03) without the memory being updated. If something in a memory file looks stale, verify against the actual repo before trusting it — see that memory's own "How to apply" note for the general pattern.

## Newest skill: `new-joiner-guide` (added 2026-08-13, Skill 025)

Distinct from `start`/`new-joinee` — those are generic, role-agnostic onboarding; `new-joiner-guide` is specifically for Mini-AIOS company joiners, operationalizing an external **Mini-AIOS New Joiner Complete Guide** (checked into `.claude/skills/new-joiner-guide/references/` as `.pdf` + `.docx` originals and a validated `.md` transcription). Deliberately not cross-linked to `start`/`new-joinee`. Has two separate install paths on the catalog page: a Claude Code file-install prompt (shared mechanism, same as every other skill) and a second, skill-specific "Chat/Cowork prompt" button — a self-contained paste-into-conversation prompt (embeds `SKILL.md` + the full guide) with a hard save-then-confirm gate before it starts coaching. Full detail: `sessions/2026-08-13.md` and review-notes §58–§61.

## Where to look for more

- **`CLAUDE.md`** — authoritative structure/conventions, skill inventory table. Read this before assuming anything about layout.
- **`output/skill-documentation/skill-documentation-review-notes.md`** — the detailed, sequentially-numbered changelog for every catalog/hub edit (currently §1–§61).
- **Auto-memory** (`.claude/projects/.../memory/` on this machine, outside the repo) — durable cross-session notes: user feedback/preferences, project facts, gotchas, reference pointers. `MEMORY.md` there is the index.
- **`sessions/`** in this folder — dated narrative logs, reconstructed from git history + memory for everything before this folder existed, written live from here on.
