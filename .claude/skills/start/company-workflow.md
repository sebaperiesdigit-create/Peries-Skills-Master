# Company Workflow Reference

Generic training examples for onboarding new employees to Claude Code + MCP + Skills.

## Section 1: The Four-Layer Architecture

Every request flows through four layers:

### Layer 1: Data & Tools
Where your company's information lives:
- Databases (Postgres, MySQL, etc.)
- APIs (internal services, third-party tools)
- File systems (documents, configs)
- SaaS tools (Salesforce, Jira, Slack)

**Restaurant analogy:** The kitchen, ingredients, and equipment.

### Layer 2: MCP (Model Context Protocol)
The connector layer that lets Claude talk to your tools:
- Each MCP server is a bridge to one tool/database
- Claude sends requests through MCP, gets results back
- Configured in your project's MCP settings

**Restaurant analogy:** The waiter who takes your order to the kitchen and brings back food.

### Layer 3: Claude Code + Skills
The intelligence layer that knows what to do:
- CLAUDE.md: Always-loaded project rules
- Skills: Task-specific procedures (loaded on demand)
- Slash commands: `/start`, `/generate-report`, etc.

**Restaurant analogy:** The chef who knows recipes (skills) and cooking techniques.

### Layer 4: Output
What you get back:
- Text responses in chat
- Files written to disk
- Commands executed
- Visual output (HTML, charts)

**Restaurant analogy:** The meal served to you.

## Section 2: Common Tasks by Role

### Developers
- Generate code from specifications
- Review pull requests
- Write and run tests
- Debug issues
- Create documentation

### Product Managers
- Summarize meeting notes
- Draft feature specs
- Analyze user feedback
- Generate status reports

### Designers
- Review design system compliance
- Generate component documentation
- Analyze accessibility issues

### Support
- Summarize support tickets
- Draft response templates
- Analyze common issues

### Sales
- Generate sales reports
- Draft proposal documents
- Analyze pipeline data

### Data Analysts
- Query databases via MCP
- Generate data visualizations
- Create analysis reports

## Section 3: The Six-Step Workflow

When you ask Claude to do something:

1. **You ask** — Type your request in natural language
2. **Claude detects** — Matches your request to the right skill
3. **Skill loads** — Instructions for this specific task appear
4. **MCP connects** — If needed, fetches data from your tools
5. **Claude works** — Processes, transforms, generates
6. **Output delivered** — Results appear in chat or as files

## Section 4: Key Commands

| Command | What it does |
|---------|--------------|
| `/start` | Begin this onboarding session |
| `/skill-name` | Invoke a specific skill |
| `/context` | See what's loaded in Claude's context |
| `/permissions` | Manage tool permissions |

## Section 5: Where Things Live

| What | Where |
|------|-------|
| Project rules | `CLAUDE.md` (root of project) |
| Skills | `.claude/skills/[name]/SKILL.md` |
| MCP config | Project settings |
| Output files | `output/[skill-name]/` |

## Section 6: Safety Rules

- Never share API keys or secrets in chat
- Don't run commands you don't understand
- Ask before executing destructive operations
- If something seems wrong, stop and ask

## Section 7: Getting Help

- Ask Claude: "How do I...?"
- Check the cheat sheet (generated in Step 9)
- Ask your manager or team lead
- Review CLAUDE.md for project-specific rules

## Section 8: Quick Reference Card

```
┌─────────────────────────────────────────┐
│  Claude Code + MCP + Skills Quick Ref   │
├─────────────────────────────────────────┤
│  Four Layers:                           │
│  1. Data/Tools → Where info lives       │
│  2. MCP → Connects Claude to tools      │
│  3. Skills → Task instructions          │
│  4. Output → What you get back          │
├─────────────────────────────────────────┤
│  Key Files:                             │
│  • CLAUDE.md = Project rules            │
│  • .claude/skills/ = Task procedures    │
│  • MCP config = Tool connections        │
├─────────────────────────────────────────┤
│  Commands:                              │
│  • /start = Begin training              │
│  • /skill-name = Run a skill            │
│  • /context = See what's loaded         │
└─────────────────────────────────────────┘
```
