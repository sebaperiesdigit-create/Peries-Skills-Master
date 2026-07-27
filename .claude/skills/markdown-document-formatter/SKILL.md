---
name: markdown-document-formatter
description: "Use when you need to clean up messy Markdown, fix heading structure, or polish a Markdown document for review."
argument-hint: [file.md]
---

## Purpose

Read a messy or poorly formatted Markdown file and produce a clean, well-structured version without changing content or meaning.

## Inputs

- A file path to a `.md` file, or raw Markdown text pasted directly.
- No external systems or credentials.

## Steps

1. Read the Markdown content (from file or pasted text).
2. Analyze for formatting issues:
   - Inconsistent or skipped heading levels (e.g., jumping from `#` to `###`)
   - Mixed list markers (`-`, `*`, `+`)
   - Inconsistent spacing between sections
   - Malformed tables, links, or images
   - Code block fencing issues
   - Trailing whitespace
3. Fix heading hierarchy to follow logical, sequential order without changing wording.
4. Standardize list markers to a single consistent style throughout.
5. Normalize spacing and blank lines per Markdown conventions.
6. Repair malformed tables and links where the intent is clear; flag ambiguous issues instead of guessing.
7. Preserve all content and meaning—formatting and syntax fixes only, no rewrites.
8. Save the cleaned document as `[original-name]-formatted.md` (alongside the original).
9. Report a summary of fixes applied and flag any manual review items.

## Output

- A cleaned Markdown file saved to disk (e.g., `README-formatted.md`).
- A brief summary of fixes: heading normalization, list standardization, spacing, table/link repairs.
- Flagged items for manual review if any.

## Guardrails

- Do not rewrite, summarize, or shorten content.
- Do not change the meaning of headings or text.
- Do not overwrite the original file.
- Flag broken syntax that cannot be safely auto-fixed.
