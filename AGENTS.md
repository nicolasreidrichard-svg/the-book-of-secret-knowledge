# AGENTS.md

Notes for automated agents working in this repository.

## Repository shape

- Content lives in a single top-level `README.md` (a curated list).
- `static/img/` holds images referenced by the README.
- `.github/` holds `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, and `FUNDING.yml`.
- No build system, package manifest, or test suite is present.

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

Contributors are expected to sign off commits. Setup snippet (from `.github/CONTRIBUTING.md`) for `.git/hooks/prepare-commit-msg`:

```bash
SOB=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/- signed-off-by: \1/p')
grep -qs "^$SOB" "$1" || echo "$SOB" >> "$1"
```

## Contribution rules

- Base changes on the latest `master` branch.
- One-line PR description; explain the problem and proposed solution in the body.
- See `.github/CONTRIBUTING.md` for full guidance.

## TODO

- No CI workflows are defined under `.github/workflows/`; document any that appear.
- No linter/formatter config detected for the README; add commands here if one is introduced.
