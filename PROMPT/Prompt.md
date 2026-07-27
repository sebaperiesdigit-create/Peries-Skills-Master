You are working inside the existing Git repository:

Peries-Skills-Master

Implement a complete “View and Copy Installation Prompt” feature in the Files column of the live skill catalog.

Do not start editing immediately. First inspect the repository, confirm the current structure, identify all 17 real skill folders, study the current HTML implementation, and report the exact files you intend to modify.

==================================================
OBJECTIVE
==================================================

The catalog currently lets users:

1. Download the skill file.
2. Download the install guide.
3. Expand the existing skill walkthrough.

Keep all these existing features.

Add a new beginner-friendly feature to every skill’s Files cell:

“View install prompt”

When clicked, it must open a large modal containing a complete, skill-specific prompt that the user can copy and paste directly into Claude Code.

The copied prompt must allow Claude Code to install that respective skill into the user’s currently opened project without requiring the user to:

- Download the skill file.
- Download or read the install guide.
- Create folders manually.
- Rename files manually.
- Copy individual supporting files manually.

The copied prompt itself must contain the full installation materials.

==================================================
AUTHORITATIVE PROJECT STRUCTURE
==================================================

The canonical skill sources are under:

.claude/skills/<skill-name>/

The repository is expected to contain 17 unique skill folders.

Each skill’s main file must be:

.claude/skills/<skill-name>/SKILL.md

Some skills also have supporting files, including examples such as:

.claude/skills/new-joinee/company-workflow.md
.claude/skills/new-joinee/glossary.md
.claude/skills/start/company-workflow.md
.claude/skills/skill-builder/reference.md
.claude/skills/mcp-access-guide/references/connector-registry.md

These examples are not permission to assume that this is the complete dependency list.

Inspect every one of the 17 skill folders recursively. Determine the complete set of files belonging to each skill from the actual files on disk.

Do not use the catalog CSV as the source of truth for skill content.

==================================================
AUTHORIZED FILE CHANGES
==================================================

You may modify only:

1. output/skill-documentation/skill-documentation-table-v5.html
2. output/skill-documentation/skill-documentation-review-notes.md

Do not modify:

- Any file under .claude/skills/
- inputs/Skills_documentation_table -Final.csv
- push_to_hub.js
- package.json
- .env
- Any other project file
- Any archived HTML version

The skill folders are read-only sources for this task.

The source CSV contains known pre-existing stale content and is deliberately outside this task’s scope.

==================================================
MANDATORY DISCOVERY BEFORE EDITING
==================================================

Before making changes:

1. Confirm the repository root.
2. List every immediate directory under .claude/skills/.
3. Confirm there are exactly 17 unique skill folders.
4. Read every skill’s SKILL.md.
5. Recursively identify every supporting file belonging to each skill.
6. Parse the existing skill-data and skill-files-data JSON blocks in the HTML.
7. Confirm that every skill folder maps to exactly one catalog entry.
8. Identify any missing, duplicate, or mismatched entries before editing.
9. Inspect the existing Files-column HTML, CSS, JavaScript, download buttons, walkthrough controls, filters, sorting, and event handlers.
10. Determine the safest implementation architecture.

If the repository contains more or fewer than 17 unique skill folders, or a folder cannot be mapped reliably to a catalog entry, stop and report the discrepancy instead of silently continuing.

==================================================
INSTALLATION PROMPT CONTENT
==================================================

Every skill must receive its own generated installation prompt.

The prompt must embed:

1. The complete, exact content of that skill’s SKILL.md.
2. The complete, exact content of every supporting file in that skill’s folder.
3. Each required destination path relative to the current project root.
4. Safe instructions for inspecting an existing installation.
5. Complete post-installation validation instructions.
6. A final usage example showing how to invoke the installed skill.

The generated prompt must be self-contained.

It must not depend on:

- GitHub access.
- Internet access.
- Access to Peries-Skills-Master.
- Downloaded files.
- The downloadable install guide.
- External URLs.
- Content omitted with phrases such as “insert content here.”
- Content referenced only by its original repository path.

Do not embed credentials, connection strings, tokens, passwords, .env content, temporary files, generated output, or unrelated project files.

==================================================
REQUIRED BEHAVIOR OF EACH COPIED PROMPT
==================================================

Each copied prompt must clearly instruct Claude Code to perform the following workflow.

STEP 1 — Confirm the target project

- Treat the currently opened Claude Code project as the installation target.
- Identify and state the current project root.
- Show the exact destination:
  .claude/skills/<skill-name>/
- Do not ask the beginner to provide another path unless the current project root genuinely cannot be determined.

STEP 2 — Inspect before writing

- Check whether .claude/skills/<skill-name>/ already exists.
- If it does not exist, continue with installation.
- If it already exists, read and compare all relevant existing files with the embedded versions.
- Report which files are identical, missing, changed, or additional.
- Explain the material differences clearly.
- Ask for explicit user approval before replacing or overwriting any existing file.
- Do not overwrite automatically.
- Do not delete additional local files.
- Preserve local customizations unless the user explicitly approves replacement.

STEP 3 — Install the complete skill

After obtaining any required approval:

- Create the exact directory structure.
- Write the main file as:
  .claude/skills/<skill-name>/SKILL.md
- Write every supporting file to its correct relative path.
- Preserve the embedded content exactly.
- Do not rename SKILL.md to the catalog’s downloadable filename.
- Do not alter frontmatter, wording, examples, formatting, or referenced paths.
- Do not modify unrelated project files.

STEP 4 — Fully verify the installation

Verify all of the following:

- The expected skill directory exists.
- SKILL.md exists in the correct location.
- The folder name matches the SKILL.md frontmatter name.
- YAML frontmatter is present and structurally valid.
- The written SKILL.md matches the embedded source exactly.
- Every required supporting file exists.
- Every supporting file matches its embedded source exactly.
- Relative references from SKILL.md resolve to the installed files where applicable.
- No unrelated files were modified.
- No expected file was omitted.
- No placeholder or truncated content was written.

STEP 5 — Report the result

Return a concise installation report containing:

- Skill name.
- Target project root.
- Files created.
- Files updated, if explicitly approved.
- Files preserved.
- Validation checks performed.
- PASS or FAIL status.
- Any unresolved warning.
- The exact slash command or natural-language phrase that can invoke the skill.

Never claim PASS unless every mandatory validation check succeeds.

==================================================
IMPLEMENTATION ARCHITECTURE
==================================================

Choose the safest maintainable architecture only after inspecting the existing HTML.

Requirements for the architecture:

- The HTML must remain a self-contained single file.
- It must work without external JavaScript, CSS, APIs, or network access.
- Avoid unnecessary duplication of large skill content.
- Downloads and installation prompts must not silently use conflicting versions.
- Skill source content must remain correctly mapped to its respective skill ID.
- Supporting files must be represented in a structured, deterministic form.
- JSON script blocks must remain valid and safely escaped.
- Literal content such as backticks, ${...}, </script>, quotes, Unicode, YAML, HTML, and code fences must not corrupt the HTML or execute accidentally.
- The generated prompt must reproduce source files exactly after copying and installation.
- Do not use unsafe HTML insertion for the prompt preview.
- Render prompt text as text, not interpreted HTML.

You may choose whether prompts are:

- Generated dynamically from structured embedded source data, or
- Stored as completed prompt values.

However, you must justify the chosen approach in the review notes.

Prefer the approach that minimizes content duplication and future synchronization errors while preserving reliable standalone operation.

==================================================
FILES-COLUMN USER INTERFACE
==================================================

Retain all current Files-column controls.

Add a new button for every valid skill row:

View install prompt

The new button must:

- Appear with the existing Files controls.
- Be visually consistent with the current design.
- Be understandable to an absolute beginner.
- Open the correct skill’s prompt.
- Never display another skill’s content.
- Be a real button with type="button".
- Have an accessible label and visible keyboard focus.
- Work after searching, filtering, sorting, expanding walkthroughs, and resetting the table.

Do not remove or break:

- Download skill file.
- Download install guide.
- Existing walkthrough.
- Search.
- Filters.
- Sorting.
- Reset behavior.
- Current responsive layout.

==================================================
MODAL REQUIREMENTS
==================================================

Clicking “View install prompt” must open a large modal.

The modal must include:

- A clear heading containing the respective skill name.
- A short beginner-friendly instruction explaining:
  “Copy this prompt and paste it into Claude Code while your target project is open.”
- The exact intended destination:
  .claude/skills/<skill-name>/
- A large scrollable, read-only prompt preview.
- A clear “Copy prompt” button.
- A clear “Close” button.
- Visible copy-success feedback such as “Copied ✓”.
- Copy-failure feedback with a safe fallback instruction.
- No automatic file download.

Modal accessibility must include:

- Appropriate dialog semantics.
- aria-modal="true".
- An accessible modal title.
- Keyboard-accessible controls.
- Escape key closes the modal.
- Clicking the backdrop closes it.
- Focus moves into the modal when opened.
- Keyboard focus remains inside the open modal.
- Focus returns to the original “View install prompt” button after closing.
- Background page scrolling is prevented while the modal is open.
- Modal content is usable on desktop and mobile.
- Long lines remain readable through wrapping or controlled horizontal scrolling.
- Prompt text is selectable manually if Clipboard API access fails.

Only one modal should be open at a time.

==================================================
COPY FUNCTION REQUIREMENTS
==================================================

Use the Clipboard API when available.

Also implement a practical fallback for environments where:

- navigator.clipboard is unavailable.
- The page is opened locally.
- Clipboard permission is denied.
- The browser blocks clipboard access.

The copy operation must copy:

- The complete prompt.
- Exactly one respective skill’s prompt.
- All embedded files for that skill.
- No modal labels, HTML markup, or unrelated catalog text.

After copying:

- Change the button feedback to “Copied ✓” temporarily.
- Restore the original label after a short delay.
- Do not close the modal automatically.
- Do not download anything.

==================================================
DATA COMPLETENESS REQUIREMENTS
==================================================

This feature must work for all 17 unique skills.

Build a programmatic mapping check proving:

- 17 unique skill directories exist.
- 17 catalog rows exist.
- 17 Files-column data entries exist.
- 17 install-prompt mappings exist.
- Every catalog Skill ID maps to one valid skill.
- Every skill maps back to one catalog Skill ID.
- Every SKILL.md is included exactly once.
- Every supporting file is included under the correct skill.
- No skill receives another skill’s content.
- There are no missing prompt buttons.
- There are no duplicate prompt buttons within a Files cell.

Do not rely only on visible row counts.

==================================================
CONTENT INTEGRITY REQUIREMENTS
==================================================

Programmatically compare the source files on disk with the content embedded for installation.

For each skill:

- Compare source SKILL.md bytes or normalized text using one explicitly documented newline policy.
- Compare every supporting file.
- Verify destination paths.
- Verify filenames.
- Verify frontmatter name against the directory name.
- Verify content is complete and not truncated.
- Verify that copied prompt construction includes all expected file boundaries.

If line endings are normalized, document whether the canonical embedded output uses LF or preserves original line endings. Do not make undocumented transformations.

==================================================
SECURITY AND SAFETY REQUIREMENTS
==================================================

- Never read or embed .env.
- Never print or expose database credentials.
- Never place credentials in HTML, JavaScript, review notes, logs, or copied prompts.
- Do not change database configuration.
- Do not execute generated installation prompts against this repository as part of testing.
- Use a temporary disposable test directory if an end-to-end installation simulation is needed.
- Never overwrite real skill folders during testing.
- Do not modify any file outside the two authorized files.
- Do not fetch anything from the internet.
- Do not add external dependencies.

==================================================
TESTING REQUIREMENTS
==================================================

Perform programmatic and browser-level validation.

A. Structural checks

- HTML parses successfully.
- All JSON application blocks parse successfully.
- There are exactly 17 unique skill records.
- There are exactly 17 correct installation-prompt mappings.
- All source-to-embedded comparisons pass.
- No unexpected file was modified.

B. Existing feature regression checks

Confirm that:

- Search still works.
- Column filters still work.
- Sorting still works.
- Reset still works.
- Skill download still uses the correct skill.
- Install-guide download still uses the correct guide.
- Existing walkthrough expansion still works.
- Current row counts and skill metadata remain unchanged unless required by this feature.

C. New UI checks

For every one of the 17 skills:

- “View install prompt” appears.
- The button opens the modal.
- The modal shows the correct skill name.
- The correct destination path appears.
- The preview contains that skill’s complete SKILL.md.
- All supporting files for that skill are included.
- “Copy prompt” copies the complete correct prompt.
- Copy feedback appears.
- Closing works through the button.
- Closing works through Escape.
- Backdrop closing works.
- Focus returns correctly.
- No console errors occur.

D. Special-content checks

Test prompts containing:

- YAML frontmatter.
- Markdown code fences.
- Backticks.
- Quotes.
- Apostrophes.
- ${...} sequences.
- HTML-like text.
- Unicode punctuation.
- Multiline content.
- Any literal </script> sequence if present.

Ensure none of these break the HTML, JSON, JavaScript, modal, or clipboard output.

E. Installation simulation

In a temporary disposable project directory:

1. Select at least one skill with no supporting files.
2. Select at least one skill with supporting files.
3. Reconstruct or execute the installation logic represented by the copied prompt safely.
4. Confirm the expected directory structure and exact file contents.
5. Simulate an existing different version and verify that the prompt requires comparison and approval rather than automatic replacement.
6. Remove the disposable test directory afterward if safe to do so.

Do not run this simulation against the real `.claude/skills/` directory.

F. Visual/browser verification

Open the HTML in a browser and manually verify at minimum:

- One simple skill.
- `start`.
- `new-joinee`.
- `skill-builder`.
- `mcp-access-guide`.
- Responsive behavior at desktop and narrow/mobile widths.
- Modal scrolling with a long skill.
- Focus visibility.
- No layout collision in the Files column.
- No browser console errors.

==================================================
PRESERVATION REQUIREMENTS
==================================================

This is a focused feature addition.

Do not change unrelated:

- Skill descriptions.
- Skill IDs.
- Dates.
- Statuses.
- Versions.
- Table values.
- Row order.
- Page title.
- Heading.
- Theme.
- Existing button behavior.
- Existing download filenames.
- Existing install-guide contents.
- Walkthrough content.
- CSV content.
- Skill source files.

Where possible, prove that unrelated catalog data remains byte-identical.

==================================================
REVIEW NOTES
==================================================

Append a clearly dated section to:

output/skill-documentation/skill-documentation-review-notes.md

Document:

- The user requirement.
- The resolved design decisions.
- Files modified.
- Files deliberately not modified.
- The implementation architecture and why it was chosen.
- How all 17 skills were mapped.
- How supporting files were detected and embedded.
- Existing-installation protection behavior.
- Modal and clipboard behavior.
- Accessibility behavior.
- Newline/content-integrity policy.
- Programmatic checks performed.
- Browser checks performed.
- Installation simulations performed.
- Results and any limitations.
- Confirmation that no credentials were embedded.
- Confirmation that the source CSV remains unchanged.
- Confirmation that `.claude/skills/` remains unchanged.
- Publishing status.

Do not claim a manual or browser check occurred unless it was actually performed.

==================================================
COMPLETION REPORT
==================================================

After implementation, provide:

1. A concise explanation of what changed.
2. The exact two files modified.
3. The number of skills covered.
4. The supporting files detected for each affected skill.
5. The architecture selected.
6. Structural validation results.
7. Source-to-embedded integrity results.
8. Browser/manual test results.
9. Regression test results.
10. Installation simulation results.
11. Confirmation that skill sources and CSV were unchanged.
12. Any genuine limitations.
13. A clear local readiness verdict:
    PASS or FAIL.

Do not publish if any required test fails.

==================================================
PUBLISHING GATE
==================================================

Do not publish automatically.

After all local checks pass:

1. Stop.
2. Show me the evidence and local PASS result.
3. Ask for explicit approval to publish.

Only after I approve may you run the existing pipeline from:

output/skill-documentation/

Using the existing command pattern:

node --env-file=.env push_to_hub.js "skill-documentation-table-v5.html" "skill-catalog" "Peries Skill Catalog — Claude Code Skills Reference"

Never display or inspect the .env contents.

If publishing is later approved:

- Use the existing pipeline without changing it.
- Confirm the upsert succeeds.
- Verify the live page reflects the new feature.
- Report the publishing result separately from the local implementation result.

Begin now with read-only discovery. Before editing, report:

- The 17 skill folders found.
- Supporting files detected per skill.
- Current catalog mapping result.
- Proposed implementation architecture.
- Exact two files to be modified.
- Any blocker or discrepancy.