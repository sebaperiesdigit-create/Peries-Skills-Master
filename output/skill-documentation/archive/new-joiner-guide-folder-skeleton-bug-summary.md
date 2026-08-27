# Grill Session Summary: new-joiner-guide folder-skeleton bug report

**Resolved decisions:**
- Bug classification: **spec/intent mismatch**, not an execution failure — Claude Code correctly followed the installed SKILL.md's actual Reference A step 5 (GPT-mediated build loop); the file itself never encodes the behavior the user intended.
- Trigger point: the direct build should happen at the **current Reference A step 5 position** — after GitHub account, repo, tool, and connectors are confirmed, same slot the GPT kickoff prompt currently occupies.
- Scope: **full 12-folder skeleton with a short README.md in each, built locally**, without pushing to GitHub — the push stays part of the later GPT-mediated loop.

**Dependencies confirmed:**
- This only applies to users who select **"I'm new"** — not to "I received a task," "I finished my work," etc.

**Assumptions checked:**
- The illustrative build is real (not throwaway) — it should stand as the actual working skeleton going forward, not get discarded before the "real" GPT loop runs.
- Existing-Asset-First discipline still applies even for this direct build — Claude Code should verify no conflicting structure already exists before creating anything (not asked directly, carried forward as a trivial/obvious safety note per governance §12.3).

**Risks addressed:**
- Must not blur into a general bypass of "GPT Is Still the Brain" — every response using this exception must explicitly flag that it is a one-time onboarding illustration, and that real day-to-day task work still requires GPT-mediated discovery-first, every time.

**Scope note:** the grill-me tool-discovery lag (`Unknown skill: grill-me` until the registry refreshed mid-session) is a separate, real finding — tracked separately, not folded into this report.

---

## Bug Report: new-joiner-guide — missing "build skeleton for understanding" behavior on Day-One setup

**Environment:** Claude Code, project root `C:\Users\LED 269\Desktop\Tests\new-joiner-guide-Test-01`, skill installed fresh this session at `.claude/skills/new-joiner-guide/`.

**Steps to reproduce:**
1. Invoke `/new-joiner-guide` with no argument.
2. Select "I'm new / how do I start?" when asked.
3. Confirm GitHub account, repo, and tool are already done.
4. Confirm all 3 connectors are enabled.
5. Reach the folder-skeleton step (§5.5 / Reference A step 5).

**Actual behavior:** The skill gave the user the GPT kickoff prompt to paste into ChatGPT, and stated it would wait for the user to bring back a GPT-generated DISCOVERY prompt before creating anything. No folders were created on disk at this point. When the user asked whether the folder structure should be shown first, the skill displayed the Reference B folder-purpose **table in chat only** — it did not create any files or directories.

**Expected behavior (per author intent, not currently in SKILL.md):** For a user who selected "I'm new" specifically, once account/repo/tool/connectors are confirmed, the skill should **directly build the full 12-folder skeleton locally** (all folders from Reference B, each with a short README.md) **and** show the explanation table in the same response — without waiting on a ChatGPT round-trip. This is meant purely as an onboarding aid so a first-time user can see and explore real folders, not read about them abstractly. The response must **explicitly flag this as a one-time exception**: this direct build only happens once, for onboarding; the push to GitHub still goes through the normal GPT-mediated loop; and all real day-to-day task work must continue to go through GPT-driven discovery-first before anything is built, exactly as the rest of the guide already specifies.

**Root cause:** `SKILL.md` Reference A step 5, combined with the "GPT Is Still the Brain" section, routes *all* real folder creation through the GPT DISCOVERY→BUILD loop with no carve-out for a direct, onboarding-only illustrative build. The file was never written to distinguish "teaching build for a brand-new user" from "live build for real task work."

**Suggested fix:** Add an explicit branch to Reference A step 5 (or a new sub-step) that, only when the joiner selected "I'm new," has Claude Code build the local skeleton directly (with an Existing-Asset-First check first) and render the Reference B table in the same turn — clearly labeled as a one-time onboarding illustration — while leaving the GitHub push and all subsequent task-specific folder creation on the existing GPT-first path.

**Severity:** Design gap, not a correctness/safety issue — current behavior is safe and internally consistent, it just doesn't match the author's intended onboarding UX.
