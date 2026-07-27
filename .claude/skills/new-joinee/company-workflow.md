# Company Workflow Reference

Detailed teaching content for onboarding new employees to Claude Code + MCP + Skills.

## The Restaurant Analogy

Think of our AI system like a restaurant:

**You (the customer)** sit at a table and place an order. You don't go into the kitchen yourself — you tell the waiter what you want.

**The waiter (MCP)** takes your order to the kitchen. The waiter knows how to talk to the chefs and how to bring back your food. Without the waiter, you couldn't get your meal.

**The chef (Claude Code + Skills)** has recipes (skills) and knows how to cook. The chef takes your order, follows the right recipe, and prepares your meal.

**The kitchen (Data/Tools)** has all the ingredients, equipment, and tools. The chef needs these to make your food. Without ingredients, there's nothing to cook.

**The meal (Output)** is what you get back — the finished dish served to your table.

**You taste it (Human Review)** and decide if it's good. If something's wrong, you send it back.

**The receipt (Evidence)** is the record of what you ordered and what you received.

## The Seven-Layer Architecture

Every request flows through seven layers:

### Layer 1: Data & Tools
Where your company's information lives:
- **Databases** — Structured data (customer records, sales figures, inventory)
- **APIs** — Connections to other software (Slack, Jira, Salesforce)
- **File systems** — Documents, spreadsheets, code files
- **SaaS tools** — Cloud services (Google Workspace, Microsoft 365)

**Restaurant analogy:** The kitchen, ingredients, and equipment.

**Example:** Your company's customer database has names, emails, and purchase history.

### Layer 2: MCP (Model Context Protocol)
The connector layer that lets Claude talk to your tools:
- **What it is:** A standard way for AI to connect to external tools
- **How it works:** Each MCP server is a bridge to one tool/database
- **Why it matters:** Without MCP, Claude can only work with what you paste into chat

**Restaurant analogy:** The waiter who takes your order to the kitchen and brings back food.

**Example:** An MCP server connects Claude to your company's database so it can query customer data.

**Important:** MCP servers can access real data. Never share credentials or let Claude print raw configuration values.

### Layer 3: Claude Code + Skills
The intelligence layer that knows what to do:
- **CLAUDE.md** — Project-wide rules that always apply (like company policies)
- **Skills** — Task-specific procedures (like recipes for particular dishes)
- **Slash commands** — Shortcuts to invoke skills (`/start`, `/generate-report`)

**Restaurant analogy:** The chef who knows recipes (skills) and cooking techniques.

**Example:** The `sales-report` skill tells Claude exactly how to generate a monthly sales report.

### Layer 4: Processing
Claude reads the data, follows the skill instructions, and transforms it:
- Reads input from you or from MCP connections
- Follows the skill's step-by-step instructions
- Applies rules from CLAUDE.md
- Transforms data into the format you need

**Restaurant analogy:** The chef cooking your meal — chopping, seasoning, cooking.

**Example:** Claude pulls sales data from the database, calculates totals, and formats them into a report.

### Layer 5: Output
What you get back:
- **Text responses** — Answers in the chat window
- **Files** — Documents, reports, code files written to disk
- **Commands** — Actions executed on your system
- **Visual output** — HTML pages, charts, images

**Restaurant analogy:** The finished meal served to your table.

**Example:** A sales report file saved to `output/sales-report/monthly-report.md`.

### Layer 6: Human Review
You check Claude's work:
- **Never trust output blindly** — always review before using
- **Verify accuracy** — does the data match what you expected?
- **Check completeness** — is anything missing?
- **Confirm safety** — does this contain sensitive information?

**Restaurant analogy:** You taste the food and decide if it's good.

**Example:** Open the sales report and verify the numbers match your expectations.

### Layer 7: Evidence
The record of what happened:
- **Saved outputs** — Files generated during the session
- **Session logs** — Record of what was requested and done
- **Completion certificates** — Proof of training completion
- **Audit trails** — Who did what and when

**Restaurant analogy:** The receipt and order record.

**Example:** The onboarding completion certificate showing you passed both assessments.

## Common Tasks by Role

### Developers
- Generate code from specifications
- Review pull requests
- Write and run tests
- Debug issues
- Create documentation
- Refactor code

**Typical workflow:** Ask Claude to review code → MCP fetches from GitHub → Claude analyzes → Output: review comments

### Product Managers
- Summarize meeting notes
- Draft feature specs
- Analyze user feedback
- Generate status reports
- Create roadmaps

**Typical workflow:** Ask Claude to summarize feedback → MCP fetches from Jira → Claude processes → Output: summary document

### Designers
- Review design system compliance
- Generate component documentation
- Analyze accessibility issues
- Create style guides

**Typical workflow:** Ask Claude to check accessibility → Skill loads guidelines → Claude analyzes → Output: accessibility report

### Support Staff
- Summarize support tickets
- Draft response templates
- Analyze common issues
- Create knowledge base articles

**Typical workflow:** Ask Claude to summarize tickets → MCP fetches from Zendesk → Claude processes → Output: summary with trends

### Sales
- Generate sales reports
- Draft proposal documents
- Analyze pipeline data
- Create presentation content

**Typical workflow:** Ask Claude to generate report → MCP fetches from Salesforce → Claude formats → Output: sales report

### Data Analysts
- Query databases via MCP
- Generate data visualizations
- Create analysis reports
- Build dashboards

**Typical workflow:** Ask Claude to analyze data → MCP queries database → Claude processes → Output: analysis document

### Students/New Learners
- Understand how AI tools work
- Practice with guided exercises
- Build confidence with the system
- Learn company-specific workflows

**Typical workflow:** Ask Claude to explain something → Skill teaches concept → Claude provides examples → Output: learning summary

## The Six-Step Workflow

When you ask Claude to do something:

1. **You ask** — Type your request in natural language
   - "Generate a monthly sales report"
   - "Review this code for bugs"
   - "Summarize today's meeting notes"

2. **Claude detects** — Matches your request to the right skill
   - Looks at your request keywords
   - Finds the matching skill in `.claude/skills/`
   - If no match, uses general capabilities

3. **Skill loads** — Instructions for this specific task appear
   - Step-by-step procedure
   - Required inputs
   - Expected output format
   - Safety rules

4. **MCP connects** — If needed, fetches data from your tools
   - Connects to databases, APIs, files
   - Retrieves the data needed for the task
   - Respects access permissions

5. **Claude works** — Processes, transforms, generates
   - Follows the skill instructions
   - Applies project rules from CLAUDE.md
   - Transforms data into the requested format

6. **Output delivered** — Results appear in chat or as files
   - Text response in conversation
   - Files written to specified location
   - Commands executed (if permitted)

## Key Commands

| Command | What it does | When to use |
|---------|--------------|-------------|
| `/start` | Begin basic onboarding | First time using the system |
| `/new-joinee` | Begin thorough onboarding | New employee, need complete training |
| `/skill-name` | Invoke a specific skill | When you know which skill you need |
| `/context` | See what's loaded | Debugging or curious about context |
| `/permissions` | Manage tool permissions | Setting up access controls |

## Where Things Live

| What | Where | Purpose |
|------|-------|---------|
| Project rules | `CLAUDE.md` (root) | Always-loaded instructions |
| Skills | `.claude/skills/[name]/SKILL.md` | Task-specific procedures |
| MCP config | Project settings | Tool connections |
| Output files | `output/[skill-name]/` | Generated results |
| Onboarding | `onboarding-output/` | Training completion records |

## Safety Rules

1. **Never share secrets** — Don't paste API keys, passwords, or tokens into chat
2. **Review before using** — Always check Claude's output before acting on it
3. **Ask before executing** — Confirm before Claude runs commands that affect systems
4. **Understand what you're doing** — If you don't understand a command, don't run it
5. **Report problems** — If something seems wrong, stop and ask for help

## Getting Help

- **Ask Claude:** "How do I...?" or "Explain..."
- **Check your cheat sheet:** Generated during onboarding
- **Ask your manager:** For role-specific guidance
- **Ask your team:** For project-specific questions
- **Review CLAUDE.md:** For project rules and conventions

## Troubleshooting

**"Claude doesn't understand my request"**
- Try rephrasing more simply
- Use the exact skill name if you know it
- Check if the skill exists in `.claude/skills/`

**"Claude can't access my data"**
- Check if MCP is configured
- Verify you have access permissions
- Ask your admin to set up the MCP connection

**"The output looks wrong"**
- Review the skill instructions
- Check if CLAUDE.md has conflicting rules
- Try a more specific request

**"I don't know which skill to use"**
- Describe what you want to do
- Claude will suggest the right skill
- Or use `/start` for guided help
