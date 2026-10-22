# Reusable prompt: reorganize every project in a parent folder into the AIOS FOLDER_MAP layout

Paste everything below the line into Claude Code, started in the PARENT folder
(e.g. `C:\Users\LED 269\Desktop\PERIES-DigitWebLanka`).

---

You are reorganizing the projects inside the current working folder (the PARENT folder) into a proper AIOS-style layout. The hard rule: every project must work exactly as it does today. Move files only. Never edit, rewrite, re-save, rename-in-content, or delete the content of any file. Each project is independent: never move anything between projects or out of a project, and never touch the parent folder's own files.

## Target layout (embedded; do not require a FOLDER_MAP.md to exist)

| Output type | Folder |
|---|---|
| Evidence | evidence/ |
| Documentation | documentation/ |
| Handover | handover/ |
| Closure | closure/ |
| Validation | validation/ |
| Workflows | workflows/ |
| SQL | sql/ |
| Capability | capability/ |
| Prompts | prompts/ |
| Data Maps | data-maps/ |
| Query Packs | query-packs/ |
| Duplicate Risk Reports | duplicate-risk-reports/ |

Every folder except capability/ uses a per-task subfolder: `[folder]/[task-name]/`. Never place a file at a folder root (except `.gitkeep`). If a project already has its own FOLDER_MAP.md, follow that instead of this table.

## Absolute rules

1. **No content changes.** Do not edit any file. This includes CLAUDE.md, AGENTS.md, README, SKILL.md, scripts, configs, and handover notes that mention old paths. Stale path mentions in prose are accepted.
2. **Never move (anything the project depends on at its current path):**
   - `.git`, `.claude`, `.agents`, `.github`, `.vscode`, `node_modules`, `.venv`, `venv`, and any dot-folder.
   - `CLAUDE.md`, `AGENTS.md`, `README*`, `LICENSE*`, `.gitignore`, `.gitattributes`, `FOLDER_MAP.md`.
   - Package and build files: `package.json`, lockfiles, `requirements.txt`, `pyproject.toml`, `*.sln`, `*.csproj`, `Makefile`, `Dockerfile`, `.env*`, etc.
   - Source code and application folders (`src/`, `app/`, `lib/`, `scripts/`, `tests/`, and similar), and any file or folder that is imported, required, or referenced by relative path from code, config, a SKILL.md, a CLAUDE.md, or a script.
   - Any folder a skill, script, or config writes to at a fixed path (for example `output/`, `onboarding-output/`, `deliverables/`, `employees/`). Treat existing deliverable and output folders as live. Leave them in place.
3. **Before proposing any move**, grep the whole project (excluding `.git`) for the file's name and its folder name. If any file other than a historical note or log references it as a live path, do not move it. List it under "Left in place (referenced)".
4. **Skip entirely** (report only): backup folders (names containing BACKUP, old, V1, copy), zip/archive files used as shipping packages, lock files (`.~lock.*`), and any sub-folder with no project signals.
5. **Do not commit, push, stash, reset, or run any git command that changes history or the index** except `git mv` for files that are already tracked, and only after approval. Never run `git add` on untracked files.
6. Do not create files other than empty `.gitkeep` placeholders in newly created empty target folders, and a per-project move log (see Step 5) in the scratchpad only.
7. Work inside one project at a time. Do not process a second project until the first is verified and you have my approval.

## Procedure

**Step 1: Discover (read-only).** List the immediate sub-folders of the current folder. For each, show: name, whether it has `.git`, `.claude`, `.agents`, CLAUDE.md or AGENTS.md, rough file count, and a recommendation (Process / Skip, with the reason). Do not scan deep inside yet. Large folders can take a long time, so use shallow listings and timeouts.

**Step 2: Choose.** Ask me with AskUserQuestion (multi-select) which projects to process. Default recommendation: Process projects that have project signals and are not backups or zips.

**Step 3: Plan, per project (read-only).** For the first chosen project:
- Take a baseline: `git status --short` (if it is a repo) and a sha256 list of every file that would move.
- Run the reference check from rule 3 for each candidate.
- Show a plan table: `From → To`, a one-line reason per row, then "Left in place (and why)" and "Skipped".
- Choose `[task-name]` from the project's own name or the file's topic, in lowercase-with-hyphens.
- If nothing safely qualifies to move, say so and stop for this project. Do not invent moves.
- Ask me to approve with AskUserQuestion: Execute / Adjust the plan / Skip this project.

**Step 4: Execute (only after approval).**
- Create only the needed target folders, plus the remaining FOLDER_MAP folders each with an empty `.gitkeep` (if I approved the full scaffold in the plan).
- Use `git mv` for tracked files and a plain move for untracked ones. Never overwrite: if a destination exists, stop and ask.

**Step 5: Verify.**
- Recompute sha256 for every moved file and confirm each is identical to the baseline.
- Confirm that protected items from rule 2 are byte-identical and untouched.
- Show `git status --short` and confirm there are only renames and additions, with no content modifications. Compare against the baseline so existing pre-modified files are not blamed on this run.
- Save the old → new path list so every move can be undone, and state how to undo it.
- Report in plain words: what moved, what stayed, what was verified, what is stale in prose. Do not claim success beyond what was verified.

**Step 6: Next.** Ask which project to do next, or finish. Repeat from Step 3 for each. Never batch projects.

Start with Step 1 now.
