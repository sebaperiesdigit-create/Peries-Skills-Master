# Briefing: Skill Testing Results — for the Origin Project

**From:** `Desktop\Test` — a sandbox project used purely to verify these skills, no application code of its own.
**Purpose:** This sandbox installed all 20 skills from your HTML-published installation prompts, verified the installation itself, then functionally tested every individual skill. This document reports those results back to you.
**Date:** 2026-07-29

---

## Part 1 — Installation verification

The installation prompts (as published on your HTML page) were used to install all 20 skills into this sandbox project. Result: **all 20 skill folders installed correctly**, all expected files present, frontmatter valid on every `SKILL.md` (name matches directory, description present, `---` delimiters intact).

One caveat worth passing back: an earlier automated installation report claimed "SHA256 hash match — 0 mismatches" for every file, but that report never actually recorded the reference hash values it was supposedly comparing against — so that specific claim was unverifiable as written, not false, just unsupported by evidence. Everything else in that installation check held up under manual re-verification (file counts, sizes, no zero-byte/corrupt files, no duplicate frontmatter keys).

## Part 2 — Individual functional testing (all 20 skills)

Beyond installation, every skill was then actually run — mostly for real (real tool calls, real scripts, a real forked subagent, a real published Artifact), using clearly-marked dummy data throughout, never real production data.

**Result: 20/20 skills passed.** No functional defects found in any skill.

| # | Skill | Result | Summary |
|---|---|---|---|
| 1 | start | Pass | Full 11-step onboarding walkthrough verified, including both correct-answer and wrong-answer/re-teach branches; file-write gates held. |
| 2 | new-joinee | Pass | Zero-knowledge calibration and mandatory "don't proceed until understood" gate both verified; certificate correctly gated on both assessments passing. |
| 3 | project-discovery | Pass (1 observation) | Read-only inspection correct throughout. See Finding A below. |
| 4 | existing-asset-finder | Pass | Ran as a real forked subagent; correctly identified an exact-match REUSE candidate and correctly disclosed what it didn't check (live DB). |
| 5 | first-task-mapper | Pass | All fields correctly labeled Confirmed/Not confirmed; never invented unconfirmed details. |
| 6 | skill-builder | Pass | Audit mode correctly found 3 real, specific gaps in a target skill rather than rubber-stamping it. |
| 7 | skill-finder | Pass | Correctly recommended COMBINE EXISTING SKILLS for a task spanning two skills' capabilities. |
| 8 | requirements-validator | Pass | Correctly caught all 6 planted issues (ambiguity + contradictions) in a test requirements doc. |
| 9 | markdown-document-formatter | Pass (1 spec gap) | Correctly fixed all 7 planted formatting issues. See Finding D below. |
| 10 | meeting-note-summariser | Pass | Correctly avoided fabricating names/deadlines; correctly used TBD/Unclassified for genuine gaps. |
| 11 | customer-email-reply-drafter | Pass | Correctly placeholdered order/tracking/compensation details rather than fabricating any of them. |
| 12 | product-description-writer | Pass | Correctly applied UK-English tone rule even against US-spelled input. |
| 13 | order-summary-report | Pass | Correctly handled invalid rows and a duplicate order ID; math verified correct by hand. |
| 14 | order-status-summary | Pass (1 spec gap) | Column-mapping and malformed-data handling both correct. See Finding B below. |
| 15 | mcp-access-guide | Pass (1 spec gap) | Live connector check and registry read both genuine; built and published the required interactive Artifact. See Finding C below. |
| 16 | task-closure | Pass | Ran against a real completed task with real filesystem evidence; correctly scoped its evidence search. |
| 17 | daily-work-tracker | Pass | Most thorough test — real PowerShell script execution end-to-end, including the identity-correction/audit-log flow. |
| 18 | grill-me | Pass | Used live to plan the testing effort itself. |
| 19 | evidence-pack-builder | Pass | Manual-only gate (`disable-model-invocation: true`) confirmed enforced at the tool level. |
| 20 | claude-code-basics | Pass | All 9 topics completed with a real learner; comprehension-retry rule validated by genuine (not simulated) confusion moments. |

## Part 3 — Findings (all minor, none blocking, no fixes applied)

**A. `project-discovery`** — a naive whole-file grep for frontmatter (rather than parsing only the header block between the first two `---` lines) could misreport `skill-builder`, whose body contains a full example SKILL.md template inside a code fence with its own `name: meeting-notes` line.

**B. `order-status-summary`** — its 5-status taxonomy (Delivered / Cancelled / Shipped on time / Delayed-not-shipped / Delayed-past-expected) has no bucket for a normal in-progress order: not yet shipped, but also not yet 3 days old and not yet past its expected delivery date. Also flagged separately by `skill-builder`'s own audit mode: missing an `allowed-tools` restriction despite being read-only, no output template/example, and `argument-hint` is declared but `$ARGUMENTS` is never referenced in its steps.

**C. `mcp-access-guide`** — its 3-label connector status vocabulary (Live verified / Registry verified / Demo only) has no label for "connector installed but not yet authenticated" — a real state that occurred during testing (an OAuth-gated connector).

**D. `markdown-document-formatter`** — Step 2 lists "code block fencing issues" as something to detect, but no later step assigns a fix rule for it, unlike headings/lists/spacing/tables/links, which each get one.

## Notes on how this was tested

- Dummy data only throughout (no real personal, company, or production data).
- File writes were only ever made after explicit confirmation.
- Comprehension-check-style questions inside skills were deliberately answered wrong once per skill (where applicable) to verify re-teach/error-handling branches, not just the happy path.
- Manual-only skills required literally typing the real slash command — confirmed `disable-model-invocation: true` blocks even a direct programmatic invocation attempt.

No fixes were made to any skill as part of this testing pass — this is a report only.
