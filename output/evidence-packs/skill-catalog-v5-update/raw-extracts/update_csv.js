const fs = require('fs');
const path = require('path');

const repoRoot = 'C:\\Users\\LED 269\\Desktop\\Peries-Skills-Master';
const csvPath = path.join(repoRoot, 'output', 'skill-documentation', 'inputs', 'Skills_documentation_table -Final.csv');
const htmlPath = path.join(repoRoot, 'output', 'skill-documentation', 'skill-documentation-table-v5.html');

// --- Minimal RFC4180 CSV parser (handles quoted fields with embedded commas/quotes/newlines) ---
function parseCSV(text) {
  const rows = [];
  let row = [];
  let field = '';
  let inQuotes = false;
  let i = 0;
  while (i < text.length) {
    const c = text[i];
    if (inQuotes) {
      if (c === '"') {
        if (text[i + 1] === '"') { field += '"'; i += 2; continue; }
        inQuotes = false; i++; continue;
      }
      field += c; i++; continue;
    } else {
      if (c === '"') { inQuotes = true; i++; continue; }
      if (c === ',') { row.push(field); field = ''; i++; continue; }
      if (c === '\r' && text[i + 1] === '\n') { row.push(field); rows.push(row); row = []; field = ''; i += 2; continue; }
      if (c === '\n') { row.push(field); rows.push(row); row = []; field = ''; i++; continue; }
      field += c; i++; continue;
    }
  }
  if (field.length > 0 || row.length > 0) { row.push(field); rows.push(row); }
  return rows.filter(r => r.length > 1 || (r.length === 1 && r[0] !== ''));
}

function csvField(value) {
  const s = String(value ?? '');
  if (/[",\r\n]/.test(s)) return '"' + s.replace(/"/g, '""') + '"';
  return s;
}

// --- Load current HTML skill-data (already updated: 001 refreshed, 015 added) ---
const html = fs.readFileSync(htmlPath, 'utf8');
const dm = html.match(/<script id="skill-data" type="application\/json">\n([\s\S]*?)\n<\/script>/);
const skillData = JSON.parse(dm[1]);
const cols = ["Skill ID","Skill Name","Created Date","Purpose","When to Use","Where to Use","How to Use","Input Requirements","Expected Output","Status","Version","Notes"];

const row001 = skillData.find(r => r['Skill ID'] === '001');
const row015 = skillData.find(r => r['Skill ID'] === '015');
if (!row001 || !row015) throw new Error('Expected rows not found in HTML skill-data');

// --- Parse existing CSV ---
const csvRaw = fs.readFileSync(csvPath, 'utf8');
const rows = parseCSV(csvRaw);
const header = rows[0];
console.log('CSV header:', header);
const idIdx = header.indexOf('Skill ID');

let replaced001 = false;
const updatedRows = rows.map((r, idx) => {
  if (idx === 0) return r;
  if (r[idIdx] === '001') {
    replaced001 = true;
    const newRow = cols.map(c => row001[c]);
    newRow.push(r[header.indexOf('Files')] || ''); // preserve empty Files column
    return newRow;
  }
  return r;
});
if (!replaced001) throw new Error('Row 001 not found in CSV to replace');

// Append 015 row
const new015Row = cols.map(c => row015[c]);
new015Row.push(''); // Files column blank, consistent with all other rows
updatedRows.push(new015Row);

console.log('Rows before:', rows.length - 1, '-> after:', updatedRows.length - 1);

// --- Serialize back to CSV (CRLF, matching original file's line endings) ---
const usesCRLF = csvRaw.includes('\r\n');
const eol = usesCRLF ? '\r\n' : '\n';
const outLines = updatedRows.map(r => r.map(csvField).join(','));
const out = outLines.join(eol) + eol;

fs.writeFileSync(csvPath, out, 'utf8');
console.log('WROTE', csvPath);
