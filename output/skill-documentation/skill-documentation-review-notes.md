# Skill Documentation Review Notes — Task-02

## 1. Task Summary

Document every unique, current, user-created Claude Code skill in this repository as a searchable, sortable, responsive HTML reference table (12 named columns), plus these review notes, so any team member can find the right skill, know when/where/how to use it, and understand its inputs/outputs. Deliverables are for review only — not integrated into any documentation hub.

## 2. Repository Root, Branch, Commit

- Workspace / repository root (confirmed via `git rev-parse --show-toplevel`): `C:\Users\LED 269\Desktop\Peries-Skills-Master`
- Branch (confirmed via `git branch --show-current`): `main`
- Commit (confirmed via `git log --oneline -5`): `7690fd4` — "Initial commit" (only commit in the repo)
- `git status` at the time of this task showed `.claude/` and `CLAUDE.md` as **untracked** — i.e. no file inside `.claude/skills/` has ever been committed. There is no per-file Git history available anywhere in this repository.

The prompt's expected repository path (`C:\Users\LED 269\Desktop\PERIES\PERIES-CLAUDE-SKILLS`) and project area (`ClaudeSkillSet/Peries/`) do not exist in this environment and were not created. All paths in this task were adapted to the repository as it actually exists, per explicit user instruction not to alter the existing folder structure or naming.

## 3. Confirmed Project Boundary

Source skills: `.claude/skills/skill-files/*.md` (13 files).
Supporting/reference docs: `.claude/skills/references/*.md` and one `.html` (4 files).
No skill or reference content exists anywhere else in the repository (confirmed by full repository listing and by `CLAUDE.md`'s own skill/reference inventory tables, which match 1:1 with what was found on disk).

## 4. FOLDER_MAP.md Path and Applied Routing

**No `FOLDER_MAP.md` exists anywhere in this repository** (confirmed via a repository-wide glob search). Per the task instructions, this is a documented `BLOCKED — REQUIRED EVIDENCE MISSING` condition for output routing specifically. This was surfaced to the user directly, who provided an explicit routing instruction in place of a `FOLDER_MAP.md`:

> `C:\Users\LED 269\Desktop\Peries-Skills-Master\.claude\skills\outputs`

Per the Evidence Priority order (current task/user instructions rank above `FOLDER_MAP.md`), this explicit user instruction was treated as authoritative and used as the output destination. No `FOLDER_MAP.md` was created — that would be a structural change to the repository beyond this task's scope and was not requested.

## 5. Inventory Count

- 13 candidate skill files inspected — 13 included as unique current skills, 0 excluded, 0 duplicates, 0 archived.
- 3 supporting/reference Markdown docs inspected — 0 included as skill rows (none carry skill frontmatter or are independently invocable).
- 1 supporting HTML file inspected (see §12).
- No additional `SKILL.md` / `SKILL_*.md` files, skill manifests, or archived/superseded skill folders were found anywhere else in the confirmed project boundary.

## 6. Included Skills — ID, Source Path, Reason

| Skill ID | Source path | Reason included |
|---|---|---|
| start | `.claude/skills/skill-files/SKILL_start.md` | Valid skill frontmatter (`name`, `description`); listed in `CLAUDE.md` skill inventory |
| new-joinee | `.claude/skills/skill-files/SKILL_new_joinee.md` | Same |
| skill-builder | `.claude/skills/skill-files/SKILL_skill_builder.md` | Same |
| customer-email-reply-drafter | `.claude/skills/skill-files/SKILL_customer_email_reply_drafter.md` | Same |
| existing-asset-finder | `.claude/skills/skill-files/SKILL_existing_asset_finder.md` | Same |
| first-task-mapper | `.claude/skills/skill-files/SKILL_first_task_mapper.md` | Same |
| markdown-document-formatter | `.claude/skills/skill-files/SKILL_markdown_document_formatter.md` | Same |
| meeting-note-summariser | `.claude/skills/skill-files/SKILL_meeting_note_summariser.md` | Same |
| order-status-summary | `.claude/skills/skill-files/SKILL_order_status_summary.md` | Same |
| order-summary-report | `.claude/skills/skill-files/SKILL_order_summary_report.md` | Same |
| product-description-writer | `.claude/skills/skill-files/SKILL_product_description_writer.md` | Same |
| project-discovery | `.claude/skills/skill-files/SKILL_project_discovery.md` | Same |
| requirements-validator | `.claude/skills/skill-files/SKILL_requirements_validator.md` | Same |

## 7. Excluded Files — Classification and Reason

| File | Classification | Reason excluded |
|---|---|---|
| `.claude/skills/references/reference_skill_builder.md` | Reference/template | Plain Markdown technical reference, no skill frontmatter (`name`/`description`), not independently invocable — supports `skill-builder` only |
| `.claude/skills/references/company-workflow_new_joinee.md` | Reference/template | Same — supports `new-joinee` only |
| `.claude/skills/references/company-workflow_start.md` | Reference/template, orphaned | Same — written for `start`'s model but not linked from any current SKILL file (per `CLAUDE.md`) |
| `.claude/skills/references/glossary_new_joinee.md` | Reference/template, orphaned | Same — onboarding glossary, not linked from any current SKILL file, not itself a skill |
| `.claude/skills/references/skill_documentation_dashboard_preview.html` | Prior art / superseded draft, not a skill | See §12 — a previous Task-02-style attempt with stale data; left untouched, not treated as a skill row |

## 8. Supporting/Reference Documents Used as Evidence

- `CLAUDE.md` (repository root) — authoritative skill inventory, reference-file inventory, and repository-layout/known-issues documentation. Used as a primary evidence source throughout.
- `reference_skill_builder.md`, `company-workflow_new_joinee.md`, `company-workflow_start.md`, `glossary_new_joinee.md` — read in full; used only to corroborate terminology and confirm they are not themselves skills.

## 9. Missing Information, Grouped by Skill

All 13 skills share the same three gaps, for the same repository-wide reason (no metadata field and no Git history exists for any of them — see §2):
- **Created Date** — Needs Confirmation (all 13)
- **Status** — Needs Confirmation (all 13)
- **Version** — Needs Confirmation (all 13)

Skill-specific gaps:
- **new-joinee**: `allowed-tools: Read, Glob, Grep` (no `Write`) conflicts with the skill's own Step 14, which requires writing files to `onboarding-output/`. Enforced behavior is Needs Confirmation.
- **project-discovery**: frontmatter `allowed-tools` includes unrestricted `Bash`, but the skill's own Notes section restricts Bash usage to exactly three `git` commands. Enforced scope is Needs Confirmation.
- **requirements-validator**: no explicit output file path is stated anywhere in the skill file (chat-only output, as far as the source text confirms).

## 10. Conflicts

- **Repository path conflict**: prompt's expected repo path vs. actual repo path — resolved by adapting to the actual, confirmed repository (see §2), per direct user instruction not to alter or assume folder structure.
- **Skill ID format**: the prompt prefers `/skill-name` "only when slash invocation is confirmed." `CLAUDE.md` explicitly states none of these skills are currently discoverable/invocable by Claude Code, because none sit at the required `.claude/skills/<name>/SKILL.md` path. Slash invocation is therefore the *documented design intent*, not a *confirmed working behavior*. **Resolution:** Skill ID uses the bare frontmatter `name` (e.g. `start`, not `/start`); the intended `/name` invocation is described in the "How to Use" column instead, with the discovery-path caveat stated explicitly per row.
- **Prior HTML's data vs. current source files**: see §12 — the previously existing dashboard preview cites source filenames (`SKILL (2).md`, `SKILL (13).md`, etc.) that do not exist in the current repository, and one unverifiable claim (a stated dependency between `requirements-validator` and `existing-asset-finder`) that is not present anywhere in the actual current `SKILL_requirements_validator.md` text. This table was built directly from the current source files instead, per the user's explicit "create fresh from scratch" decision.

## 11. Assumptions

None presented as fact. Where evidence was insufficient (Created Date, Status, Version, and the two tool/behavior conflicts above), the table uses "Needs Confirmation" rather than an assumed value, per the task's evidence rules.

## 12. Duplicate, Archived, or Outdated Skills

No duplicate, archived, or superseded **skill** files were found. One outdated **supporting artifact** was found and is worth flagging to the reviewer:

`.claude/skills/references/skill_documentation_dashboard_preview.html` — an existing, fully-built prior attempt at this same Task-02 deliverable (title: "Claude Skills Library — Task-02"; same 12 columns; working search/filter/sort; the same review-gate sentence; footer dated 2026-07-21). Its embedded data references source filenames from an earlier/different file layout (e.g. `SKILL (2).md`, a "duplicate copy: SKILL (12).md" for `/start`, `SKILL (13).md` for `/new-joinee`, `reference.md` for `/skill-builder`) that do not exist in the current repository, and includes at least one claim not supported by the current source text. Per explicit user decision, this task's deliverables were built fresh from the current `SKILL_*.md` files rather than extending that file, and the old file was left untouched in place. The reviewer may want to decide whether to retire, relabel, or delete it.

## 13. Created-Date Evidence

None available. See §2 — no committed Git history exists for any file under `.claude/skills/`, and no skill file contains a creation-date field. All 13 rows: **Needs Confirmation**.

## 14. Status Evidence

None available. No skill file contains a `status` field, and there is no external tracker/changelog referenced anywhere in the repository. File existence and internal consistency were **not** treated as proof of "Completed," per the task's explicit rule. All 13 rows: **Needs Confirmation**. (Separately, and not conflated with Status: all 13 skills are also known to be non-functional/non-discoverable under the current file layout — see §9 and the "How to Use" column.)

## 15. Version Evidence

None available. No skill file contains a `version` field, and no Git tag or release evidence exists in this repository (single, untracked-at-the-time commit). All 13 rows: **Needs Confirmation**.

## 16. Functional Validation

Performed as static code review/trace-through of the HTML+JS (no browser-automation tool is available in this session to actually launch and click through the page):
- Search: filters on `input`, lower-cases both sides, checks all 12 columns per row — confirmed by reading the filter predicate.
- Status filter: exact match against `Status`, combined with search via logical AND in the same filter pass — confirmed by reading the code.
- Counts: `visible-count` / `stat-visible` are set from the filtered array length on every render — confirmed by reading the code.
- Sorting: implemented for the 5 required columns only (`sortableCols` set); "Needs Confirmation" values are always ranked after confirmed values regardless of ascending/descending, via a dedicated `missing` branch evaluated before the direction flip; ties fall back to original index (stable) — confirmed by reading the comparator.
- Empty state: toggled via a class based on filtered row count — confirmed by reading the code.
- No external `<script src>`/`<link>`/`fetch`/CDN references exist in the file — confirmed by inspection.

**Recommendation:** the reviewer should still open the file directly in a browser and click through search/filter/sort once before relying on it, since this was verified by code inspection rather than live execution.

## 17. Accessibility Validation

Reviewed by inspection against the checklist: labelled `search`/`status-filter` inputs via `<label for>`; sortable headers are real `<button>` elements with visible focus outlines (`:focus-visible`) and `aria-sort` kept in sync; a skip link to the table; `aria-live="polite"` on the results-count row; status shown as text (`status-tag`), not color alone; semantic `<table>/<thead>/<tbody>/<th>/<td>` throughout with `scope="col"`; a visually-hidden `<caption>`; `prefers-reduced-motion` respected. Not verified with an actual screen reader or automated a11y scanner in this session — code-level review only.

## 18. Responsive Validation

Reviewed by inspection: a `@media (max-width: 720px)` breakpoint switches the table to a stacked card layout (`data-label` attributes power `::before` row labels) so all 12 fields remain visible without horizontal table scrolling on narrow viewports; a `@media (max-width: 900px)` breakpoint collapses the two-column toolbar to one column; the desktop/tablet layout uses a horizontally scrollable `.table-scroll` container so no columns are ever hidden. Not verified in an actual browser at the four target widths (1440/1024/768/390px) in this session — code-level review only.

## 19. Sensitive-Data Check

No passwords, API keys, tokens, connection strings, or other credential-like values appear in either deliverable. None were present in the source skill files either — all reviewed skills explicitly instruct against printing raw config/secrets.

## 20. Confirmation Source Skills Were Unchanged

No file under `.claude/skills/skill-files/` or `.claude/skills/references/` was created, edited, renamed, or deleted as part of this task. Only the two new files listed in §24 were written, both under the new `.claude/skills/outputs/` folder.

## 21. Known Limitations

- Created Date, Status, and Version are "Needs Confirmation" for all 13 rows — there is currently no metadata source in this repository that could resolve them, so sorting by those three columns is a no-op beyond the stable original-order tiebreak.
- Functional/accessibility/responsive validation (§16–18) was performed by code review, not live browser execution — no browser-automation tool was available in this session.
- The "Where to Use" column reflects only what each skill file itself states; most task skills do not name a specific team/department, so that column is often general by necessity rather than by omission.
- `Bash` is available as a generic tool in this environment, but per direct user instruction, no exploratory shell commands were run outside the confirmed repository boundary during this task.

## 22. Column Conflict: 13 Mentioned, 12 Defined

The broader task language references a possible 13th column at one point but only formally defines and requires 12. Only the 12 explicitly named columns (Skill ID, Skill Name, Created Date, Purpose, When to Use, Where to Use, How to Use, Input Requirements, Expected Output, Status, Version, Notes) were implemented. No 13th column was invented.

## 23. Filename Conflict: index.html vs. Explicit Filename

The broader task language elsewhere references `index.html`. The explicit filename instruction (`skill-documentation-table.html`) was followed instead, and no duplicate `index.html` was created.

## 24. Changed-File List

Created (new files only — nothing pre-existing was modified):
- `.claude/skills/outputs/skill-documentation-table.html`
- `.claude/skills/outputs/skill-documentation-review-notes.md`

## 25. Final Technical Decision

**PASS — READY FOR REVIEW**, with the limitations in §21 (particularly: browser-level functional/a11y/responsive checks were not physically executed in this session, and Created Date/Status/Version are unresolved for every skill) disclosed rather than hidden.

## 26. Mandatory Review Gate

Not approved for documentation-hub integration until reviewed and confirmed by the designated reviewer.

---

## 27. Task-03 Rebuild (2026-07-23) — `skill-documentation-table-v5.html`

The audit above (§1–26) was performed against the pre-restructure repository layout, when no skill sat at the path Claude Code requires and every row was correctly marked "Needs Confirmation" / "not currently functional." That layout has since been restructured (see `CLAUDE.md`, "Historical note") — all 13 skills now live at `.claude/skills/<name>/SKILL.md` and are confirmed discoverable. This section documents what changed to produce `skill-documentation-table-v5.html`, per explicit user instruction.

**Source data:** `output/skill-documentation/inputs/Skills_documentation_table -Final.csv` (user-modified: `Skill ID` column changed from `Skill_001` style to bare `001`–`013`), superseding the Task-02 audit data as the source of truth for all 12 named columns.

**Skill ID scheme change:** IDs switched from hyphenated skill-folder names (`start`, `new-joinee`, ...) to the CSV's numeric `001`–`013`. This required remapping every internal lookup keyed by the old ID — the `Files` column's per-skill download data, the workflow-group filter mapping, and the "save the file" instruction inside each row's expandable walkthrough panel (previously interpolated the Skill ID directly into a fake path like `.claude/skills/001/SKILL.md`; now uses a separate slug map so that line still points at the real `.claude/skills/<real-folder-name>/SKILL.md` path).

**Created Date / Status / Version:** adopted directly from the CSV as confirmed values (`Testing`, `Version 1.0`, per-row dates) per explicit user decision — no row is marked "Needs Confirmation" anymore. Note this is a change in evidence *policy*, not new proof: no skill file itself gained a status/version frontmatter field: the CSV itself was accepted as the source of truth.

**How to Use column:** stripped the `"(See the install guide below...)"` caveat from all 13 rows — it described a discovery-path problem that no longer exists.

**Notes column:** three rows were corrected because their CSV/v3 text described problems that have since been fixed directly, not just documented:
- **skill-builder (003):** CSV/v3 both said the `reference.md` link doesn't resolve. False as of this restructure — the file now lives at `skill-builder/reference.md`, matching the link. Note corrected.
- **new-joinee (002):** `allowed-tools` now includes `Write` (scoped to `onboarding-output/` only via the skill's own Guardrails — `allowed-tools` frontmatter has no per-path Write syntax, confirmed against `skill-builder/reference.md`). Step 14's templates are now inlined in `new-joinee/SKILL.md` itself (mirroring `start`'s existing pattern) instead of linking to a `templates/` folder that never existed. Note updated to reflect both fixes.
- **start (001):** its onboarding output path was standardized from `output/onboarding/` to `onboarding-output/` to match `new-joinee`, per explicit user decision. Note updated accordingly.
- **project-discovery (004):** left unchanged — its Bash-scope inconsistency (frontmatter allows unrestricted Bash; the skill's own text restricts it to three git commands) was not in scope for this rebuild and is still open.

**Files column — deliberately NOT touched**, per explicit user instruction: the embedded `fileContent`/`guideContent`/`guideFilename` for all 13 skills are byte-identical to v3, including the old `SKILL_*.md`-style filenames and install-guide text that describes the now-fixed discovery-path problem. **This is a known, intentional inconsistency:** the Notes column above says some of these problems are fixed, while the Files column's downloadable "install guide" for those same skills still explains how to fix them. Flagging for the reviewer rather than silently reconciling it.

**Direct skill fixes applied** (not just documented — actual `SKILL.md` edits, per explicit user instruction):
- `new-joinee/SKILL.md`: `allowed-tools` gained `Write`; Step 14 now inlines the cheat-sheet and certificate templates directly (no more `templates/` link); Guardrails and Notes sections updated to match.
- `start/SKILL.md`: all `output/onboarding/` references changed to `onboarding-output/` (Steps 9 and 11, File-Writing Safety section).
- `CLAUDE.md`: removed the "Known gap" (templates) and "Separately noted" (output-path mismatch) bullets since both are now resolved; updated the "current/live deliverable" pointer from v3 to v5; updated the onboarding output-path convention example.
- `company-workflow.md`'s relative link inside `new-joinee/SKILL.md` and `reference.md`'s relative link inside `skill-builder/SKILL.md` were checked and found **already correct** (both files exist exactly where their SKILL.md links point) — no change needed there; the CSV's and v3's notes claiming otherwise were stale artifacts of the pre-restructure layout.

**Versioning:** `skill-documentation-table-v3.html` moved to `output/skill-documentation/archive/` unchanged. `v4` was not reused as the new filename — it was already retired in `archive/` per the existing historical note, so the rebuild is `v5`.

**Not verified in this rebuild:** no browser-automation tool was available in this session; the rebuilt HTML was validated by parsing its embedded JSON, confirming every row has a matching `Files` entry, and grepping for stale text outside the (intentionally frozen) Files data block. The reviewer should still open `v5.html` in a browser and click through search/filter/sort/expand once before relying on it.

## 28. In-Place Update (2026-07-24) — `start` refresh + `grill-me` added

Two skills changed today: `start/SKILL.md` gained real new behavior (Step 0 prior-progress/completion detection, all comprehension check-ins converted from free-text to AskUserQuestion multiple-choice, unlisted-role fallback, a dual local-file/published-link interactive visual, and a new pause/resume mechanism via `onboarding-output/onboarding-progress.md`); and a brand-new skill, `grill-me` (a general-purpose plan/design interrogation skill), was created. `v5.html` (edited in place, no v6 — same pattern used to add `skill-finder`) and the source CSV were updated to reflect both, scoped narrowly per explicit user decision: only rows `001` and the new `015` were touched, nothing else was re-audited.

**Row 001 (start) — Notes column corrected** to describe the click-based check-ins and the new pause/resume behavior.

**Row 001 (start) — Files entry refreshed**, breaking from the v3→v5 freeze policy for this one row: `fileContent` now reads live from `.claude/skills/start/SKILL.md` (byte-identical, verified programmatically) instead of the stale pre-restructure copy; `guideContent` was rewritten from the old "this repo's skills aren't discoverable yet" framing (accurate pre-restructure, false since) to the current install/trigger/usage reality, matching the style already used for `skill-finder` (014)'s guide.

**Row 015 (grill-me) — added**, positioned alphabetically in the array between `first-task-mapper` (006) and `markdown-document-formatter` (008) so it sorts correctly under the page's default "workflow skills first, then task skills A–Z" order (array order *is* the default sort — confirmed by reading `render()`, which only sorts when a `sortField` is set). Workflow group: **Planning & Building Skills** (with skill-builder, first-task-mapper, skill-finder). Full Files treatment given (filename, fileContent, guideFilename, guideContent, tryPhrase), matching the skill-finder precedent.

**Stat/footer text**: "Skills catalogued" / "Currently shown" / "Currently discoverable" bumped 14→15 (the first two are also JS-computed from `data.length` at load, so this was belt-and-suspenders); footer "Last updated" bumped to 2026-07-24.

**CSV (`inputs/Skills_documentation_table -Final.csv`) — known pre-existing staleness surfaced, not fixed:** the CSV was found to already lag the HTML independently of today's changes — e.g. row 001 still carried the pre-v5-rebuild "See the install guide below" caveat and the old `output/onboarding/` path, text the HTML corrected back on 2026-07-23 (see §27) but that correction was never propagated to the CSV. Per explicit user decision, only row 001 was brought in line with the current (corrected) HTML text and row 015 was appended; rows 002, 003, and any other rows with similar pre-existing staleness were **not** touched this round and remain a known, flagged gap for a future full CSV resync.

**Execution method:** both JSON blocks in `v5.html` (`skill-data`, `skill-files-data`) are single-line, tens-of-thousands-of-tokens each — too large/risky to hand-edit with find/replace. A one-off Node script (scratchpad only, not committed to the repo) parsed the HTML, patched both blocks programmatically, and rewrote the file; a second script did the same for the CSV via a small hand-written RFC4180 parser/writer. Verified before and after: both JSON blocks still parse; `Skill ID`s match 1:1 between `skill-data` and `skill-files-data` with no duplicates; `start`'s and `grill-me`'s `fileContent` are byte-identical to the real files on disk; every other row/entry in both the HTML and the CSV is byte-identical to its pre-edit state (diffed programmatically, not by inspection).

**Not pushed to the hub:** per standing project rule, local-only — `push_to_hub.js` was not run.

## 29. In-Place Update (2026-07-24, same day) — two skills missing entirely

After §28's update, the user asked to update the catalog again. A disk-vs-catalog diff (`.claude/skills/*` directories vs. `skill-data`'s `Skill Name` values) found **two** skill folders with no row at all — not just stale content: `evidence-pack-builder` (built earlier the same session, simply never added) and `mcp-access-guide` (a pre-existing skill in `.claude/skills/` that had apparently never been catalogued at any point — not created in this session, no git history available to date it precisely).

**Row 016 (evidence-pack-builder) — added.** Workflow group: **Review & Quality Checks** (with existing-asset-finder, markdown-document-formatter, requirements-validator) — chosen for its auditable/verifiable-record purpose over "Planning & Building Skills" or "Data & Reporting". Positioned alphabetically between `customer-email-reply-drafter` and `existing-asset-finder`. Full Files treatment (filename, fileContent, guideFilename, guideContent, tryPhrase), `fileContent` verified byte-identical to `.claude/skills/evidence-pack-builder/SKILL.md`.

**Row 017 (mcp-access-guide) — added.** Workflow group: **Getting Started** (with start, new-joinee, project-discovery) — it's explicitly a beginner-teaching/orientation skill. Positioned alphabetically between `markdown-document-formatter` and `meeting-note-summariser`. Full Files treatment, `fileContent` verified byte-identical to `.claude/skills/mcp-access-guide/SKILL.md`. **Created Date evidence note:** unlike every other row (confirmed via CSV or same-session creation), this skill's `2026/07/24` Created Date rests only on the file's on-disk modification time (`2026-07-24 12:44`) — this repository has no git history for any file under `.claude/skills/` (see §2) and no frontmatter date field, so this is the weakest evidence basis of any row in the table. Flagged here rather than silently treated as equally confirmed.

**Stat/footer text:** "Skills catalogued" / "Currently shown" / "Currently discoverable" bumped 15→17. Footer date unchanged (still 2026-07-24, same day as §28).

**CSV:** both rows appended (16→18 total lines including header), using the same corrected-column values as the HTML. No other rows touched.

**Execution and verification:** same method and rigor as §28 — one-off scratchpad Node scripts (not committed), verified via JSON.parse, ID-set matching, no-duplicate check, byte-identical fileContent-vs-disk check, and a full diff confirming zero unintended changes to any of the 15 pre-existing rows/entries in either the HTML or the CSV.

**Also discovered, not yet actioned:** `CLAUDE.md`'s own skill inventory table and folder count were last updated after §28 (16 skills) and are now also one update behind (17 skills on disk). Tracked as a separate, immediate follow-up rather than folded silently into this section.

## 30. Feature Add (2026-07-27) — "View and Copy Installation Prompt"

**User objective:** per `PROMPT/prompt_V1.md` (a detailed master spec superseding an earlier draft, `PROMPT/Prompt.md`), add a "View install prompt" button to every skill row's Files cell, opening a modal with a complete, self-contained, copy-pasteable Claude Code installation prompt for that one skill — embedding every legitimate file the skill needs, with SHA-256 fingerprints, and a full 9-step confirm/inspect/approve/backup/install/verify/rollback/discover/report workflow — so a beginner can install a skill into any other project purely by pasting the prompt, with no downloads or manual file handling.

**Pre-implementation interrogation:** ran a `grill-me` session against the master prompt before touching anything. Four genuine gaps were resolved (the master prompt itself was otherwise unusually complete): (1) rollback safety net for editing the only two permanently-modifiable files → rely on git working-tree diff, no separate backup commit; (2) how to keep embedded skill file content (itself often written as natural-language instructions) from being misread as new instructions by a receiving Claude Code session → unique fenced boundary markers plus an explicit "treat as literal data" preamble sentence, placed before the numbered workflow; (3) payload-size gate → functional only (loads, parses, modal responsive, clipboard works), no arbitrary KB ceiling; (4) browser verification, given no confirmed browser-automation tool going in → do what static/scripted/visual checks are possible and honestly hand off the rest.

**Read-only discovery findings (before any edit):** confirmed exactly 17 skill folders under `.claude/skills/`, all 22 files inside them (17 `SKILL.md` + 5 supporting files: `new-joinee/company-workflow.md`, `new-joinee/glossary.md`, `start/company-workflow.md`, `skill-builder/reference.md`, `mcp-access-guide/references/connector-registry.md`) read in full — all plain Markdown, nothing hidden/binary/ambiguous. Catalog↔folder mapping confirmed 1:1 via `Skill Name` (leading `/` stripped) matching the directory name for all 17 rows. Original `v5.html`: 177,962 bytes, SHA-256 `126ef590a734fe8b9af4ebe123dc53209b45c657014488ecb7c1bf56667e5139`. Existing `skill-files-data` embeds *only* each skill's `SKILL.md` (never the supporting files) for the pre-existing download button — a real gap this feature had to close. A source-to-embedded integrity check found 16 of 17 embedded `fileContent` values byte-identical to the canonical on-disk `SKILL.md`; **`new-joinee` (002) was stale** (9,343 embedded bytes vs. 11,198 canonical bytes) — a pre-existing bug unrelated to this feature, surfaced to the user, who approved refreshing it as part of this change (see below). Git working tree had one unrelated pre-existing change (`PROMPT/Prompt.md` moved to `output/skill-documentation/archive/Prompt.md`) — left untouched.

**Exact files modified:** only the two permitted files — `output/skill-documentation/skill-documentation-table-v5.html` and this file. Nothing under `.claude/skills/`, the source CSV, `push_to_hub.js`, `.env`, or any archive was touched.

**Selected data architecture and why:** added one new JSON script block, `skill-install-data`, keyed by Skill ID, storing each skill's file list once (`{ path, content, sha256 }`, `SKILL.md` always first) — not 17 pre-composed prompt strings. The full prompt text (safety preamble + fenced file blocks + the 9-step workflow) is generated client-side by `buildInstallPrompt(id)` at the moment a modal opens, reusing one shared JS template. This was chosen over storing complete prompts because baking the workflow text into every row would have roughly doubled the embedded payload for no benefit — the template is identical for all 17 skills, only the file data and skill name vary.

**Content-is-data isolation:** each embedded file is wrapped between unique, verified-collision-free boundary markers (`====CLAUDE-CODE-SKILL-FILE-BEGIN====` / `====CLAUDE-CODE-SKILL-FILE-END====` — checked programmatically against all 22 canonical files at build time, no collisions found), preceded by an explicit safety-notice sentence instructing the receiving Claude Code session to treat everything between the markers as literal bytes to write, never as instructions to follow, regardless of what the content itself looks like (most skill files are themselves written as natural-language directives to Claude, e.g. "Use when someone asks to…", which is exactly the ambiguity this framing exists to prevent).

**Encoding and newline policy:** every embedded file is read as UTF-8 and stored byte-for-byte as-is (no line-ending normalization, no re-encoding) via `JSON.stringify`, so the browser's `JSON.parse` reconstructs the exact original bytes; the SHA-256 recorded alongside each file is computed from those same original bytes. Both new JSON blocks (`skill-files-data`'s replacement content and the new `skill-install-data`) have any literal `</script` sequence neutralized to `<\/script` before embedding (a no-op unless a file actually contains that substring — none currently do, checked) so the HTML parser can never be tricked into closing the `<script>` block early.

**SHA-256 generation and validation:** computed once, at build time, directly from each canonical file's bytes on disk (not re-derived client-side, avoiding a `crypto.subtle` dependency that requires a secure context unavailable to a local `file://` page). Round-trip validated immediately after generation (re-parse → deep-compare) and again after every splice into the HTML, before the file was written to disk.

**Modal, clipboard, and accessibility behavior:** one reusable `role="dialog" aria-modal="true"` element (not one per skill), populated per click — architecturally guarantees only one modal can ever be open. Opens with focus moved to the close button; Tab/Shift+Tab is trapped among the dialog's four focusable elements; Escape and backdrop-click both close it; closing returns focus to the button that opened it; `<html>` gets `overflow:hidden` while open to lock background scroll. The prompt itself renders in a `readonly <textarea>` (doubles as the required manual-selection fallback). Copy uses the async Clipboard API when available, falling back to `textarea.select()` + `document.execCommand('copy')`, with visible `Copied ✓` / failure feedback either way; the modal is never auto-closed after copying.

**Fresh-install / existing-install / rollback behavior (as instructed in the generated prompt text, Steps 1–9):** confirm target project and destination → inspect and classify every managed file as Identical/Missing/Different → if all identical, report "Already installed — PASS" with zero writes → otherwise request explicit clickable approval (a different wording for fresh vs. replace) → for a replace, back up the complete existing folder to a fresh `.claude/skills-backups/<name>-<timestamp>/` before touching anything, never overwriting a prior backup, always preserving any extra local files not managed by the catalog → write all managed files → verify every file's SHA-256 and, for `SKILL.md`, its frontmatter structurally → on any failure, automatically roll back (restore from backup for a replace; remove only this run's partial files/empty dirs for a fresh install) and report "FAIL — rolled back", never "PASS" → check skill discovery and report "Installation PASS" or "…— session refresh required" → finish with a beginner-facing report and an explicit, non-automatic offer to run the newly installed skill.

**Payload-size comparison:** 177,962 → 333,410 bytes (**+155,448 bytes, +87.3%**). No hard ceiling was set (per the resolved grill-me decision) — the gate is functional, and every functional check below passed. Total embedded managed files: 22 across all 17 skills (94,168 canonical bytes of `SKILL.md` content + 36,020 bytes across the 5 supporting files).

**Programmatic completeness/integrity results:** a build script (scratch-only, not committed) asserted every anchor point matched exactly once before splicing, then re-parsed the fully-spliced output and confirmed: `skill-files-data` and `skill-install-data` both still parse and both contain exactly 17 entries; `new-joinee`'s refreshed `fileContent` matches the canonical file; script-tag counts stay balanced; the button template appears exactly once in the JS source (it renders per-row at runtime, not baked in 17 times). A second, independent verification script (also scratch-only) recomputed SHA-256 for all 22 canonical files directly from disk and confirmed every embedded hash and byte count matches exactly.

**Browser test results (real headless-Chrome runs, not simulated):** loaded the actual `v5.html` in headless Chrome twice — zero console/JS errors (`Uncaught`/`SyntaxError`/`TypeError`/`ReferenceError`) either time. A DOM-level check on a disposable copy confirmed exactly 17 install buttons with 17 unique `data-id`s, 17 expand buttons, 34 download buttons (unchanged), and exactly one modal element, hidden by default. A second disposable copy simulated real clicks: opened the modal for `start`, `new-joinee`, and `mcp-access-guide`, confirming correct title, correct destination path, the safety notice, STEP 1 and STEP 9 both present, and matched (non-truncated) boundary-marker counts for each skill's actual file count. Cross-contamination check: `start`'s generated prompt contains zero mention of `mcp-access-guide`'s path and vice versa. Escape-to-close confirmed. The Copy button ran without throwing and correctly displayed the failure-feedback message — expected in headless Chrome, which has no OS clipboard access and blocks the Clipboard API on `file://` (an insecure context); this validates the failure-feedback path but not the real clipboard-success path. Two screenshots (default table view, and the modal open for `start`) were visually inspected and confirmed correct: the new button renders consistently with the two existing download buttons, and the open modal shows correct title/instructions/content/buttons/focus ring.

**Disposable installation-simulation results (Section 18, against a real temp directory outside the repo, not `.claude/skills/`):** all five scenarios passed exactly as expected — (1) fresh install of a single-file skill (`first-task-mapper`): correctly detected Missing beforehand, wrote the file, SHA-256 verified; (2) re-inspecting that same skill correctly detected Identical, with no file rewritten (mtime unchanged); (3) fresh install of a multi-file skill with a nested path (`mcp-access-guide`, `references/connector-registry.md`): nested directory created correctly, both files verified; (4) simulated local drift on an installed skill correctly detected as Different, backed up to a timestamped path before replacing, and an extra untracked local file was preserved through the backup and the replace; (5) a simulated corrupted write was correctly detected via SHA-256 mismatch and automatically rolled back from the backup, with the restoration re-verified. The temp project was deleted afterward. Caveat: this simulation is the file-operations described in Steps 2/4/5/6/7 executed literally against the real embedded data by a scratch script — it demonstrates the underlying data and logic are internally correct, but it is not a literal separate live Claude Code session following the copied prompt's natural-language text end-to-end; that remains a manual check (see Limitations).

**Existing-feature regression results:** all pre-existing behavior confirmed unchanged in the same headless-Chrome runs — 34 download buttons (Skill file + Install guide, one pair per skill), 17 walkthrough expand buttons, search/filter/sort inputs and their event bindings, table structure, and every unrelated embedded row/field. No skill description, ID, date, status, version, row order, page title, heading, theme, download filename, install-guide content, walkthrough content, or CSV content was changed.

**Limitations (disclosed, not hidden):**
- No literal, separate live Claude Code session executed a copied prompt end-to-end against a real fresh project — the closest available evidence is the scripted file-operations simulation above (Section 18) plus the headless-Chrome content/behavior checks (Section 17). The reviewer should still paste at least one generated prompt into a real Claude Code session pointed at a scratch project before fully trusting the feature.
- Real OS-level clipboard copy success (the Clipboard API path, and the `execCommand` fallback actually reaching the system clipboard) was not verified — headless Chrome's `file://`/no-permission environment only exercised the failure-feedback branch. Needs a manual click in a real browser.
- Focus-trap Tab/Shift-Tab cycling and backdrop-click-to-close were implemented per spec but not driven by simulated keyboard/mouse events in this session (Escape-to-close and focus-return *were* verified this way). Needs manual keyboard testing.
- Narrow/mobile viewport layout was not visually checked at a small width in this session.
- The pre-existing, unrelated CSV staleness noted in §28/§29 remains open and untouched, as before.

**Confirmations:**
- No secrets, credentials, tokens, or `.env` content were read, displayed, or embedded anywhere in this change.
- `.claude/skills/` was not modified — every file under it was only read.
- `inputs/Skills_documentation_table -Final.csv` was not modified.
- **Not published (at time of writing).** `push_to_hub.js` was not run. Per the master prompt's publishing gate, this requires a separate, explicit approval after the reviewer has seen this local report — see the completion report presented in-chat for the PASS/FAIL verdict and the publish question.

**Not pushed to the hub (at time of writing):** local-only, same as §28.

## 31. Publish (2026-07-27, same day)

Following the external installation test (see `PROMPT/SKILL_INSTALLATION_TEST_REPORT.md`, corrected the same day — the 8 flagged sha256 "mismatches" were traced to a stale browser tab in the test session, not a defect in this feature's data or code) and the reviewer's explicit go-ahead, `push_to_hub.js` was run:

```
node --env-file=.env push_to_hub.js "skill-documentation-table-v5.html" "skill-catalog" "Peries Skill Catalog — Claude Code Skills Reference"
```

Pushed successfully — `hub_pages` id=4, `updated_at` 2026-07-27T08:29:00.729Z. The 17-skill catalog including the "View and Copy Installation Prompt" feature (§30) is now live on the Vercel-facing hub. No local changes remain unpushed as of this entry.

## 32. Skill Add (2026-07-27, same day) — `task-closure` (18th skill)

A new skill, `task-closure`, was built via `skill-builder`'s Discovery Interview (verifies whether a task is genuinely ready to close — nine dimensions checked against real evidence, with requirement-level traceability, an evidence-freshness rule, classified temporary-file handling, an explicit verdict-precedence order, and a final decision-quality gate before returning exactly one of COMPLETE / COMPLETE WITH LIMITATIONS / REVIEW REQUIRED / BLOCKED / INCOMPLETE) and synced into the catalog as row **018**, positioned last.

**Files changed this round:** `output/skill-documentation/skill-documentation-table-v5.html`, `output/skill-documentation/inputs/Skills_documentation_table -Final.csv`, plus `.claude/skills/task-closure/SKILL.md` (new) and `CLAUDE.md` (inventory bumped 17→18) as separate, direct skill-authoring changes outside the catalog itself.

**Row 018 added** with full Files treatment (`filename`, `fileContent`, `guideFilename`, `guideContent`, `tryPhrase`) and a new `skill-install-data` entry (single file, `SKILL.md`, sha256 `9e0dab128d080b97a106258de815f1456bd72f95c3aabefaf00e6f6c8ecc4141`), matching the pattern used for every prior addition (§28/§29). Workflow group: **Review & Quality Checks** (with existing-asset-finder, markdown-document-formatter, requirements-validator, evidence-pack-builder) — it's a verification/review skill by nature. `fileContent` verified byte-identical to `.claude/skills/task-closure/SKILL.md` (11,150 bytes) both immediately after the splice and via a real headless-Chrome click-through.

**Stat/footer text:** "Skills catalogued" / "Currently shown" (JS-computed from `data.length`, automatic) and the static "Currently discoverable" figure bumped 17→18. Footer "Last updated" bumped to 2026-07-27.

**CSV:** row 018 appended (19 total lines including header) using the same corrected-column style as prior rows. No other rows touched.

**Payload change:** `v5.html` grew from 333,410 to 360,424 bytes (+27,014 bytes, +8.1%) — one skill's worth of `SKILL.md` content plus its catalog/guide/install-prompt data. No functional issues found (see verification below).

**Execution and verification:** a scratch build script (not committed) asserted the pre-sync state was exactly 17 entries everywhere before touching anything, appended the new row/entries to all three data structures plus the `skillGroups` JS mapping, re-serialized with the same `</script`-safety escaping used throughout, and verified post-splice: 18/18/18 entries across `skill-data`/`skill-files-data`/`skill-install-data`, the full 001–018 Skill ID set present with nothing missing or duplicated, and 018's embedded content/hash matching the real file on disk exactly. A real headless-Chrome run then confirmed 18 rendered rows, 18 install buttons, and — critically — clicked the actual "View install prompt" button for 018 and verified the resulting modal opens with the correct title, destination path, and full STEP 1–9 workflow text, with zero console errors.

**Not pushed to the hub.** Per explicit user instruction ("let know before push hub i will confirm it"), this sync is local-only until separately approved.

## 33. Skill Add (2026-07-27, same day) — `claude-code-basics` (19th skill)

A new skill, `claude-code-basics`, was built via `skill-builder`'s Discovery Interview — an interactive, slash-command-only lesson in the physical mechanics of VS Code + Claude Code (opening a folder, Explorer, paths, panel, slash commands, prompts, terminal, tool results, and the real permission/edit-approval UI), deliberately complementary to (not overlapping with) `start`/`new-joinee`'s conceptual architecture teaching. Synced into the catalog as row **019**, positioned last.

**Design highlights, per explicit user refinement of the initial discovery summary:** `allowed-tools` deliberately excludes `Write` and `Edit` — every file operation in the lesson (creating and editing a practice file in Topic 9) is a genuinely unapproved tool call, so the learner experiences the real permission/diff prompt rather than a simulation. `Write`/`Edit` are scoped in the skill's own instructions to exactly three paths (`onboarding-output/claude-code-basics-practice.txt`, `-progress.md`, `-cheat-sheet.md`) and never elsewhere. No delete capability exists anywhere in `allowed-tools`, so the skill explicitly tells the learner how to remove the practice file themselves rather than ever claiming to do it automatically. Non-Git folders and version-dependent UI labels are both handled as normal, non-error states. Every topic offers Continue/Repeat/Show-example/Pause/Stop, and a topic is never marked Passed without an actually-passed comprehension check (one supportive corrective retry allowed).

**Files changed this round:** `output/skill-documentation/skill-documentation-table-v5.html`, `output/skill-documentation/inputs/Skills_documentation_table -Final.csv`, plus `.claude/skills/claude-code-basics/SKILL.md` (new, 88 lines) and `CLAUDE.md` (inventory bumped 18→19) as separate, direct skill-authoring changes outside the catalog itself.

**Row 019 added** with full Files treatment and a new `skill-install-data` entry (single file, `SKILL.md`, sha256 `a4ffdb11f50dc32b72c1b8102a9b8eedc42842e9fabd4ce8bf6086a27509011d`), matching the pattern used for every prior addition. Workflow group: **Getting Started** (with start, new-joinee, project-discovery, mcp-access-guide) — it's an onboarding/orientation skill. `fileContent` verified byte-identical to the real file (11,096 bytes) both post-splice and via a real headless-Chrome click-through of the install-prompt modal.

**Testing note:** because `disable-model-invocation: true` also blocks Claude's own `Skill` tool (confirmed live — attempting to invoke it returned "Skill claude-code-basics cannot be used with Skill tool due to disable-model-invocation"), this skill's actual interactive lesson flow could not be self-tested in this session. Only structural correctness (frontmatter, file-path consistency, checklist compliance) was verified. The reviewer should run `/claude-code-basics` directly at least once, especially Topic 9's live permission/diff prompts, before treating it as fully validated.

**Stat/footer text:** "Currently discoverable" bumped 18→19. Footer date unchanged (already 2026-07-27 from §32).

**CSV:** row 019 appended (20 total lines including header). No other rows touched.

**Payload change:** `v5.html` grew from 360,424 to 387,306 bytes (+26,882 bytes, +7.5%).

**Execution and verification:** same scratch-build-script method as §32 — asserted exactly 18 entries existed everywhere before touching anything, verified 19/19/19 after with the full 001–019 ID set present and nothing duplicated, and confirmed 019's embedded content/hash matches the real file exactly. A real headless-Chrome run confirmed 19 rendered rows, 19 install buttons, and a successful click-through of row 019's install prompt with zero console errors.

## 34. Skill Add (2026-07-28) — `daily-work-tracker` (20th skill)

A new skill, `daily-work-tracker`, was built via `skill-builder`'s Discovery Interview, then run through two full `grill-me` interrogation passes before any file was touched — one over the skill design itself (reconciling a user-pasted, more elaborate SKILL.md draft against the discovery-interview version: resolved the admin-identity "authorization" language down to an honest self-attestation + audit-log control since Claude Code has no identity backend, split storage between the repo's `output/` convention and ephemeral local-AppData markers, deferred the entire reminder/Scheduled-Task/toast-notification subsystem to a documented future phase), and a second pass over this catalog update itself (install-package file scope, field authorship, `tryPhrase` wording). Synced into the catalog as row **020**, positioned last.

**Design highlights:** this is the first skill in the repo with executable code — three PowerShell helper scripts (`scripts/start-tracker.ps1`, `check-completion.ps1`, `update-employee-config.ps1`) for deterministic marker/config state, all parse-checked and functionally smoke-tested (config detection, marker read/write, identity-correction success/failure paths) in the scratchpad before being added to the skill. `admin-update-identity` is explicitly documented as non-enforcing. Reminder automation (Scheduled Task, toast notifications) is a documented "Deferred" section in the SKILL.md, not implemented.

**Files changed this round:** `output/skill-documentation/skill-documentation-table-v5.html`, `output/skill-documentation/inputs/Skills_documentation_table -Final.csv`, plus the new `.claude/skills/daily-work-tracker/` folder (`SKILL.md`, `references/policy.md`, two `assets/` files, three `scripts/*.ps1`) and `CLAUDE.md` (inventory bumped 19→20) as separate, direct skill-authoring changes outside the catalog itself.

**Row 020 added** with full Files treatment and a new `skill-install-data` entry — unlike every prior multi-file skill (e.g. `mcp-access-guide`, which only got `SKILL.md` in its install package despite having a supporting reference file), this one includes **all 7 files** by explicit decision, since the skill's own workflow calls the three scripts directly and would be non-functional without them. `tryPhrase` follows the now-confirmed catalog convention (the full SKILL.md description clause, not a short phrase — corrected mid-session after initially assuming otherwise). **New workflow group added:** "Workflow & Records" — none of the 5 existing groups (Getting Started, Data & Reporting, Writing & Content, Review & Quality Checks, Planning & Building Skills) fit a record-keeping/automation skill; the `group-filter` dropdown option and the `skillGroups` JS mapping were both updated (this mapping was missed on the first pass and caught/fixed before sign-off).

**Stat/footer text:** "Currently discoverable" and `stat-total`'s static fallback both bumped 19→20. Footer date bumped 2026-07-27→2026-07-28.

**CSV:** row 020 appended (21 total lines including header) with the `Files` column left blank, matching the dominant existing convention (18 of the prior 19 rows also leave it blank). No other rows touched. Note: while inspecting the CSV, row 014 (`skill-finder`) was confirmed to still have its pre-existing unescaped-comma corruption (an extra split in the "How to Use"/"Input Requirements" fields, shifting everything after) — left alone per explicit user scope decision, same as prior rounds.

**Payload change:** `v5.html` grew from 387,306 to 416,397 bytes before the group-mapping fix (+29,091 bytes, +7.5%); the two-line group addition after that is negligible.

**Execution and verification:** a scratch build script (not committed) asserted exactly 19 entries existed everywhere before touching anything, appended the new row/entries to `skill-data`/`skill-files-data`/`skill-install-data`, and verified post-splice: 20/20/20 entries across all three, the full 001–020 ID set present with nothing missing or duplicated, and all 7 of row 020's embedded files byte-identical to the real files on disk (via direct string equality, not just hashes). CSV re-parsed to confirm 21 total lines, correct last row, and no stray-comma corruption in the new row specifically. A semantic diff against the pre-edit (git `HEAD`) version of both files confirmed the change was purely additive — all 19 pre-existing `skill-data`/`skill-files-data`/`skill-install-data` entries and all 20 pre-existing CSV rows byte-identical to before.

**Testing gap (disclosed):** no headless-Chrome click-through was performed this round (no Puppeteer/Playwright installed in this project, and installing one wasn't in scope without asking first) — unlike §32/§33's real-browser verification. Only structural/programmatic verification was done. The reviewer should manually open row 020's "View install prompt" modal at least once and confirm no console errors before treating this as fully validated.

**Not pushed to the hub as part of this round.** Per standing convention, hub publication is a separate, explicitly-triggered action ("push hub") — not bundled into this update.

**Pushed on 2026-07-28 07:03:39 UTC** (hub_pages id=4, same slug) — triggered separately via "push hub". Live was at 19 skills (last pushed 2026-07-27 10:53 UTC, already including `task-closure`/`claude-code-basics`); local was at 20. Diff-checked via a scratch read-only script comparing `skill-data` array length and full content sha256 between live and local before pushing — confirmed genuinely out of sync (19 vs 20), not a stale-comparison false alarm. No local changes remain unpushed as of this push.

## 35. Data-Integrity Fix (2026-07-28, same day) — `skill-install-data` resync, driven by an install-prompt export task

**Trigger:** the user asked to extract every skill's "View and Copy Installation Prompt" text out of `v5.html` and save each as a standalone `<skill_name>_installation_prompt.txt` file under a new `output/skill-documentation/skills-prompt-test/` folder, for manual paste-and-install testing. Before generating those 20 files, a disk-vs-embedded freshness check (agreed with the user up front, given the prior stale-tab incident referenced in §31) was run against `skill-install-data` for all 20 entries.

**Findings — three of the 20 entries were wrong, not just old:**
- **`daily-work-tracker` (020), all 7 files:** every file object was missing the `sha256` key entirely. §34's own verification claimed "byte-identical... via direct string equality, not just hashes" for content, which was true, but the separate `sha256` field itself was simply never written. The live modal for this skill would have rendered `sha256: undefined` for all 7 files.
- **`evidence-pack-builder` (016):** the embedded `SKILL.md` was stale — missing an entire step (a "Confirm Before Writing" gate before the final write) and missing two frontmatter fields (`disable-model-invocation`, `allowed-tools`) present in the real file. The same staleness was independently confirmed in `skill-files-data` (the plain download button), which embeds the same file separately.
- **`claude-code-basics` (019):** the embedded `SKILL.md` still had the pre-fix topic-controls menu (5 AskUserQuestion options, exceeding its 4-option limit) that commit `f47d686` already corrected on disk. Same staleness independently confirmed in `skill-files-data`.

All other 17 entries' hashes and content matched disk exactly.

**Repair method, and an error along the way (disclosed in full):** the first fix attempt patched only the 3 affected entries using `String.prototype.replace(regex, templateLiteralString)`. This corrupted the `skill-install-data` JSON block — `.replace()` interprets `$1`, `$&`, and similar sequences in a *string* replacement argument as special patterns, and the embedded content (a PowerShell/Markdown corpus almost certainly containing literal `$`-prefixed text, e.g. dollar amounts or PowerShell variables) triggered unintended substitutions that broke the JSON. The same faulty pattern was used on `skill-files-data` in the same pass but happened not to trigger any special sequence there, so that block parsed fine; `skill-install-data` did not. The break was caught immediately by a post-write `JSON.parse` check, before any downstream use — no corrupted content ever reached `skills-prompt-test/` or the hub.

**Actual fix:** rebuilt `skill-install-data` from scratch for all 20 entries (not just the 3), reading every file directly from `.claude/skills/<name>/...` on disk with the file-inclusion set already established per skill (single `SKILL.md` for 15 skills; `SKILL.md` plus supporting files for `start`, `new-joinee`, `skill-builder`, `mcp-access-guide`, `daily-work-tracker`), computing `sha256` fresh, and splicing the new JSON back into the HTML by string index (`indexOf`/`slice`) rather than `.replace()`, which removes the `$`-pattern hazard entirely. `skill-files-data`'s `fileContent` for the 2 stale entries was refreshed the same way.

**Verification:** re-parsed all three embedded JSON blocks (`skill-data`, `skill-files-data`, `skill-install-data`) after the fix — all valid. For every one of the 20 `skill-install-data` entries, each file's `content` and freshly-computed `sha256` were compared by direct string/hash equality against the real file on disk — all 20 matched. Confirmed the pre-existing, still-uncommitted §34 changes (stat counts at 20, the "Workflow & Records" group option, footer date 2026-07-28) were untouched by this fix. Re-ran the extraction script against the corrected HTML: all 20 `<skill_name>_installation_prompt.txt` files written to `output/skill-documentation/skills-prompt-test/`, and spot-checked that `daily-work-tracker`'s prompt no longer contains `sha256: undefined` and that `claude-code-basics`'s prompt now shows the corrected 4-option menu text.

**Root cause, for future rounds:** §34's verification step compared file *content* byte-for-byte but never asserted that a `sha256` key was present on every file object — a gap in the checklist itself, not just an execution slip. `evidence-pack-builder` and `claude-code-basics` went stale because their `.claude/skills/` source files were edited (in the `f47d686` commit, and an undocumented `evidence-pack-builder` edit) after their catalog rows were last synced (§29, §33), with no resync triggered at edit time. Neither failure mode is caught by the existing "assert count N+1, diff against git HEAD for pre-existing rows" method, since both bugs live *inside* rows that were correctly counted and never claimed to have changed.

**Scope note:** only `skill-install-data` (all 20 entries, rebuilt) and `skill-files-data` (`fileContent` for the 2 stale entries only) were touched. `skill-data` (the visible table row content — Purpose/Notes/etc.) was not re-audited this round; a `SKILL.md` frontmatter/behavior change doesn't automatically invalidate its table row, so that remains a separate, not-yet-run check.

**Deliverable:** `output/skill-documentation/skills-prompt-test/<skill_name>_installation_prompt.txt` × 20, generated from the corrected HTML — each is the exact, literal, byte-for-byte output of `buildInstallPrompt()` for that skill, ready to paste into a fresh Claude Code session for a real install test.

**Pushed on 2026-07-28 10:46:20 UTC** (hub_pages id=4, same slug) — triggered separately via "push hub", after §34's earlier same-day push (07:03:39 UTC) had carried all three defects described above live for a few hours. Diff-checked via `mcp__claude_ai_postgres__execute_sql` (byte length + md5 of live `html_content` vs. local file) before pushing — live was 410,631 bytes, local 418,602, confirmed genuinely out of sync. Re-checked after pushing: live md5 now matches the local file's md5 exactly. No local changes remain unpushed as of this push.

## 36.

**Root cause found for the real corruption bug behind the earlier "stale tab" misdiagnosis (§ referenced in `[[project-v5-stale-tab-hash-gotcha]]`):** a user-reported install failure for the `start` skill (pasted into a fresh project via the VS Code Claude Code extension) was reproduced directly — the user pasted the exact clipboard content back into chat, which was hashed and diffed byte-for-byte against the real source file. Every difference was a `\r` insertion/deletion; zero character-content differences. Root cause: this machine's system-wide git config (`C:/Program Files/Git/etc/gitconfig`, the Git-for-Windows default) sets `core.autocrlf=true`, and the repo's `.gitattributes` only had `* text=auto` (no explicit `eol` override), so 8 `SKILL.md` files got CRLF silently injected into the local working copy on checkout even though their git-stored blobs were always LF. The catalog generator had captured that locally-corrupted CRLF content (and hashed it) into `skill-install-data`, so any copy/paste of those 8 skills' install prompts — which normalizes CRLF→LF in transit — deterministically failed sha256 verification. Confirmed the same 8 skills as the original 2026-07-27 test report (`customer-email-reply-drafter`, `markdown-document-formatter`, `meeting-note-summariser`, `order-status-summary`, `order-summary-report`, `product-description-writer`, `requirements-validator`, `start`), strongly suggesting this was the real cause of that report too, not tab staleness.

**Fix (commit `f072a05`):** normalized the 8 files to LF on disk; added `* text eol=lf` to `.gitattributes` so this can't reoccur on any future clone/checkout regardless of a user's local `autocrlf` setting; updated `skill-install-data`'s content/sha256 for the 8 affected entries to the corrected LF version; hardened the install-prompt template (Steps 2, 5, 6 of `buildInstallPrompt()`) to normalize line endings before hash comparison as defense-in-depth; regenerated `output/skill-documentation/skills-prompt-test/` with a static hash/freshness check (all 20 skills, 31 file entries — 100% PASS) plus a typography scan (report-only, found heavy em-dash usage repo-wide but no zero-width/invisible characters). This commit also carried the previously-pending `daily-work-tracker` catalog sync, since it shared the same single-line JSON blob and couldn't be committed separately.

**Pushed on 2026-07-28 11:56:42 UTC** (hub_pages id=4, same slug) — triggered via "push hub". Diff-checked before pushing: live was 412,741 bytes (md5 `b5c56e0e0ba2a544dd211c234935af29`, last updated 16:16 Asia/Colombo, predating this fix), local was 418,086 bytes. Re-checked after pushing: live md5 now `95d1899889fd9930b5eabec7415abe1e`, matching the local file exactly. No local changes remain unpushed as of this push.

## 37.

Added the 21st skill, `record-a-skill` (built and committed earlier this session — evidence-driven workflow-to-skill recorder that hands off to `skill-builder`), to the catalog: `skill-documentation-table-v5.html`'s three JSON blocks (`skill-data`, `skill-files-data`, `skill-install-data`), the separate `skillGroups` JS mapping, and `inputs/Skills_documentation_table -Final.csv`.

**Design decisions (short interrogation before writing, per the standing catalog-sync procedure):**
- **Description-convention fix:** found during drafting that `record-a-skill/SKILL.md`'s frontmatter `description` didn't follow this repo's "Use when someone asks to..." convention (it read as a plain capability statement instead) — functionally harmless since `disable-model-invocation: true` keeps it out of Claude's auto-invocation context, but it broke the mechanical `tryPhrase`-derivation rule and repo-wide consistency. Fixed the description in `SKILL.md` itself before deriving `tryPhrase`, rather than special-casing the derivation.
- **Install-package file scope:** `skill-install-data` includes both `SKILL.md` and `reference.md` (not `SKILL.md` alone), since `reference.md` holds procedural detail (sensitive-content screening layers, the provenance/confidence taxonomy, the `existing-asset-finder`/`skill-builder` handoff schemas, the test/fidelity-gate spec) the skill's own workflow steps link out to and depend on — matches the `daily-work-tracker` precedent (include every file the workflow actually depends on) over the single-file-only precedent (`task-closure`, `grill-me`, etc.).
- **Workflow group:** `Planning & Building Skills` — groups it with its closest functional siblings (`skill-builder`, `skill-finder`, `existing-asset-finder`, `grill-me`) rather than `Workflow & Records` (`daily-work-tracker`'s group), since its core purpose is feeding `skill-builder`, not record-keeping.

**Disk-vs-catalog diff run first** (per the standing "don't assume only the most recent skill is missing" lesson): confirmed `record-a-skill` was the only gap — the pre-existing 20 catalog entries already matched their 20 `.claude/skills/` folders 1:1.

**Verification performed** (script-based, scratchpad, not committed): asserted pre-edit counts (20 in all three JSON blocks + `skillGroups` + CSV data rows) and post-edit counts (21, contiguous ID set `001`–`021`, no duplicates, no key-set drift) in all four structures; compared the new entry's embedded `fileContent`/install-file content against a fresh `fs.readFileSync` of the real `SKILL.md` and `reference.md` on disk by string equality (not just hash); diffed every pre-existing `skill-data`/`skill-files-data`/`skill-install-data`/`skillGroups` entry and every pre-existing CSV line against the pre-edit `git show HEAD:...` version to confirm the change was purely additive (zero mutations); confirmed `stat-total` (cosmetic fallback) and "Currently discoverable" both bumped 20→21, footer date bumped to 2026-07-31, and `stat-visible` deliberately left at its pre-existing stale value of 17 (unrelated, out of scope, per prior rounds). All checks passed. No headless-browser click-through of the new row's install-prompt modal was done this round (no Puppeteer/Playwright installed) — disclosed as a gap, not claimed as done.

**Not pushed to the hub as part of this entry** — local-only sync, per the standing separation between "update skill docs" and "push hub."

## 38.

**Pushed on 2026-07-31 06:16:34 UTC** (hub_pages id=4, same slug) — triggered via "push hub" immediately following §37's sync. Diff-checked before pushing: live was 412,245 bytes (md5 `95d1899889fd9930b5eabec7415abe1e`, updated_at 2026-07-28T11:56:42Z), local was 454,261 bytes (the 21-skill version). No local changes remain unpushed as of this push.

## 39.

Added three new skills, `aios-structure-build` / `aios-structure-organize` / `aios-structure-validate` (added to the repo and audited/committed earlier this session — a portable, hash-manifest-verified scaffolding family for a frozen "AIS-OS starter-kit" baseline: build scaffolds a fresh empty directory with rollback; organize additively repairs an existing project via dry-run→confirm→apply, never touching what already exists; validate is a read-only structural check with one optional consented report write), to the catalog as rows **022–024**, in that build→organize→validate order.

**Design decisions (short interrogation before writing, per the standing catalog-sync procedure):**
- **Description-convention exception:** all three descriptions also don't follow the "Use when someone asks to..." convention (same class of issue as `record-a-skill` in §37), but — unlike `record-a-skill`, which was authored for this repo — these read as a vendored, portable package explicitly designed to "work installed personally or project-locally with no changes." Decided **not** to edit the three `SKILL.md` files this time (reversing the §37 precedent, deliberately): editing a self-contained portable package's source risks diverging from whatever upstream it was copied from, for a purely cosmetic/mechanical-derivation benefit. `tryPhrase` for all three uses each description verbatim (already sentence-cased) as a documented one-off exception instead.
- **Install-package file scope:** all ~17 files per skill (`SKILL.md`, `manifest.json`, one `scripts/*.ps1`, all 14 `templates/**` files including nested `templates/.claude/skills/{onboard,audit,level-up}/SKILL.md` paths) — by far the largest bundle in the catalog (previous max was `daily-work-tracker`'s 7). Not optional: the bundled script's own preflight step hash-verifies every template against `manifest.json` and hard-fails (exit 10) without them, so the full tree is load-bearing per the established "include every file the workflow depends on to function" rule.
- **New workflow group:** `AIOS-Project-Scaffolding` (exact name as specified, deviating from the existing "Word & Word" title-case-with-ampersand group-naming style on explicit instruction) — none of the 6 existing groups fit "scaffold/repair/validate a project's file structure against a frozen baseline," a genuinely different category from skill-building, reporting, writing, or record-keeping. Added to both the `skillGroups` JS mapping and the `group-filter` `<select>`'s hardcoded `<option>` list (the latter is easy to miss — flagged in §36's technical reference and double-checked this round).

**Disk-vs-catalog diff run first:** confirmed exactly these 3 gaps (24 folders vs. 21 catalog rows) — the pre-existing 21 rows already matched their 21 folders 1:1.

**Verification performed** (script-based, scratchpad, not committed) — all checks the user explicitly requested, all passed:
- All 24 catalog entries present, uniquely numbered `001`–`024`, in all three JSON blocks plus `skillGroups`.
- Each new `skill-install-data` bundle contains exactly 17 files, at paths matching the real on-disk tree exactly (including the nested `templates/.claude/skills/...` paths).
- Every one of the 51 bundled files (17 × 3) compared against a fresh `fs.readFileSync` of its real source file using CRLF/CR-normalized SHA-256 hashing (matching the same normalization the skills' own `build.ps1`/`organize.ps1`/`validate.ps1` use for their manifest preflight) — all matched.
- Each `skill-files-data` entry (the single-file download) contains only `SKILL.md`, byte-identical to disk — confirmed separately from the full install bundle.
- All three skills confirmed under group `AIOS-Project-Scaffolding`, in build→organize→validate order (022/023/024).
- All three JSON blocks re-parsed cleanly after the edit.
- Install-prompt completeness confirmed structurally: every bundle includes `manifest.json`, its script, and all 14 templates (i.e. the functionally complete set a real install would need).
- Every pre-existing entry/row (21 in `skill-data`/`skill-files-data`/`skill-install-data`/`skillGroups`, 21 in the CSV) diffed against the pre-edit `git show HEAD:...` version — zero mutations, purely additive.
- `git status --porcelain` after the write touched only the HTML and CSV — no file under `.claude/skills/` was modified by this sync.
- `stat-total` (cosmetic fallback) and "Currently discoverable" both bumped 21→24, footer date to 2026-07-31, `stat-visible` again deliberately left at its pre-existing stale value (unrelated, out of scope, per prior rounds).

No headless-browser click-through of the three new install-prompt modals was done this round (no Puppeteer/Playwright installed) — disclosed as a gap, not claimed as done, consistent with §37 and §34.

**`CLAUDE.md` also updated this round:** skill-folder count bumped 21→24, and three new inventory rows added for the `aios-structure-*` family.

**Not pushed to the hub as part of this entry** — local-only sync, per the standing separation between "update skill docs" and "push hub." Per explicit user instruction this round, nothing was committed or pushed until the verification results above were shown and separately approved.

## 40.

**Pushed on 2026-07-31 06:55:01 UTC** (hub_pages id=4, same slug) — triggered via "push hub" following §39's sync (committed as `5d1a20d`, then pushed to `origin/main`). Diff-checked before pushing: live was 454,261 bytes (md5 `f47ff461df834c9fc4961d82bd358bff`, updated_at 2026-07-31T06:16:34Z, the 21-skill version), local was 736,587 bytes (the 24-skill version including `aios-structure-build`/`organize`/`validate`). No local changes remain unpushed as of this push.

## 41.

**Content sync, not a new-skill add** — `start` (Skill ID `001`) was audited via `skill-builder` (2026-08-03, committed as `678d5e5`): added `allowed-tools: Read, Glob, Grep, Write`, pointed Steps 1/10 at `company-workflow.md`'s "Common Tasks by Role" section, and reworded the frontmatter description to the repo's "Use when someone asks to..." convention. This entry syncs those file changes into the HTML catalog's embedded copies.

Updated in `skill-documentation-table-v5.html`: `skill-files-data['001'].fileContent`, `.tryPhrase`, `.guideContent`, and `skill-install-data['001'].files[SKILL.md].content` — all replaced with the current on-disk `SKILL.md`. Also fixed pre-existing, unrelated staleness discovered along the way: `skill-files-data['001'].fileContent` still had CRLF line endings (never picked up by the CRLF→LF fix in [[project-v5-stale-tab-hash-gotcha]]), and `skill-install-data['001']`'s SKILL.md copy was several edits behind current. `company-workflow.md`'s embedded copy was already byte-identical to disk and was left untouched. `skill-data['001']`'s table prose (Purpose/When to Use/Notes) was left as-is — still accurate; the edit didn't change user-facing behavior, only internal tool scoping and an internal file cross-reference.

**Verification:** round-trip `JSON.parse`→`JSON.stringify` fidelity confirmed for all three JSON blocks before editing (guarantees a surgical re-serialize touches no unrelated bytes). After editing: all 24 keys present in both touched blocks; every entry except `001` byte-identical to its pre-edit snapshot (deep string comparison, not just count); `001`'s `fileContent` / install `SKILL.md` content confirmed **string-equal** to a fresh `fs.readFileSync` of the real file, not just length/hash. `git diff --stat` confirmed exactly 3 changed lines (skill-files-data, skill-install-data, footer date) — nothing else in the file moved. Footer date bumped to 2026-08-03; `stat-total`/`stat-visible`/"Currently discoverable" untouched since skill count didn't change.

**Pushed on 2026-08-03 04:34:04 UTC** (hub_pages id=4, same slug) — triggered via "push hub." Diff-checked before pushing: live was 736,561 bytes (md5 `597fb50698ebbd58b22cf8307c911db1`, updated_at 2026-07-31T06:55:01.970Z, pre-`start`-audit version), local was 744,591 bytes (md5 `a92ad56ed3209f79e8289116dc4cc782`, includes this section's `start` sync). No local changes remain unpushed as of this push.

## 42.

**Second catalog sync, same day** — following further `skill-builder` work on `start`/`new-joinee` (2026-08-03): a `new-joinee` audit (glossary.md/company-workflow.md cross-references added at Steps 4/7/13, a stale "glossary lives inside company-workflow.md" correction, description reworded to repo convention) plus a `grill-me`-resolved change making `start`→`new-joinee` a soft sequence (new-joinee Step 0 checks for `start`'s completion-summary.md and can shortcut the basics; new Step 13.5 recommends specific matching skills by role; `start`'s Step 11 now mentions `new-joinee` as an optional next step; `CLAUDE.md`'s inventory rows updated to describe the relationship).

**Table prose updated** in both the CSV and `skill-data`: row 001 (`start`) Expected Output now mentions the `new-joinee` pointer; row 002 (`new-joinee`) Purpose/Expected Output now mention the soft-shortcut and role-specific skill recommendations.

**Bug found and fixed along the way:** row 002's CSV Notes field was badly stale — it still said "this skill can currently only read files, not write them... that mismatch needs sorting out," describing a state that was already fixed before this session (allowed-tools has included Write for some time). The HTML's own `skill-data` Notes for the same row already had the *correct*, more complete text ("Fixed: allowed-tools now includes Write... certificate and cheat-sheet templates are now inlined...") — meaning the CSV and HTML had silently drifted apart at some earlier point. Resolved by merging: both now carry the accurate historical-fix text plus the new soft-sequence sentence.

**Also found and fixed:** row 002's `skill-files-data.guideContent` and `.tryPhrase` were far more stale than a simple content lag — they still described the *pre-restructure* project state (claiming "none of its skills sit at the path Claude Code requires," a flagged Read/Write tool conflict, and broken links to a `templates/` folder), all issues CLAUDE.md's own Historical Note says were already fixed. Fully regenerated both to match current reality, including the two supporting files (`company-workflow.md`, `glossary.md`) now correctly listed as part of the install bundle.

**Self-inflicted bug caught and fixed mid-task:** an early `Edit` call meant to update the CSV's Notes field for row 002 somehow wrote curly quotes (`"`/`"`) in place of every straight-quote (`"`) field delimiter on that line, corrupting the row's CSV structure (verified via codepoint inspection: 4 opening vs 16 closing curly quotes, zero straight quotes, where there should have been 20 straight and zero curly). Caught by inspecting the file before trusting the edit, not by the edit itself failing. Rebuilt the row from scratch via a small Node script with explicit `String.fromCharCode(0x22)` delimiters and re-verified codepoint counts before and after. Root cause not fully understood — flagging in case it recurs on a future edit to this file.

**Verification:** round-trip `JSON.parse`/`JSON.stringify` fidelity confirmed for `skill-data`, `skill-files-data`, and `skill-install-data` before editing. After editing: all 24 entries present in every block; every entry except `001`/`002` confirmed byte-identical to its pre-edit snapshot (deep comparison, not just count); both skills' `fileContent`/install `SKILL.md` confirmed **string-equal** to a fresh `fs.readFileSync` of the real files; `new-joinee`'s `company-workflow.md`/`glossary.md` install copies confirmed still string-equal to disk (untouched, correctly already current). `git diff --stat` confirmed exactly 3 changed lines in the HTML. CSV verified via CRLF-count and quote-codepoint checks before and after, confirming the corruption above was the only anomaly and it was fully resolved.

**Pushed on 2026-08-03 05:17:27 UTC** (hub_pages id=4, same slug) — triggered via "push hub," committed as `90ac6e8` and pushed to `origin/main` first. Diff-checked before pushing: live was 736,646 bytes (md5 `a92ad56ed3209f79e8289116dc4cc782`, updated_at 2026-08-03T04:34:04.800Z, the §41-only version), local was 749,578 bytes (md5 `037767924328104663f6ae793cfa7c77`, includes this section's `new-joinee` audit and sequencing sync). No local changes remain unpushed as of this push.

## 43.

**Third catalog sync, same day** — following a `skill-builder` audit of `project-discovery` (2026-08-03, committed as `a15cc08`): fixed `allowed-tools` granting unrestricted `Bash` when the skill's own Notes promised only 3 scoped git commands (also fixed invalid YAML-list syntax and a dead `Question` tool entry), scoped Step 3's frontmatter parsing to the header block between the first two `---` lines (closing the 2026-07-29 sandbox-test gap), and added `context: fork` + `agent: Explore`.

**Notably, both the CSV and `skill-data` Notes for row 004 already correctly flagged the Bash inconsistency** before this fix existed ("its settings technically allow it to run any terminal command, but its own instructions say to only run three specific... commands — worth confirming which one actually applies") — no CSV/HTML drift this time, unlike §42. Both updated in lockstep to a "Fixed: ..." note describing the resolution.

**`skill-files-data['004'].guideContent` was pre-restructure-stale**, same pattern as §42's `new-joinee` finding — it claimed "none of its skills sit at the path Claude Code requires" and flagged the Bash conflict as "Needs Confirmation." Fully regenerated to the current template style. `tryPhrase` left unchanged since the frontmatter description text itself didn't change this round. `fileContent` and the install-data `SKILL.md` copy refreshed to match disk.

**CSV edit safety:** given §42's quote-corruption incident on this same file, quote-codepoint counts were checked before and after this round's `Edit` call (12 straight quotes, zero curly, both before and after) — no corruption this time.

**Verification:** round-trip JSON fidelity confirmed for all three blocks before editing; after editing, all 24 entries present in each block, every entry except `004` byte-identical to its pre-edit snapshot; `fileContent`/install `SKILL.md` confirmed string-equal to a fresh disk read. `git diff --stat`: 1 line changed in the CSV, 3 lines changed in the HTML (skill-data, skill-files-data, skill-install-data).

**Not pushed to the hub as part of this entry** — local-only sync, per the standing separation between "update skill docs"/ad-hoc syncs and "push hub."
