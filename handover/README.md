# Handover — Peries-Skills-Master

Living overview of this repo's current state. Update this file whenever something here goes stale — don't let it drift the way some memory files have (see "Known corrections" below). For a detailed, dated account of how the project got here, see `sessions/`.

## What this repo is

A content repository for Claude Code **skills** — no application code, build system, or tests. Everything is Markdown (skill instructions, reference docs) plus a couple of HTML deliverables, and one skill (`daily-work-tracker`) with three small PowerShell helper scripts. Full description and conventions: `CLAUDE.md` at the repo root — read that first, it's the actual source of truth for structure/conventions; this file is a narrative supplement, not a replacement.

## Current state (as of 2026-08-27)

- **26 skills**, one folder per skill at `.claude/skills/<name>/SKILL.md`, all discoverable/invocable. Full inventory table: `CLAUDE.md`. Newest: `ecommerce-seo-auditor` (added 2026-08-27, Skill 026 — see below). (`record-a-skill` was renamed to `record-a-skill-custom` 2026-08-14.)
- **Skill catalog**: `output/skill-documentation/skill-documentation-table-v5.html` (self-contained HTML deliverable) + `output/skill-documentation/inputs/Skills_documentation_table - Sheet1.csv` (source data — stopped tracking new skills after row 13/`order-status-summary`; a known, accepted gap, not actively maintained) + `output/skill-documentation/skill-documentation-review-notes.md` (dated changelog, §1–§68 as of today — this is the authoritative detailed history of every catalog edit, more granular than this handover folder for that specific subsystem).
- **Live hub**: http://varman-aios-hub-varmens.vercel.app/view/hub_pages/skill-catalog — a Vercel app reading `varman_aios.hub_pages` (member_name='peries', page_slug='skill-catalog') via Postgres. Pushed from `output/skill-documentation/` with `node --env-file=.env push_to_hub.js "skill-documentation-table-v5.html" "skill-catalog" "Peries Skill Catalog — Claude Code Skills Reference"`.
- **Top-level folders**: `.claude/skills/` (skill definitions only), `output/` (generated deliverables, e.g. `output/skill-documentation/`, `output/skill-builder/`), `onboarding-output/` (written by the `start`/`new-joinee` onboarding skills), `PROMPT/` (early project prompt spec + a skill-installation test report, mostly historical), `handover/` (this folder, added 2026-08-13).

## Two standing trigger phrases (say these verbatim to invoke the workflow)

- **"update skill docs"** (or "add to skill catalog" / "sync the skill catalog") → diff `.claude/skills/*` against the catalog's Skill IDs, add any missing skill (or re-sync an edited one) to `v5.html` + the CSV, log a new review-notes section. Local-only, does not push.
- **"push hub"** (or "sync hub" / "publish catalog") → diff local `v5.html` vs. the live hub content, ask permission with one clickable question, push if approved, log the push, show the live URL.

Full technical procedure for both (JSON schema of `v5.html`'s 4 embedded `<script>` blocks, `tryPhrase` derivation rule, verification method): see the `project_skill_catalog_*` memory files.

## Known open issues (deliberately not fixed — disclosed, not hidden)

- **`HUB_DATABASE_URL` credential rotation flagged, never confirmed done.** The password was typed in plaintext into a chat transcript multiple times during original 2026-07-24 setup. Lives in `output/skill-documentation/.env` (git-ignored). If rotated, only that file needs updating.
- **CSV source data (`inputs/Skills_documentation_table - Sheet1.csv`) hasn't tracked new skills since row 13** (`order-status-summary`, added ~2026-07-21) — every skill added since (14 through 26) exists in `v5.html` but not in the CSV. Explicitly flagged, not backfilled, as of 2026-08-27; ask before assuming it should be fixed.
- **`git commit`/`push` behind current work as of 2026-08-27.** Several rounds of edits (the `ecommerce-seo-auditor` fix + catalog add, the grill-me F1 feature transplant across 3 skills, this handover backfill) are pushed to the *hub* already but sitting uncommitted in the working tree — only `e141c47` (an archive-cleanup commit) has landed since `ca75294`. Hub-push and git-commit are independent triggers in this repo's workflow; don't assume one implies the other.

**Resolved 2026-08-14** (previously listed here as open): CSV corruption in rows `new-joinee`/`skill-finder` — fixed via surgical line-level replacement, only those 2 rows touched. `skill-builder`'s stale catalog `guideContent`/`tryPhrase` (still described the pre-restructure flat layout) — refreshed. The 2 remaining 2026-07-29 sandbox-test findings — `order-status-summary` now has an "In progress (not yet shipped)" bucket; `markdown-document-formatter`'s code-fence fix rule turned out to already exist (fixed 2026-08-03, commit `4747792`, just never recorded — corrected the stale memory). `record-a-skill` → `record-a-skill-custom` rename — executed across all referencing files (skill folder, `CLAUDE.md`, `.gitignore`, CSV, catalog HTML, `first-task-mapper`'s cross-reference). The clickable-question retrofit (previously "23 of 25 pending") also completed this session, via a separate bulk commit. Full account of both: `sessions/2026-08-14.md`.

## Known corrections (memory hygiene)

The auto-memory system occasionally drifts from reality — memories are point-in-time notes, not live state. Corrected on 2026-08-13 while building this handover: `project_sandbox_test_findings_2026-07-29.md` had 2 of its 4 findings marked unfixed when they'd actually been resolved days earlier (2026-08-03) without the memory being updated. **Corrected again on 2026-08-14**: the same memory still listed `markdown-document-formatter`'s code-fence fix rule as open — it too had actually been fixed 2026-08-03 (commit `4747792`, same day as the other two), just never recorded. All 4 original sandbox-test findings are now confirmed fixed and the memory updated accordingly. If something in a memory file looks stale, verify against the actual repo before trusting it — see that memory's own "How to apply" note for the general pattern.

## Newest skill: `ecommerce-seo-auditor` (added 2026-08-27, Skill 026)

Read-only, evidence-led ecommerce SEO audit for a self-hosted store page (Shopify/WooCommerce/custom) or a marketplace listing (Amazon/Etsy/TikTok Shop) — user-added, not built via this repo's Discovery Interview. Never modifies a live site/listing/feed/account/campaign; every finding labeled Confirmed/Data-dependent/Not assessed. Catalogued under a new "SEO & Marketing" workflow group (no existing group was a domain match). Full detail: `sessions/2026-08-27.md` and review-notes §67.

### Previous newest: `new-joiner-guide` (added 2026-08-13, Skill 025)

Distinct from `start`/`new-joinee` — those are generic, role-agnostic onboarding; `new-joiner-guide` is specifically for Mini-AIOS company joiners, operationalizing an external **Mini-AIOS New Joiner Complete Guide** (checked into `.claude/skills/new-joiner-guide/references/` as `.pdf` + `.docx` originals and a validated `.md` transcription). Deliberately not cross-linked to `start`/`new-joinee`. Has two separate install paths on the catalog page: a Claude Code file-install prompt (shared mechanism, same as every other skill) and a second, skill-specific "Chat/Cowork prompt" button — a self-contained paste-into-conversation prompt (embeds `SKILL.md` + the full guide) with a hard save-then-confirm gate before it starts coaching. Full detail: `sessions/2026-08-13.md`, `sessions/2026-08-17.md` (a follow-up skill-builder audit), and review-notes §58–§61, §65–§66.

## Where to look for more

- **`CLAUDE.md`** — authoritative structure/conventions, skill inventory table. Read this before assuming anything about layout.
- **`output/skill-documentation/skill-documentation-review-notes.md`** — the detailed, sequentially-numbered changelog for every catalog/hub edit (currently §1–§68).
- **Auto-memory** (`.claude/projects/.../memory/` on this machine, outside the repo) — durable cross-session notes: user feedback/preferences, project facts, gotchas, reference pointers. `MEMORY.md` there is the index.
- **`sessions/`** in this folder — dated narrative logs, reconstructed from git history + memory for everything before this folder existed, written live from here on.
