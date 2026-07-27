=== skillData row 001 (start) — Notes field ===

BEFORE:
Only ever writes files after you explicitly say okay, and only inside the onboarding-output/ folder (standardized to match /new-joinee) — it won't touch anything else.

AFTER:
Only ever writes files after you explicitly say okay, and only inside the onboarding-output/ folder — it won't touch anything else. Every comprehension check is now a quick click, not typing. If a prior session exists, it offers a refresher or a resume instead of always starting over — and if you run out of time or confidence mid-session, it saves your place to onboarding-output/onboarding-progress.md so you can pick up right where you left off.

=== skillData row 015 (grill-me) — new row added ===

{
  "Skill ID": "015",
  "Skill Name": "/grill-me",
  "Created Date": "2026/07/24",
  "Purpose": "Stress-tests any plan, design, or decision — a new skill idea, an architecture choice, a process change — by asking one question at a time, each with a recommended answer, until every decision, dependency, assumption, risk, and branch is nailed down.",
  "When to Use": "Say things like “grill me on this,” “stress-test this plan or idea,” “poke holes in this,” or “make sure I've thought of everything” — anytime you're about to commit to something that hasn't been fully thought through.",
  "Where to Use": "Anywhere in this project, right before committing to a plan, design, or decision — pairs naturally before /skill-builder's own discovery interview, but isn't limited to skills.",
  "How to Use": "Type /grill-me followed by the plan or topic, or just say you want it grilled and point at what's being discussed — Claude will use whatever's already in the conversation if you don't specify a topic.",
  "Input Requirements": "A plan, idea, or design to interrogate — given as an argument, or just whatever's currently being discussed. Nothing else needed to start.",
  "Expected Output": "A one-question-at-a-time interview in chat, each with a recommended answer you can pick with one click — tracked as a visible task list until every open item is resolved. Ends with a structured summary of every decision made; no file is written unless you ask.",
  "Status": "Testing",
  "Version": "Version 1.0",
  "Notes": "Never builds or implements anything itself, even once the plan becomes fully clear — it only interrogates and hands back a resolved plan as a separate follow-up. If the open-items list grows past roughly 15-20, it pauses to suggest splitting the plan into smaller pieces instead of continuing indefinitely."
}

=== filesData["001"] — fileContent length ===
BEFORE: 10749 chars
AFTER: 14628 chars

=== filesData["001"] — guideContent (AFTER, full) ===
# Install & use: Start

This guide was generated from the repository source file at `.claude/skills/start/SKILL.md`. The copy offered here for download is named `SKILL_start.md` for identification in the catalog only — when installing it, place or rename it to match the path Claude Code actually requires.

## 1. Save the file
Save the downloaded `SKILL_start.md` as:

    .claude/skills/start/SKILL.md

(a directory named exactly `start`, containing a file named exactly `SKILL.md` — Claude Code only auto-discovers skills at this path).

## 2. Trigger it
Invoke `/start` or matching natural language ("I'm new here," "onboard me," "explain how this works," "how does our AI system work," or general confusion about MCP/Skills while asking a task question). Runs directly in the main conversation — no subagent fork — since it's a back-and-forth teaching session.

## 3. What to provide
Your role and whether you've used Claude Code/MCP/AI coding tools before (asked conversationally in Step 1). If a prior onboarding session exists (in progress or completed), it asks upfront whether you want to resume, get a quick refresher, or start fresh.

## 4. What you'll get back
An interactive lesson in chat covering the four-layer model (Data/MCP/Claude+Skills/Output), with a multiple-choice comprehension check after each section. Optionally, only after you explicitly say yes: a cheat sheet and/or completion summary saved to `onboarding-output/`. If you pause mid-session, your progress is saved to `onboarding-output/onboarding-progress.md` so `/start` can pick up where you left off next time.

## Notes
Only ever writes files after explicit confirmation, and only inside `onboarding-output/` — never anywhere else. Source: `.claude/skills/start/SKILL.md`.

## Status of this information
Created Date: 2026-07-17 · Status: Testing · Version: Version 1.0
Source of truth: `.claude/skills/start/SKILL.md` in the Peries-Skills-Master repository. This guide is a companion, generated from that file's own frontmatter and content — it is not itself part of the skill and is not required by Claude Code.


=== filesData["015"] — new entry added ===
filename: SKILL_grill_me.md
guideFilename: grill-me-install-guide.md
fileContent length: 4692 chars
tryPhrase: Someone asks to grill me on this, stress-test this plan or idea, poke holes in this, or make sure I've thought of everything before committing to a plan, design, or decision.

--- guideContent (full) ---
# Install & use: Grill Me

This guide was generated from the repository source file at `.claude/skills/grill-me/SKILL.md`. The copy offered here for download is named `SKILL_grill_me.md` for identification in the catalog only — when installing it, place or rename it to match the path Claude Code actually requires.

## 1. Save the file
Save the downloaded `SKILL_grill_me.md` as:

    .claude/skills/grill-me/SKILL.md

(a directory named exactly `grill-me`, containing a file named exactly `SKILL.md` — Claude Code only auto-discovers skills at this path).

## 2. Trigger it
Invoke `/grill-me [topic or plan]` or matching natural language ("grill me on this," "stress-test this plan or idea," "poke holes in this," "make sure I've thought of everything"). Runs directly in the main conversation, asking one question at a time via clickable multiple-choice options with a recommended answer.

## 3. What to provide
`$ARGUMENTS` — the plan, design, or idea to interrogate. If it's missing, the skill falls back to whatever plan is already being discussed in the conversation, or asks what you want grilled.

## 4. What you'll get back
A one-question-at-a-time interview, tracked as a visible task list of open decisions, dependencies, assumptions, risks, and branches — each resolved via a clickable recommended answer. Ends with a structured "Grill Session Summary": resolved decisions, confirmed dependencies, checked assumptions, addressed risks, and a ready-to-execute plan.

## Notes
Never builds, implements, or writes code/files itself — it only interrogates and hands back a resolved plan, which is then a separate follow-up request (e.g. to /skill-builder). If the open-items list grows past roughly 15-20, it pauses to suggest splitting the plan into smaller pieces rather than continuing indefinitely. Source: `.claude/skills/grill-me/SKILL.md`.

## Status of this information
Created Date: 2026-07-24 · Status: Testing · Version: Version 1.0
Source of truth: `.claude/skills/grill-me/SKILL.md` in the Peries-Skills-Master repository. This guide is a companion, generated from that file's own frontmatter and content — it is not itself part of the skill and is not required by Claude Code.

