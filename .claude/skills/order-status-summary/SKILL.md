---
name: order-status-summary
description: "Use when someone asks to summarize order status from a CSV, identify delayed orders, or report delivery buckets." 
argument-hint: [orders.csv]
---

## Purpose

Read an order export CSV and generate a plain-text report that classifies each order into Delivered, Cancelled, Shipped on time, Delayed (not yet shipped), or Delayed (past expected delivery).

## Inputs

- A CSV path or pasted CSV content containing order records.
- Expected columns: `order_id`, `customer_name`, `order_date`, `ship_date`, `expected_delivery_date`, and `status`.
- No file modifications are performed.

## Steps

1. Confirm the user has supplied the correct CSV path or pasted file content.
2. Read the CSV in read-only mode and validate required columns.
3. Map equivalent column names if the user has a slightly different header, and note the mapping used.
4. Parse each row and classify it into one bucket:
   - **Delivered**: status indicates delivered/completed.
   - **Cancelled**: status indicates cancelled/refunded.
   - **Shipped on time**: has `ship_date` and is within expected delivery timing.
   - **Delayed (not yet shipped)**: no `ship_date` and more than 3 days since `order_date`.
   - **Delayed (past expected delivery)**: expected delivery date has passed without delivery.
5. Count total orders and bucket totals.
6. Build a delayed-order table sorted by days overdue, with most overdue orders first.
7. Report any skipped or invalid rows and why they were skipped.

## Output

- A clear summary report with total orders, counts per bucket, and a flagged delayed-orders table.
- Notes about any missing or malformed data.
- No file writes, no external data transmission.

## Guardrails

- Do not invent missing order details.
- Do not modify the CSV.
- If required columns are missing, stop and ask the user to correct the input.
