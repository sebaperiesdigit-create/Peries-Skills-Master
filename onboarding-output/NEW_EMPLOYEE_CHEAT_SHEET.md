# New Employee Cheat Sheet
**Name:** Joy
**Role:** Automation Trainee
**Date:** 2026-07-23

## The Seven-Layer Model
| Layer | What it does |
|-------|-------------|
| 1. Data/Tools | Company databases, APIs, files |
| 2. MCP | Connectors to your tools |
| 3. Claude Code + Skills | AI with task instructions |
| 4. Processing | Claude transforming data |
| 5. Output | Results, files, responses |
| 6. Human Review | You check the work |
| 7. Evidence | Logs, saved outputs |

## Your First Task
No task was formally assigned yet at onboarding time. Session used a placeholder example — "automate a weekly order summary" — to build a task map:

```
Task: Automate a weekly order summary
Layers involved: Data/Tools (orders CSV/database), MCP (fetch connector),
  Claude+Skills (order-summary-report), Processing (totals/top products),
  Output (output/order-summary-report/), Human Review (check the numbers),
  Evidence (saved file)
Relevant skills: order-summary-report, order-status-summary
MCP connectors needed: connector to wherever raw orders data lives (e.g. Postgres, or a CSV)
```

## Key Commands
- `/new-joinee` — Re-run this onboarding session
- `/skill-name` — Run a specific skill (replace `skill-name` with the actual skill name)
- Natural language also works — just describe what you need

## Who to Ask for Help
Not yet confirmed — check with whoever manages this project's `.claude/` setup for skill or MCP connector questions.

## Safety Rules for Your Role
- Never share credentials, API keys, or tokens in chat
- Always review Claude's output before using it — placeholders like `[insert tracking number]` mean data is missing, not that something is broken
- Ask before letting Claude execute anything that affects real systems
- If a skill or connector seems missing, ask rather than trying to work around it
