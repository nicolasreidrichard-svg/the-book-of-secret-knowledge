# AGENTS.md

Guidance for automated agents working in this repository.

## Repository overview

This repo is a single curated reference list. The substantive content lives in
`README.md`; the rest of the tree is supporting material:

- `README.md` — the entire "book" (large, Markdown + raw HTML).
- `LICENSE.md` — MIT license.
- `static/img/` — images referenced by `README.md`.
- `.github/` — `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `FUNDING.yml`.

There is no build system, package manager, or test suite in this repository.
Changes are almost always edits to `README.md`.

## Workflows and commands

These are the workflows currently documented or used in the repo. Do not invent
others.

### Check for broken links in README.md

From `.github/CONTRIBUTING.md`. Run from the repo root:

```bash
for i in $(sed -n 's/.*href="\([^"]*\).*/\1/p' README.md | grep -v "^#") ; do
  _rcode=$(curl -s -o /dev/null -w "%{http_code}" "$i")
  if [[ "$_rcode" != "2"* ]] ; then echo " -> $i - $_rcode" ; fi
done
```

Non-2xx responses are reported. Some sites return 3xx/403/503 even when alive,
so verify a failure manually before removing a link (see the note in
`CONTRIBUTING.md`: "Url marked **\*** is temporary unavailable. Please don't
delete it without confirming that it has permanently expired.").

### Sign-off on commits

From `.github/CONTRIBUTING.md`. All commits must include a `signed-off-by`
line. To automate this, add to `.git/hooks/prepare-commit-msg`:

```bash
SOB=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/- signed-off-by: \1/p')
grep -qs "^$SOB" "$1" || echo "$SOB" >> "$1"
```

### Pull requests

Per `.github/CONTRIBUTING.md`:

- Base changes on the latest `master` branch.
- One-line PR description (do not continue on new lines).
- Explain the problem and proposed solution.

## Editing conventions

- `README.md` mixes Markdown with raw HTML (`<p align="center">`, `<h4>`,
  `<img>`, etc.) and GitHub emoji shortcodes (e.g. `:notebook_with_decorative_cover:`).
  Preserve both when editing.
- Entries are organized by topical sections with a table of contents at the
  top. When adding a link, place it in the most specific existing section and
  keep the surrounding formatting (bullet style, description style) consistent.
- Do not bulk-reformat `README.md`. Diffs should be scoped to the change.

## What not to do

- Do not modify `LICENSE.md`.
- Do not edit files under `static/` unless the task is explicitly about images.
- Do not add build tooling, package manifests, or CI workflows unless asked.
- Do not delete links flagged with `*` without confirming they are permanently
  gone (see CONTRIBUTING.md).
