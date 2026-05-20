# AGENTS.md

Guidance for automated agents working in this repository.

## Repository shape

- Content repo: a curated collection of links, manuals, and one-liners.
- Primary editable file: `README.md` (large, single-file table of contents + entries).
- Other tracked files: `LICENSE.md`, `static/img/*` (preview images), `.github/` meta files.
- No build system, no test suite, no CI workflows under `.github/workflows/`.

## Conventions

- All contributions land on the `master` branch (see `.github/CONTRIBUTING.md`).
- PR descriptions: one-line description; explain the problem and proposed solution.
- A link marked `*` is temporarily unavailable — do not delete it without confirming permanent expiry (see `README.md` contributing note).

## Commit signature

Commits must include a `signed-off-by` line. The hook below (from `.github/CONTRIBUTING.md`) appends it automatically when placed in `.git/hooks/prepare-commit-msg`:

```bash
SOB=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/- signed-off-by: \1/p')
grep -qs "^$SOB" "$1" || echo "$SOB" >> "$1"
```

## Broken-link check

The repository documents a quick broken-link sweep over `README.md` (from `.github/CONTRIBUTING.md`):

```bash
for i in $(sed -n 's/.*href="\([^"]*\).*/\1/p' README.md | grep -v "^#") ; do
  _rcode=$(curl -s -o /dev/null -w "%{http_code}" "$i")
  if [[ "$_rcode" != "2"* ]] ; then echo " -> $i - $_rcode" ; fi
done
```

Use this (or an equivalent) before bulk link edits. Note: only `href="..."` links are scanned; bare Markdown `[text](url)` links are not covered by this snippet.

<!-- TODO: document any future CI workflows or lint/format tooling if they are added under .github/workflows/. -->
