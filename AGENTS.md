# AGENTS.md

## Repository Overview

This is **The Book of Secret Knowledge** — a curated collection of links, manuals, cheatsheets, one-liners, CLI/web tools, and reference material aimed at sysadmins, DevOps, pentesters, and security researchers. The repo is content-only (no application code, build system, or test suite).

## Repository Structure

```
.
├── README.md                     # Main content (all chapters, one-liners, shell functions)
├── LICENSE.md                    # MIT License
├── static/
│   └── img/
│       └── the-book-of-secret-knowledge-preview.png
└── .github/
    ├── CONTRIBUTING.md            # Contribution guidelines
    ├── CODE_OF_CONDUCT.md         # Code of conduct
    └── FUNDING.yml                # Open Collective + GitHub Sponsors
```

## Key Workflows

### Contributing

- PRs target the **master** branch.
- Commits must include a `signed-off-by` line (see `.github/CONTRIBUTING.md` for the git hook setup).
- One-line descriptions only; do not continue descriptions on new lines.
- Content quality rule: "not everything, only good quality stuff."
- URLs marked with `*` are temporarily unavailable — do not delete without confirming permanent expiry.

### Finding Broken Links

From `.github/CONTRIBUTING.md`:

```bash
git clone https://github.com/nicolasreidrichard-svg/the-book-of-secret-knowledge && cd the-book-of-secret-knowledge

for i in $(sed -n 's/.*href="\([^"]*\).*/\1/p' README.md | grep -v "^#") ; do
  _rcode=$(curl -s -o /dev/null -w "%{http_code}" "$i")
  if [[ "$_rcode" != "2"* ]] ; then echo " -> $i - $_rcode" ; fi
done
```

### Commit Signature Setup

Add to `.git/hooks/prepare-commit-msg`:

```bash
SOB=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/- signed-off-by: \1/p')
grep -qs "^$SOB" "$1" || echo "$SOB" >> "$1"
```

## Content Structure (README.md)

The README is a single large document organized into chapters:

1. **CLI Tools** — Shells, plugins, managers, editors, network/DNS/HTTP/SSL tools, security, auditing, diagnostics, log analyzers, databases, TOR, messengers
2. **GUI Tools** — Terminal emulators, network tools, browsers, password managers, messengers
3. **Web Tools** — SSL/security testers, DNS tools, encoders/decoders, net-tools, privacy, code playgrounds, performance, mass scanners, generators, CVE databases
4. **Systems/Services** — Operating systems, HTTP(s) services, DNS services, security/hardening
5. **Networks** — Tools, labs
6. **Containers/Orchestration** — CLI tools, web tools, security, manuals/tutorials
7. **Manuals/Howtos/Tutorials** — Shell/command line, text editors, Python, sed/awk, *nix/network, Microsoft, system hardening, web apps, all-in-one, ebooks
8. **Inspiring Lists** — SysOps/DevOps, developers, security/pentesting
9. **Blogs/Podcasts/Videos** — SysOps/DevOps, developers, security podcasts, video blogs, Twitter accounts
10. **Hacking/Penetration Testing** — Pentest tools, bookmarks, backdoors, wordlists, bounty platforms, training apps, labs/CTFs
11. **Your daily knowledge and news** — RSS readers, IRC, security news
12. **Other Cheat Sheets** — DNS server setup, CA setup, VM/OS build, DNS privacy list, browser extensions, Burp extensions, Firefox address bar tricks, Chrome hidden commands, WAF IP bypass, hashing/encryption/encoding
13. **Shell One-liners** — Extensive per-tool reference (terminal, busybox, mount, fuser, lsof, ps, find, top, vmstat, iostat, strace, kill, diff, vimdiff, tail, tar, dump, cpulimit, pwdx, taskset, tr, chmod, who, last, screen, script, du, inotifywait, openssl, secure-delete, dd, gpg, curl, httpie, ssh, linux-dev, tcpdump, tcpick, ngrep, hping3, nmap, netcat, socat, p0f, gnutls-cli, netstat, rsync, host, dig, certbot, git, python, awk, sed, grep, perl)
14. **Shell Tricks** — Stabilizing a raw shell
15. **Shell Functions** — `DomainResolve()` (DNS lookup via dns.google.com), `GetASN()` (ASN lookup via ip-api.com)

## Commands

There are no build, test, or lint commands. The repo is a static content repository.

| Task | Command |
|---|---|
| Check for broken links | See "Finding Broken Links" above |
| Serve README locally | `python3 -m http.server 8000` |

## Conventions

- Content is written in mixed Markdown + HTML (for precise link formatting).
- Link entries follow the pattern: `<a href="URL"><b>Name</b></a> - description.<br>`
- Chapter headings use `####` with a `[TOC]` back-link.
- Sub-sections use `##### :black_small_square:`.
- Shell one-liners use fenced `bash` code blocks with `######` sub-headings.
- Emoji are used in section headers (established pattern in the original repo).

## TODO

- TODO: Document any CI/CD workflows if added in the future.
- TODO: Add link-check automation (e.g., GitHub Actions) if introduced.
