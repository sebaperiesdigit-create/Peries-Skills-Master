const fs = require('fs');
const path = require('path');

const repoRoot = 'C:\\Users\\LED 269\\Desktop\\Peries-Skills-Master';
const htmlPath = path.join(repoRoot, 'output', 'skill-documentation', 'skill-documentation-table-v5.html');
let html = fs.readFileSync(htmlPath, 'utf8');

// --- Extract skill-data block ---
const dataRe = /(<script id="skill-data" type="application\/json">\n)([\s\S]*?)(\n<\/script>)/;
const dataMatch = html.match(dataRe);
if (!dataMatch) throw new Error('skill-data block not found');
const skillData = JSON.parse(dataMatch[2]);

// --- Extract skill-files-data block ---
const filesRe = /(<script id="skill-files-data" type="application\/json">)([\s\S]*?)(<\/script>)/;
const filesMatch = html.match(filesRe);
if (!filesMatch) throw new Error('skill-files-data block not found');
const filesData = JSON.parse(filesMatch[2]);

console.log('BEFORE: skillData rows =', skillData.length, '| filesData keys =', Object.keys(filesData).length);

// ============================================================
// 1. Update start (001) row Notes
// ============================================================
const startRow = skillData.find(r => r['Skill ID'] === '001');
if (!startRow) throw new Error('start row (001) not found in skillData');
const oldStartNotes = startRow['Notes'];
startRow['Notes'] = "Only ever writes files after you explicitly say okay, and only inside the onboarding-output/ folder — it won't touch anything else. Every comprehension check is now a quick click, not typing. If a prior session exists, it offers a refresher or a resume instead of always starting over \u2014 and if you run out of time or confidence mid-session, it saves your place to onboarding-output/onboarding-progress.md so you can pick up right where you left off.";

// ============================================================
// 2. Insert grill-me (015) row into skillData, alphabetically
//    after first-task-mapper (006), before markdown-document-formatter (008)
// ============================================================
const insertAfterIdx = skillData.findIndex(r => r['Skill ID'] === '006');
if (insertAfterIdx === -1) throw new Error('first-task-mapper row (006) not found, cannot position grill-me');

const grillMeRow = {
  "Skill ID": "015",
  "Skill Name": "/grill-me",
  "Created Date": "2026/07/24",
  "Purpose": "Stress-tests any plan, design, or decision \u2014 a new skill idea, an architecture choice, a process change \u2014 by asking one question at a time, each with a recommended answer, until every decision, dependency, assumption, risk, and branch is nailed down.",
  "When to Use": "Say things like \u201cgrill me on this,\u201d \u201cstress-test this plan or idea,\u201d \u201cpoke holes in this,\u201d or \u201cmake sure I've thought of everything\u201d \u2014 anytime you're about to commit to something that hasn't been fully thought through.",
  "Where to Use": "Anywhere in this project, right before committing to a plan, design, or decision \u2014 pairs naturally before /skill-builder's own discovery interview, but isn't limited to skills.",
  "How to Use": "Type /grill-me followed by the plan or topic, or just say you want it grilled and point at what's being discussed \u2014 Claude will use whatever's already in the conversation if you don't specify a topic.",
  "Input Requirements": "A plan, idea, or design to interrogate \u2014 given as an argument, or just whatever's currently being discussed. Nothing else needed to start.",
  "Expected Output": "A one-question-at-a-time interview in chat, each with a recommended answer you can pick with one click \u2014 tracked as a visible task list until every open item is resolved. Ends with a structured summary of every decision made; no file is written unless you ask.",
  "Status": "Testing",
  "Version": "Version 1.0",
  "Notes": "Never builds or implements anything itself, even once the plan becomes fully clear \u2014 it only interrogates and hands back a resolved plan as a separate follow-up. If the open-items list grows past roughly 15-20, it pauses to suggest splitting the plan into smaller pieces instead of continuing indefinitely."
};

skillData.splice(insertAfterIdx + 1, 0, grillMeRow);

console.log('AFTER insert: skillData rows =', skillData.length);
console.log('New row order (Skill ID: Skill Name):');
skillData.forEach(r => console.log('  ', r['Skill ID'], r['Skill Name']));

// ============================================================
// 3. Refresh start (001) Files entry (fileContent + guideContent)
// ============================================================
const startFileContent = fs.readFileSync(path.join(repoRoot, '.claude', 'skills', 'start', 'SKILL.md'), 'utf8');
filesData['001'].fileContent = startFileContent;
filesData['001'].guideContent =
`# Install & use: Start

This guide was generated from the repository source file at \`.claude/skills/start/SKILL.md\`. The copy offered here for download is named \`SKILL_start.md\` for identification in the catalog only \u2014 when installing it, place or rename it to match the path Claude Code actually requires.

## 1. Save the file
Save the downloaded \`SKILL_start.md\` as:

    .claude/skills/start/SKILL.md

(a directory named exactly \`start\`, containing a file named exactly \`SKILL.md\` \u2014 Claude Code only auto-discovers skills at this path).

## 2. Trigger it
Invoke \`/start\` or matching natural language ("I'm new here," "onboard me," "explain how this works," "how does our AI system work," or general confusion about MCP/Skills while asking a task question). Runs directly in the main conversation \u2014 no subagent fork \u2014 since it's a back-and-forth teaching session.

## 3. What to provide
Your role and whether you've used Claude Code/MCP/AI coding tools before (asked conversationally in Step 1). If a prior onboarding session exists (in progress or completed), it asks upfront whether you want to resume, get a quick refresher, or start fresh.

## 4. What you'll get back
An interactive lesson in chat covering the four-layer model (Data/MCP/Claude+Skills/Output), with a multiple-choice comprehension check after each section. Optionally, only after you explicitly say yes: a cheat sheet and/or completion summary saved to \`onboarding-output/\`. If you pause mid-session, your progress is saved to \`onboarding-output/onboarding-progress.md\` so \`/start\` can pick up where you left off next time.

## Notes
Only ever writes files after explicit confirmation, and only inside \`onboarding-output/\` \u2014 never anywhere else. Source: \`.claude/skills/start/SKILL.md\`.

## Status of this information
Created Date: 2026-07-17 \u00b7 Status: Testing \u00b7 Version: Version 1.0
Source of truth: \`.claude/skills/start/SKILL.md\` in the Peries-Skills-Master repository. This guide is a companion, generated from that file's own frontmatter and content \u2014 it is not itself part of the skill and is not required by Claude Code.
`;
// tryPhrase left unchanged \u2014 frontmatter description text didn't change

// ============================================================
// 4. Add grill-me (015) Files entry
// ============================================================
const grillMeFileContent = fs.readFileSync(path.join(repoRoot, '.claude', 'skills', 'grill-me', 'SKILL.md'), 'utf8');

filesData['015'] = {
  filename: "SKILL_grill_me.md",
  fileContent: grillMeFileContent,
  guideFilename: "grill-me-install-guide.md",
  guideContent:
`# Install & use: Grill Me

This guide was generated from the repository source file at \`.claude/skills/grill-me/SKILL.md\`. The copy offered here for download is named \`SKILL_grill_me.md\` for identification in the catalog only \u2014 when installing it, place or rename it to match the path Claude Code actually requires.

## 1. Save the file
Save the downloaded \`SKILL_grill_me.md\` as:

    .claude/skills/grill-me/SKILL.md

(a directory named exactly \`grill-me\`, containing a file named exactly \`SKILL.md\` \u2014 Claude Code only auto-discovers skills at this path).

## 2. Trigger it
Invoke \`/grill-me [topic or plan]\` or matching natural language ("grill me on this," "stress-test this plan or idea," "poke holes in this," "make sure I've thought of everything"). Runs directly in the main conversation, asking one question at a time via clickable multiple-choice options with a recommended answer.

## 3. What to provide
\`$ARGUMENTS\` \u2014 the plan, design, or idea to interrogate. If it's missing, the skill falls back to whatever plan is already being discussed in the conversation, or asks what you want grilled.

## 4. What you'll get back
A one-question-at-a-time interview, tracked as a visible task list of open decisions, dependencies, assumptions, risks, and branches \u2014 each resolved via a clickable recommended answer. Ends with a structured "Grill Session Summary": resolved decisions, confirmed dependencies, checked assumptions, addressed risks, and a ready-to-execute plan.

## Notes
Never builds, implements, or writes code/files itself \u2014 it only interrogates and hands back a resolved plan, which is then a separate follow-up request (e.g. to /skill-builder). If the open-items list grows past roughly 15-20, it pauses to suggest splitting the plan into smaller pieces rather than continuing indefinitely. Source: \`.claude/skills/grill-me/SKILL.md\`.

## Status of this information
Created Date: 2026-07-24 \u00b7 Status: Testing \u00b7 Version: Version 1.0
Source of truth: \`.claude/skills/grill-me/SKILL.md\` in the Peries-Skills-Master repository. This guide is a companion, generated from that file's own frontmatter and content \u2014 it is not itself part of the skill and is not required by Claude Code.
`,
  tryPhrase: "Someone asks to grill me on this, stress-test this plan or idea, poke holes in this, or make sure I've thought of everything before committing to a plan, design, or decision."
};

console.log('AFTER: filesData keys =', Object.keys(filesData).length);

// ============================================================
// 5. Write back into HTML
// ============================================================
const newDataBlock = dataMatch[1] + JSON.stringify(skillData, null, 0) + dataMatch[3];
html = html.replace(dataRe, () => newDataBlock);

const newFilesBlock = filesMatch[1] + JSON.stringify(filesData, null, 0) + filesMatch[3];
html = html.replace(filesRe, () => newFilesBlock);

fs.writeFileSync(htmlPath, html, 'utf8');
console.log('WROTE', htmlPath);
