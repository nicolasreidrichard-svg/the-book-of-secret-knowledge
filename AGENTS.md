# AGENTS.md

## Repository Overview

This is a curated collection of CLI tools, web tools, shell one-liners, cheatsheets, and security resources. The primary content lives in `README.md`. It is a documentation-only repository with no build system, tests, or CI pipelines.

## Repository Structure

- `README.md` — Main content (all chapters, tool lists, one-liners, shell functions)
- `.github/CONTRIBUTING.md` — Contribution guidelines and broken-link checker
- `.github/CODE_OF_CONDUCT.md` — Contributor Covenant CoC
- `.github/FUNDING.yml` — Open Collective / GitHub Sponsors config
- `static/img/` — Preview image assets
- `LICENSE.md` — MIT License

## Contributing Workflow

1. Fork the repository.
2. Create a branch based on **master**.
3. Add changes (keep entries inviting, clear, useful).
4. Ensure commit includes a **signed-off-by** line (see below).
5. Open a pull request against **master** with a clear one-line description.

### Signed-off-by Commit Convention

Add the following to `.git/hooks/prepare-commit-msg`:

```bash
SOB=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/- signed-off-by: \1/p')
grep -qs "^$SOB" "$1" || echo "$SOB" >> "$1"
```

## Commands

### Broken Link Checker

Scan all external URLs in README.md for non-2xx HTTP responses:

```bash
for i in $(sed -n 's/.*href="\([^"]*\).*/\1/p' README.md | grep -v "^#") ; do
  _rcode=$(curl -s -o /dev/null -w "%{http_code}" "$i")
  if [[ "$_rcode" != "2"* ]] ; then echo " -> $i - $_rcode" ; fi
done
```

## Notes

- No CI/CD workflows are configured (no `.github/workflows/` directory).
- No package manager, build tool, linter, or test suite exists.
- Content is Markdown with inline HTML anchors.
- URLs marked with `*` in README.md are known to be temporarily unavailable; do not delete them without confirming they have permanently expired.
