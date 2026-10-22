# Workflow registry CSV export - 2026-10-01

Created `output/skill-documentation/skills-workflows.csv` for user-managed bulk upload. The original final CSV and header-only workflow template were preserved.

## Mapping and decisions

- 35 records; 21 columns in the exact template order; original IDs 001-035 and slash-command names retained.
- Existing purpose, usage context, inputs, output, status and version retained. Descriptions and curated steps, business rules, tools, categories and execution types drawn from current Claude skill instructions.
- Created dates, invocation instructions, original notes and source paths retained in notes. Current attendance CLI requirements explicitly clarify older supervisor-edit wording.
- Only documented required skill dependencies populated. Optional related skills are not prerequisites. Source systems/tables are populated only where documented; unknown values remain blank.
- All Attachment URL fields remain blank pending verified shared access links. No publication or upload performed.
- UTF-8 without BOM, quoted CSV cells, CRLF record separators; multiline steps and notes are quoted. No extra Department column added because the supplied template omits it.

## Verification

- Parsed output equals authored records exactly; header sequence matches the template.
- Exactly 35 unique codes and names; complete match with the 35 Claude skill folders.
- Original CSV, template and all Claude skill files have identical before/after SHA-256 hashes.
- Status and version are source metadata, not evidence of new skill tests. Registry import compatibility has not been live-tested.

Input SHA-256:

- `Skills_documentation_table -Final.csv`: `704387d274a5f0e4298516651cd4a62b3b9ccd211096155cc36f6117ba505f18`
- `workflows_template.csv`: `5d4d3e201812cc6eefc35be8bfd78c2fabbd99cf6b4e55e396089f2f6def7d9b`

Output SHA-256: `7904a2649a5c66bd04b33b6cbdd75283d4a3c22c8989457f2d9fd56fe2c58b58`
