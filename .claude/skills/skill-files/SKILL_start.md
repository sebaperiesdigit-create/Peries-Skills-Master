---
name: start
description: Use when someone says "I'm new here", "onboard me", "explain how this works", "how does our AI system work", or shows confusion about MCP/Skills while asking a task question. Interactive training session for new employees.
---

## What This Skill Does

Guides new employees through an interactive onboarding session that teaches how Claude Code + MCP + Skills work together. Checks understanding after each section and personalizes examples to their role.

## Process

### Step 1: Role & Calibration

Ask the user:
1. What's your role? (dev, PM, designer, support, sales, data, etc.)
2. Have you used Claude Code, MCP, or AI coding tools before?

Use their answers to:
- Adapt examples throughout (dev gets code/PR examples, support gets ticket examples, etc.)
- Calibrate quiz difficulty (beginner gets recall questions, experienced gets applied questions)
- If they're advanced, offer to skip to Step 10 (Role Personalization) and Step 8.5 (Real Project Files)

### Step 2: Big Picture

Teach the four-layer model using three delivery methods in sequence, then one comprehension check.

**A. Diagram first** — Render this architecture diagram:

```
┌──────────────────────────────────────────────────┐
│  YOU: "Show me this week's orders"               │
└────────────────────┬─────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────┐
│  LAYER 4 — OUTPUT                                │
│  📄 Report  📊 Chart  📋 Table  💬 Response     │
└────────────────────▲─────────────────────────────┘
                     │
┌────────────────────┴──────────────────────────────┐
│  LAYER 3 — CLAUDE CODE + SKILLS                   │
│  🧠 Claude reads your request                     │
│  📋 Loads the matching skill (recipe book)        │
│  🔧 Follows instructions                          │
└────────────────────▲──────────────────────────────┘
                     │
┌────────────────────┴──────────────────────────────┐
│  LAYER 2 — MCP (Bridge / Waiter)                  │
│  🔗 Asks database via connector                   │
│  🔗 Sends API requests                            │
│  🔗 Reads/writes files                            │
└────────────────────▲──────────────────────────────┘
                     │
┌────────────────────┴──────────────────────────────┐
│  LAYER 1 — DATA & TOOLS (Kitchen / Ingredients)   │
│  🗄️  Databases  🌐 APIs  📁 Files                │
└───────────────────────────────────────────────────┘
```

**B. Then the restaurant analogy:**

| Layer | Restaurant | Your System |
|-------|-----------|-------------|
| **Data/Tools** | Kitchen, ingredients, equipment | Company data, APIs, databases |
| **MCP** | Waiter taking orders to kitchen | Connectors that link Claude to your tools |
| **Claude Code + Skills** | Chef with recipes (skills) | AI with instructions for specific tasks |
| **Output** | Meal served to customer | Results, files, responses |

Walk through the flow: You (customer) -> MCP (waiter) takes your order -> Chef (Claude + Skills) follows a recipe -> Kitchen (Data) has ingredients -> Waiter brings the meal (Output).

**C. Then the short table explaining each layer:**

| Layer | What it does |
|-------|-------------|
| **Data/Tools** | Where your company information lives — databases, APIs, spreadsheets |
| **MCP** | The standard bridge that lets Claude talk to those tools safely |
| **Claude Code + Skills** | The AI brain with reusable recipe books (skills) for each task |
| **Output** | The final result — a file, a chart, a summary, a command |

**D. Comprehension check** (one question, then move on):
**"In your own words, what is one thing from each layer?"**

If they answer well, praise and proceed. If they struggle, re-explain using the restaurant analogy before continuing.

Also share this interactive visual for hands-on exploration:
https://claude.ai/public/artifacts/26d37fe5-9ec7-4c51-a020-0c9aa3cc3505

### Step 3: Data Layer

Explain where company data lives and how Claude accesses it:
- CLAUDE.md = project-wide rules (always loaded)
- Skills = task-specific procedures (loaded when invoked)
- MCP connectors = bridges to external tools

**Check-in:** "If you wanted Claude to follow a coding style rule, where would you put it?"

### Step 4: MCP Layer

Explain MCP (Model Context Protocol):
- What it is: A standard way for Claude to talk to external tools
- How it works: Connector sits between Claude and the tool
- Examples: Database queries, API calls, file system access

**Check-in:** "Why can't Claude just directly call a database without MCP?"

### Step 5: Claude Code + Skills

Explain how skills work:
- Skills = reusable instructions (SOPs for Claude)
- Invoked via `/slash-command` or natural language
- CLAUDE.md rules always apply inside skills
- Supporting files load only when needed

**Check-in:** "What's the difference between CLAUDE.md and a skill?"

### Step 6: Output Layer

Explain what Claude produces:
- Text responses in conversation
- Files written to disk
- Commands executed
- Visual output (HTML, charts)

**Check-in:** "Name two types of output Claude can produce."

### Step 7: Full Workflow Example

Walk through a complete example using a sales-report scenario (adapt to user's role):

1. User types: "Generate a monthly sales report"
2. Claude detects this matches the `sales-report` skill
3. Skill loads: instructions for pulling data, formatting, outputting
4. MCP connectors fetch data from database
5. Claude processes and formats the report
6. Output: Sales report file in `output/sales-report/`

**Check-in:** "Which layer was doing the actual work of fetching data?"

### Step 7.5: Real Project Files (Optional)

Ask: "Would you like to see what this looks like in your actual project?"

If yes, read (read-only, never print sensitive content):
- `.claude/skills/` directory — show what skills exist
- MCP configuration — describe what's connected (don't print raw config/keys)
- CLAUDE.md — show project-specific rules

If no real files exist, say: "There's nothing connected yet in this project — that's normal, here's what it'll look like once there is."

### Step 8: Comprehension Check

Run a comprehension check adjusted to their skill level:
- **Beginner:** Recall questions ("What does MCP stand for?")
- **Experienced:** Applied questions ("Why would this task fail without the MCP step?")

Re-teach any weak spots before moving on. Don't skip this gate.

### Step 9: Generate Cheat Sheet

Before writing, confirm with the user: *"I'd like to save a cheat sheet to output/onboarding/cheat-sheet.md — is that okay?"* Only write after they say yes.

Use this fixed template, filling in their specific details:

```markdown
# Onboarding Cheat Sheet
**Role:** {{ role }}
**Date:** {{ date }}

## The Four-Layer Model
```
┌──────────────────────────────────────────────────┐
│  LAYER 4 — OUTPUT                                │
│  Files, charts, summaries, commands              │
├──────────────────────────────────────────────────┤
│  LAYER 3 — CLAUDE CODE + SKILLS                  │
│  AI brain + recipe books for each task           │
├──────────────────────────────────────────────────┤
│  LAYER 2 — MCP (Bridge)                          │
│  Connectors linking Claude to tools/data         │
├──────────────────────────────────────────────────┤
│  LAYER 1 — DATA & TOOLS                          │
│  Databases, APIs, spreadsheets, files            │
└──────────────────────────────────────────────────┘
```

## Key Commands
- `/start` — Start this onboarding session
- `/skill-name` — Run a specific skill (replace `skill-name` with the actual skill name)
- Natural language also works — just describe what you need

## My Weak Spots (re-taught in session)
- {{ weak-spot-1 }}
- {{ weak-spot-2 }}

## Layer Summary
| Layer | What it does |
|-------|-------------|
| **Data/Tools** | Company info — databases, APIs, files |
| **MCP** | Standard bridge to connect Claude to tools |
| **Claude + Skills** | AI brain following recipe instructions |
| **Output** | Final result you see or use |
```

**Important:** After writing, tell the user the file was saved and where to find it.

Write to `output/onboarding/cheat-sheet.md`. Never write anywhere else.

### Step 10: Role Personalization

Explain what this means for their specific job:
- What tasks they'll commonly ask Claude to do
- Which skills are most relevant to their role
- What output files they'll work with
- Who to ask for help if something breaks

### Step 11: Confidence Check + Close

Ask: "On a scale of 1-5, how confident do you feel using this system?"

- **4-5:** Offer optional completion summary, confirm they're ready
- **3:** Re-teach the weakest area, then re-check
- **1-2:** Offer to pause and continue later, or re-teach from the start

If they want a completion summary, confirm first: *"I'll save a completion summary to output/onboarding/completion-summary.md — okay?"*

Only write after they say yes. Use this fixed template:

```markdown
# Onboarding Completion Summary
**Role:** {{ role }}
**Date:** {{ date }}
**Confidence Score:** {{ score }}/5

## Sections Re-Taught
- {{ section-1 }}
- {{ section-2 }}

## Next Steps for {{ role }}
1. {{ next-step-1 }}
2. {{ next-step-2 }}
3. {{ next-step-3 }}

## Notes
Generated by the `/start` onboarding skill.
```

**Important:** After writing, tell the user the file was saved and where to find it.

Write to `output/onboarding/completion-summary.md`. Never write anywhere else.

## File-Writing Safety

- The only files this skill may write are:
  - `output/onboarding/cheat-sheet.md` (Step 9, with user confirmation)
  - `output/onboarding/completion-summary.md` (Step 11, with user confirmation)
- Never create files before the user reaches the output stage (Step 9 or later)
- Always ask for confirmation before writing any file
- Write only inside `output/onboarding/` — never elsewhere
- Never modify project source files, .claude/ configuration, MCP settings, credentials, or external systems
- Never print raw config contents, keys, or tokens
- Never run destructive commands

## Session Guidelines

- Default to a lean pace (~15 min), but allow longer if the employee is genuinely confused
- Never fabricate company-specific facts not present in company-workflow.md or CLAUDE.md
- If user goes quiet or says "this is too much", offer to pause or simplify
- Step 7.5 reads are opt-in only, never automatic
