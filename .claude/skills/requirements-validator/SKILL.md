---
name: requirements-validator
description: "Use when you need to review, validate, and improve requirements documents, acceptance criteria, or implementation briefs."
argument-hint: [requirements.md]
---

## Purpose

Review a requirements document or implementation brief and identify gaps, ambiguity, inconsistencies, or missing acceptance criteria before work begins.

## Inputs

- A requirements document, PRD, ticket, spec, or pasted text.
- Optional context such as business goals, constraints, or technical assumptions.

## Steps

1. Read the requirements and identify the intended outcome, scope, and stakeholders.
2. Check for clarity and completeness:
   - Missing functional or non-functional requirements
   - Ambiguous wording or undefined terms
   - Conflicting requirements or contradictions
   - Missing edge cases, dependencies, or constraints
3. Evaluate whether each requirement is:
   - Specific and measurable
   - Testable and observable
   - Feasible within the stated constraints
   - Traceable to a user need or business goal
4. Suggest improvements to make the requirements stronger and easier to implement.
5. Draft or refine acceptance criteria so each requirement can be verified.
6. Highlight risks, open questions, and items that require stakeholder confirmation.
7. Present a concise validation summary with priorities and recommended fixes.

## Output

- A validated review of the requirements document.
- A list of issues, risks, and missing details.
- Improved acceptance criteria and suggested wording where appropriate.
- Any unresolved questions that should be clarified before implementation.

## Guardrails

- Do not invent requirements that are not supported by the source material.
- Do not rewrite the entire document unless it is necessary for clarity.
- Preserve the original intent while improving structure and testability.
- Flag uncertainty instead of guessing.
- Prefer concrete, verifiable language over vague statements.
