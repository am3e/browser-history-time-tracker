# Browser History Time Tracker

A single-page, fully client-side tool for turning your Chrome browsing history into billable-time data. Drop your Chrome `History` SQLite file in, then filter, sort, tag rows by client/project, and export a CSV.

**Live at [timetracker.am3e.dev](https://timetracker.am3e.dev)**

## Privacy

All processing happens locally in your browser via [sql.js](https://sql.js.org/) (SQLite compiled to WebAssembly). Your history file is never uploaded anywhere.

## Usage

1. Quit Chrome (the database is locked while Chrome runs).
2. Locate your `History` file:
   - **Mac:** `~/Library/Application Support/Google/Chrome/Default/History`
   - **Windows:** `%LOCALAPPDATA%\Google\Chrome\User Data\Default\History`
   - **Linux:** `~/.config/google-chrome/Default/History`
3. Drag it onto the page (or copy it somewhere first and drop the copy). The file is cached in the browser's IndexedDB, so it restores automatically next visit — **⬆ New file** replaces it.
4. Filter by keyword, domain, client, or date range; tag rows with Client/Project labels; export the filtered view as CSV.

### Auto-tagging

Under **⚙ Client mappings**, define rules like "URL contains `github.com/acme` → Client `Acme`", then hit **Apply to imported rows** to tag the loaded history and see how many rows matched. Matching rows are tagged automatically (shown in italics); typing in a row overrides the rule.

**⚡ Auto-map** lists every domain in the import once — with its site name, visit count, and estimated hours — so you can map whole domains to a client/project in one pass, or **Hide** noise domains to exclude them from the table, report, and exports. **Auto-hide** bulk-hides every domain under a visit threshold (default 20) — domains carrying any client/project tag are protected from it, and **Unhide all** reverses it. Precedence: manual row tag > URL rule > domain mapping. Rules, manual tags, and settings persist in the browser's localStorage — nothing is uploaded.

### Time estimation

Chrome's own `visit_duration` is unreliable (often zero, and it counts background-tab time), so time is estimated with **per-site session clustering**: repeat visits to the same site chain into one session while the gap between them stays within the session gap (default 5 min, configurable). A session's duration is its span — first visit to last — shown in decimal hours on the session's first row (`—` on the rest, so sums never double-count). Isolated single visits get a 1-minute floor. Example: visits recurring from 11:45 AM to 1:45 PM report as one 2.00-hour session. Caveats: it can't distinguish reading from stepping away, sessions on two sites at once both count in full, and it only sees the browser.

The **📊 Time report** opens by default: Total Hours and Hidden Hours metrics (hidden = time on hidden domains in the range, excluded from totals), then a bar chart of client totals, then the day-by-day breakdown table. Click a bar to drill into that client — the day table and the visits table below filter to it (the chart keeps all clients visible for context); click again to clear. The date range defaults to the current month, with **This month** / **Last month** / **All time** presets; date and dropdown filters apply immediately on change. The report CSV exports one row per date × client × domain with the site name and hours.

## Development

It's one file — open `index.html` in a browser. No build step.

## Deployment

Static site on AWS: private S3 bucket behind CloudFront with an ACM certificate, DNS in Route 53. All managed by Terraform in [`terraform/`](terraform/):

```sh
cd terraform
terraform init
terraform apply
```

`terraform apply` also uploads `index.html`, so re-running it after content changes is the deploy step.
