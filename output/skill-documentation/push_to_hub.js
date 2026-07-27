// push_to_hub.js
// Reads an HTML file straight off disk and pushes it to varman_aios.hub_pages
// as member_name = 'peries'. No chunking, no inlining through chat — the
// file content is sent as a parameterized query value, so size and
// special characters are never a problem.
//
// Usage:
//   node push_to_hub.js "<path-to-html-file>" "<page-slug>" "<page-title>"
//
// Example:
//   node push_to_hub.js "C:\Users\LED 269\Desktop\Peries-Skills-Master\output\skill_documentation\skill-documentation-table-v3.html" "skill-library-overview" "Skill Library Overview"

const fs = require('fs');
const { Client } = require('pg');

const [, , htmlPath, pageSlug, pageTitle] = process.argv;

if (!htmlPath || !pageSlug || !pageTitle) {
  console.error('Usage: node push_to_hub.js "C:\Users\LED 269\Desktop\Peries-Skills-Master\output\skill-documentation\skill-documentation-table-v5.html" "skill-catalog" "Peries Skill Catalog — Claude Code Skills Reference"');
  process.exit(1);
}

if (!process.env.HUB_DATABASE_URL) {
  console.error('Missing HUB_DATABASE_URL environment variable. Set it before running this script — do not hardcode the password in this file.');
  process.exit(1);
}

const htmlContent = fs.readFileSync(htmlPath, 'utf8');
console.log(`Read ${htmlContent.length} characters from ${htmlPath}`);

const client = new Client({ connectionString: process.env.HUB_DATABASE_URL });

async function run() {
  await client.connect();
  const res = await client.query(
    `INSERT INTO varman_aios.hub_pages (member_name, page_slug, page_title, html_content)
     VALUES ($1, $2, $3, $4)
     ON CONFLICT (member_name, page_slug)
     DO UPDATE SET
       page_title   = EXCLUDED.page_title,
       html_content = EXCLUDED.html_content,
       updated_at   = now()
     RETURNING id, member_name, page_slug, page_title, updated_at;`,
    ['peries', pageSlug, pageTitle, htmlContent]
  );
  console.log('Pushed successfully:', res.rows[0]);
  await client.end();
}

run().catch((err) => {
  console.error('Push failed:', err.message);
  process.exit(1);
});
