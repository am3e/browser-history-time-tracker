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
3. Drag it onto the page (or copy it somewhere first and drop the copy).
4. Filter by keyword, domain, or date range; tag rows with a client/project label; export the filtered view as CSV.

Durations are Chrome's own `visit_duration` estimates and are often zero for quick visits.

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
