---
name: customer-email-reply-drafter
description: "Use when someone asks to draft a reply to a customer email about orders, refunds, delivery, or product questions." 
argument-hint: [customer email]
---

## Purpose

Draft a polite, on-brand response to a customer email without sending it automatically.

## Inputs

- Customer email content pasted directly or provided as a file.
- Optional supporting context such as customer name, order number, or issue type.
- No external systems or credentials.

## Steps

1. Read the customer email and determine the main inquiry type: order status, delivery delay, return/refund request, product question, complaint, or general inquiry.
2. Extract any explicit details from the email: customer name, order number, relevant dates, product names, and the customer's specific issue.
3. If any required information is missing, do not invent it; instead leave a clear placeholder like `[insert tracking number]` or `[confirm refund amount]`.
4. Choose the appropriate tone:
   - empathetic and reassuring for delays or complaints
   - clear and solution-focused for refunds or order status
   - helpful and concise for product questions
5. Draft a complete reply with:
   - a greeting using the customer’s name if available
   - acknowledgement of their request or concern
   - a direct, helpful response or next step
   - a polite closing and a signature placeholder such as "Digitweb Lanka Customer Support"
6. Present the result as a draft only; do not send the email.
7. Offer a quick refinement option for tone, length, or formality.

## Output

- A ready-to-review draft customer reply in plain text.
- No email sending or external action.

## Guardrails

- Do not fabricate missing order or refund details.
- Do not send the email automatically.
- Make any placeholder requirements explicit for human review.
