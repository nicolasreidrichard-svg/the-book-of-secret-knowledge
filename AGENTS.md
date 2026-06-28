# AGENTS.md

Guidance for automated agents working in this repository.

## Repository overview

This repo is a single curated reference list. The substantive content lives in
`README.md`; the rest of the tree is supporting material:

- `README.md` — the entire "book" (large, Markdown + raw HTML).
- `LICENSE.md` — MIT license.
- `static/img/` — images referenced by `README.md`.
- `book-metadata.yaml` — metadata (title, author, language, keywords) consumed
  by the book-generation workflow.
- `.github/CONTRIBUTING.md` — contribution guidelines and link-check recipe.
- `.github/CODE_OF_CONDUCT.md` — Contributor Covenant v1.4.
- `.github/FUNDING.yml` — Open Collective / GitHub Sponsors links.
- `.github/workflows/generate-book.yml` — CI workflow that builds EPUB/PDF
  releases from `README.md`.

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

### Generate downloadable book (EPUB/PDF)

Defined in `.github/workflows/generate-book.yml`. Requires `permissions:
contents: write`. Triggers on push to `master`
when `README.md`, `book-metadata.yaml`, or the workflow file itself changes,
and also via `workflow_dispatch`.

Steps performed by the workflow:

1. Install pandoc + TeX Live (`texlive-xetex`, fonts).
2. Pre-process `README.md` — strip GitHub emoji shortcodes and badge images
   via `sed`.
3. Generate EPUB with `pandoc --to epub3 --toc --toc-depth=3`.
4. Generate PDF with `pandoc --to pdf --pdf-engine=xelatex`.
5. Delete any previous `book-latest` GitHub Release (uses `gh release delete
   --yes --cleanup-tag`).
6. Create a new `book-latest` release with both `.epub` and `.pdf` assets
   (requires `GH_TOKEN`).

If modifying the book-generation pipeline, test locally with:

```bash
# Pre-process
sed -e 's/:[a-zA-Z0-9_]*: &nbsp;//g' -e 's/:[a-zA-Z0-9_]*://g' \
    -e '/img\.shields\.io/d' -e '/badge/d' \
    README.md > /tmp/book-content.md

# EPUB
pandoc /tmp/book-content.md --from markdown+raw_html --to epub3 \
  --output test.epub --metadata-file book-metadata.yaml \
  --toc --toc-depth=3 --standalone

# PDF (requires texlive-xetex)
pandoc /tmp/book-content.md --from markdown+raw_html --to pdf \
  --output test.pdf --metadata-file book-metadata.yaml \
  --toc --toc-depth=3 --pdf-engine=xelatex \
  -V geometry:margin=1in -V mainfont="DejaVu Serif" \
  -V monofont="DejaVu Sans Mono" -V linkcolor:blue \
  -V urlcolor:blue --standalone
```

### Monitor changes via RSS

GitHub exposes an RSS/Atom feed of commits:

```
https://github.com/trimstray/the-book-of-secret-knowledge/commits.atom
```

Useful for keeping informed about all changes to the repository.

## Editing conventions

- `README.md` mixes Markdown with raw HTML (`<p align="center">`, `<h4>`,
  `<img>`, etc.) and GitHub emoji shortcodes (e.g. `:notebook_with_decorative_cover:`).
  Preserve both when editing.
- Entries are organized by topical sections with a table of contents at the
  top. When adding a link, place it in the most specific existing section and
  keep the surrounding formatting (bullet style, description style) consistent.
- Do not bulk-reformat `README.md`. Diffs should be scoped to the change.
- `book-metadata.yaml` must stay in sync with `README.md` header metadata
  (title, subtitle, author, language). If the book title or author changes in
  `README.md`, update `book-metadata.yaml` as well.

## What not to do

- Do not modify `LICENSE.md`.
- Do not edit files under `static/` unless the task is explicitly about images.
- Do not add build tooling, package manifests, or CI workflows unless asked.
- Do not delete links flagged with `*` without confirming they are permanently
  gone (see CONTRIBUTING.md).
- Do not alter `book-metadata.yaml` keywords or rights fields without explicit
  instruction.
