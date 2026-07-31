# record-a-skill Reference

Detailed rules referenced from [SKILL.md](SKILL.md): sensitive-content screening
layers, the provenance/confidence taxonomy, the `existing-asset-finder` and
`skill-builder` handoff schemas, and the test-requirements/fidelity-gate spec that
`skill-builder` Step 6 must execute for any skill built or extended through this
workflow.

---

## Sensitive-content screening (three layers)

Applies to every piece of evidence before it is copied, quoted, or referenced in any
persisted file. Layered, not exhaustive — never claim this guarantees detection of
every credential, PII item, or confidential detail.

**Layer 1 — deterministic pattern screening.** Regex/keyword rules flagging
recognizable structures: API keys and access tokens, password assignments,
authorization headers, private-key blocks, connection strings and credential-bearing
URLs, cloud-provider credentials, session cookies, email addresses, phone numbers,
payment-card-like numbers, contextually-sensitive IP addresses, customer/employee/
account/order/government-ID patterns, database usernames and passwords, secret-bearing
environment variables. A pattern match is a *finding requiring classification*, not
automatic proof of sensitivity. Never store the matched value itself in any report or
log.

**Layer 2 — Claude semantic review.** Judgment-based review for contextually sensitive
material structural patterns miss: customer or employee names, private conversation
excerpts, confidential business information, internal decisions or unpublished plans,
unrelated application/browser content, notifications or clipboard content, proprietary
identifiers, sensitive relationships between otherwise-ordinary fields, and
example-specific information unnecessary for workflow reconstruction. This layer is
judgment-based and must not be described as deterministic or complete.

**Layer 3 — user confirmation for uncertainty.** When a finding is ambiguous: never
reproduce the suspected value; identify only its category and a safe location (file
name, section, line range); explain why it may be sensitive; ask the user whether to
redact, exclude, or retain it; default to exclusion from persistent artifacts until
resolved.

**Classification per finding:** Confirmed secret / Confirmed personal-or-customer data
/ Confirmed confidential information / Contextually sensitive / Possible (needs
confirmation) / False positive / Safe content.

**Handling confirmed or unresolved sensitive content:**
1. Stop processing the affected portion if continued inspection could expose more data.
2. Never print, quote, summarize, or log the detected value.
3. Report only its category and safe location.
4. Request a redacted replacement, or approval to create a redacted working copy.
5. Replace retained values with descriptive placeholders — `[REDACTED_API_KEY]`,
   `[REDACTED_CUSTOMER_NAME]`, `[REDACTED_PRIVATE_MESSAGE]`, etc.
6. Re-screen the redacted copy before analysis or persistence.
7. Keep the original unchanged.
8. Require confirmation before writing the safe working copy.
9. If an active credential may have been exposed, advise the user to revoke or rotate
   it through the appropriate authorized process.

**Limits:** not equivalent to a dedicated enterprise secret-scanning or DLP system; do
not send evidence to an external scanning service without separate authorization;
absence of pattern matches is not proof evidence is safe; semantic judgment must not
silently override a deterministic finding; never preserve detected values merely for
auditability — store only category, safe location, handling decision, and redaction
status.

---

## Provenance and confidence (two separate axes)

Provenance identifies *where* information came from. Confidence indicates *how
reliable, complete, and unambiguous* the extracted interpretation is. Confidence is
never derived mechanically from provenance alone.

**Provenance categories:**
- Directly inspected file
- Directly inspected screenshot
- Directly inspected text or event log
- User-demonstrated terminal action
- User-stated action
- User-stated rule or decision
- Claude inference
- Conflicting evidence
- Unresolved information

**Confidence ratings** (qualitative only — no numeric percentages, which would imply
unsupported precision):
- **High** — clear, specific, internally consistent, adequately supported.
- **Medium** — plausible and usable, but based on incomplete, ambiguous, single-source,
  or partially verified evidence.
- **Low** — weakly supported, materially ambiguous, inferred, conflicting, incomplete,
  or not independently verified.

Examples: a directly inspected screenshot can still be Low confidence if the text is
unclear or context is missing. A user-stated rule can be High confidence when
explicitly stated, repeated, and confirmed as authoritative. A Claude inference can be
Medium confidence when strongly corroborated by multiple pieces of evidence.
Conflicting or unresolved information is normally Low confidence until resolved, but
must retain its conflict/unresolved status regardless of score.

**Assessment factors:** source clarity, source completeness, specificity, internal
consistency, corroboration across evidence, recency, authoritativeness, whether the
item was explicitly confirmed, whether interpretation was required, whether
conflicting evidence exists, whether missing context could materially change the rule.

**Required record format** per material item:
```
Statement:            [the rule/decision/step, in reusable form]
Provenance:            [one category from the list above]
Confidence:            High | Medium | Low
Evidence reference:    [which raw/analysis artifact supports this]
Confirmation status:   Confirmed | Unconfirmed
Notes:                 [assumptions, conflicts, or limitations, if any]
```

**Control rules:**
1. High confidence is not proof and does not replace the provenance record.
2. Never raise confidence merely because an item appears reasonable.
3. Never hide disagreement by averaging conflicting evidence into a confidence score.
4. Preserve conflicting evidence and ask which source is authoritative.
5. Never promote a Low-confidence material item into a stable workflow rule without
   user confirmation.
6. Clearly separate confirmed facts from Claude inferences.
7. If confidence changes after clarification, preserve the reason for the change.
8. Use ratings for material specification items, not every trivial interface action or
   incidental detail.

**Workflow gate before handoff:** material High-confidence items may proceed once
confirmed; material Medium-confidence items must be shown to the user for confirmation
or explicitly accepted as a limitation; material Low-confidence items must be
resolved, excluded, or explicitly accepted as a limitation; conflicting/unresolved
items must remain visibly marked and never be silently converted into stable rules.

---

## `existing-asset-finder` handoff

Invoke with a candidate asset profile: proposed name, purpose, triggers, inputs, major
operations, outputs, dependencies, boundaries. Consume the returned disposition
(REUSE / EXTEND / MERGE / CREATE / STOP) and its supporting evidence as-is.

## `skill-builder` handoff package

**For CREATE (skill-builder Mode 1):**
- `workflow-specification.md` (confirmed)
- `existing-asset-finder` CREATE report
- `target_scope: project | personal` (explicitly chosen, never defaulted)
- `target_path` (confirmed exact path)
- `scope_reason`
- `user_scope_confirmation`
- `approved_files`
- `permission_constraints`
- `validation_requirements` (see Test Requirements below)

**For EXTEND (skill-builder Mode 2):**
- `workflow-specification.md` (confirmed)
- `existing-asset-finder` EXTEND report
- Approved semantic diff: current behavior / required behavior / proposed changes /
  evidence+provenance / compatibility impact / affected files+tests / unresolved
  limitations
- Confirmed scope and target path
- Compatibility requirements
- `approved_files`
- Test and validation requirements
- Permission constraints

`record-a-skill` never edits the existing skill directly for an EXTEND — the approved
diff is a proposal `skill-builder` Mode 2 implements after its own audit.

---

## Test requirements and fidelity gate (executed by skill-builder Step 6)

`record-a-skill` specifies these requirements as part of the handoff; it never
executes them itself. Applies to every skill created or extended through this
workflow.

**10-category suite:**
1. **Trigger tests** — every intended invocation method works; for user-only skills,
   confirm explicit slash invocation (not natural-language auto-trigger).
2. **Non-trigger tests** — unrelated/similar requests do not activate the skill; for
   `disable-model-invocation: true`, confirm natural language does not auto-invoke it.
3. **Normal-input tests** — representative valid inputs complete successfully with
   expected output.
4. **Missing-input tests** — omitted required arguments/files/config/dependencies
   produce clear guidance, not unsafe partial execution.
5. **Invalid-input tests** — malformed, unsupported, contradictory, or unsafe inputs
   are rejected or handled per spec.
6. **Existing-output tests** — behavior when target files/directories already exist;
   confirm read-before-write, diff-before-update, overwrite prevention, approval
   boundaries.
7. **Permission-failure tests** — denied filesystem/connector/tool/API/authorization
   access is handled safely, using mocks/fixtures/restricted locations where
   practical; never weaken real permissions to manufacture a failure.
8. **Validation-failure tests** — deliberately invalid fixtures are correctly detected,
   reported clearly, and prevent false completion.
9. **Recovery tests** — the documented recovery path after a controlled interruption,
   partial result, validation failure, or unavailable dependency; confirm no fabricated
   success and no corruption of existing outputs.
10. **Repeat-execution tests** — running again against the same controlled state;
    confirm idempotency where required, safe updates, duplicate prevention, consistent
    results.

A category may be marked `NOT APPLICABLE` only with an explicit, evidence-backed
reason reviewed at final audit — never marked passed without an actual test run.

**Fidelity gate** — after the 10-category suite, compare the completed skill against
`workflow-specification.md`: every confirmed material stage is represented; inputs,
outputs, dependencies, validation rules, exceptions, and recovery behavior are
preserved; approval and permission boundaries remain intact; no unsupported behavior
or invented business rule was added; accepted limitations remain visible; CREATE and
EXTEND outcomes implement only the approved responsibility (no hard-coded
example-specific data from the demonstration survives into the generated skill).

**Test evidence record** per test: Test ID, Category, Requirement/spec reference,
Preconditions and fixture, Steps executed, Expected result, Actual result, Status
(PASS/FAIL/BLOCKED/NOT APPLICABLE), Evidence reference, Cleanup/restoration performed,
Follow-up action if applicable.

**Completion gate:** the skill may be considered complete only when all applicable
categories pass (or failures are corrected and rerun, or recorded as an explicitly
accepted limitation), blocked tests identify the exact blocker rather than being
reported as passes, no temporary test data or side effects remain, regression tests
confirm fixes didn't break prior behavior, the fidelity gate passes, and the final test
report is included in the handoff record.
