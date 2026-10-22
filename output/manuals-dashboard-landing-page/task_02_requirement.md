Task: Product Instruction Manual Landing Page
Assigned to: Peries
Priority: High
Objective:
Create a mobile-friendly HTML landing page where customers can find, view, and download product instruction manuals by SKU.
Customer journey:
Customer scans the QR code printed on the product packaging.
QR code opens the Instruction Manual landing page.
Customer enters the product SKU.
The system searches the existing PostgreSQL manual records.
The matching product and manual are displayed.
Customer can:
View the instruction manual online
Download the PDF
Search for another SKU
Required features:
Clean, mobile-responsive landing page
LEDsone/DC Voltage branding
SKU search box
Search button and Enter-key search
Case-insensitive SKU matching
Product information display:
Product SKU
Product name
Manual name
PDF availability
“View Manual” button
“Download PDF” button
Clear “SKU not found” message
Loading and database-error messages
No customer login required
Recommended QR structure:
General QR: /manuals
SKU-specific QR: /manuals?sku=PRODUCT-SKU
When a SKU-specific QR is scanned, the page should automatically load that product’s instruction manual while still allowing the customer to search for another SKU.
Technical requirements:
First inspect the existing PostgreSQL manual table and identify:
SKU column
Product-name column
PDF file, file path, or PDF URL column
Manual filename
Active/status column, if available
Connect to PostgreSQL through a secure backend API.
Do not expose database credentials in HTML or JavaScript.
Use read-only database access for the customer page.
Display only valid and active instruction manuals.
PDFs must open correctly on mobile and desktop browsers.
Downloads must keep a meaningful filename, preferably including the SKU.
Use exact SKU matching first; optional partial suggestions can be added later.
Acceptance checklist:
 QR code opens the landing page correctly
 SKU can be entered and searched
 Correct product manual is returned
 SKU matching works regardless of uppercase or lowercase
 PDF can be viewed online
 PDF can be downloaded
 Unknown SKU shows a helpful message
 Page works correctly on mobile
 Database credentials are not exposed
 Existing PostgreSQL data is not modified
 At least five real SKUs are tested
 Screenshots and test results are submitted
Deliverables:
Working HTML landing page
Secure backend connection to PostgreSQL
View and download functionality
QR-compatible page URL
Test report covering at least five SKUs
Short documentation explaining the database fields and page flow
Please begin by confirming the relevant PostgreSQL table and column names before developing the page.