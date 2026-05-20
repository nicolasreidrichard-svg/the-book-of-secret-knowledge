# AGENTS.md

Notes for automated agents working in this repository.

## Repository shape

- Content lives in a single top-level `README.md` (a large curated list).
- `static/img/` holds images referenced by the README (currently only
  `the-book-of-secret-knowledge-preview.png`).
- `.github/` holds `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, and `FUNDING.yml`.
- `LICENSE.md` at the repo root (MIT).
- No build system, package manifest, test suite, or `.github/workflows/`
  directory is present on `master`.

## Workflows

### Find broken links in README.md

From `.github/CONTRIBUTING.md`:

```bash
for i in $(sed -n 's/.*href="\([^"]*\).*/\1/p' README.md | grep -v "^#") ; do
  _rcode=$(curl -s -o /dev/null -w "%{http_code}" "$i")
  if [[ "$_rcode" != "2"* ]] ; then echo " -> $i - $_rcode" ; fi
done
```

### Signed-off-by commits

Contributors are expected to sign off commits. Setup snippet (from
`.github/CONTRIBUTING.md`) for `.git/hooks/prepare-commit-msg`:

```bash
SOB=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/- signed-off-by: \1/p')
grep -qs "^$SOB" "$1" || echo "$SOB" >> "$1"
```

## Contribution rules

- Base changes on the latest `master` branch.
- One-line PR description; explain the problem and proposed solution in the body.
- Per `README.md`: a URL marked `*` is temporarily unavailable — do not delete
  it without confirming it has permanently expired.
- See `.github/CONTRIBUTING.md` for full guidance.

## TODO

- No CI workflows are defined under `.github/workflows/` on `master`; document
  any that land here (an EPUB/PDF generation workflow has been proposed on a
  feature branch but is not merged).
- No linter/formatter config detected for the README; add commands here if one
  is introduced.
