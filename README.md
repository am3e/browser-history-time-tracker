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

Chrome's own `visit_duration` is unreliable (often zero, and it counts background-tab time), so time-on-page is estimated with **gap-based sessionization**: each visit counts as engaged until your next navigation anywhere, capped by a configurable idle cap (default 15 min). Gaps longer than the cap are treated as idle and the visit falls back to a 30-second floor. This is the same session logic web analytics tools use — a good estimate, but it can't distinguish reading from stepping away, and it only sees the browser.

The **📊 Time report** panel sums engaged hours per client per day for the current filter, and exports as CSV.

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
