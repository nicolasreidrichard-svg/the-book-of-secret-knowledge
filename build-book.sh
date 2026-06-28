#!/usr/bin/env bash
# build-book.sh - Generate downloadable book formats from README.md
#
# Usage:
#   ./build-book.sh          # Generate all formats (epub, pdf, html)
#   ./build-book.sh epub     # Generate EPUB only
#   ./build-book.sh pdf      # Generate PDF only
#   ./build-book.sh html     # Generate standalone HTML only
#
# Dependencies:
#   - pandoc (for EPUB and PDF)
#   - texlive-xetex (for PDF only)
#
# Install on Ubuntu/Debian:
#   sudo apt-get install -y pandoc texlive-xetex texlive-fonts-recommended \
#     texlive-plain-generic texlive-fonts-extra
#
# Install on macOS:
#   brew install pandoc mactex-no-gui

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
README="${SCRIPT_DIR}/README.md"
METADATA="${SCRIPT_DIR}/book-metadata.yaml"
OUTPUT_DIR="${SCRIPT_DIR}/build"
TMPDIR_WORK="$(mktemp -d)"
BOOK_BASENAME="the-book-of-secret-knowledge"

cleanup() {
  rm -rf "$TMPDIR_WORK"
}
trap cleanup EXIT

# ---------------------------------------------------------------------------
# Pre-process README: strip GitHub-specific elements that don't render well
# in book formats (emoji shortcodes, badges, contribution images).
# ---------------------------------------------------------------------------
preprocess() {
  local input="$1"
  local output="$2"

  sed \
    -e 's/:[a-zA-Z0-9_]*: &nbsp;//g' \
    -e 's/:[a-zA-Z0-9_]*://g' \
    -e '/img\.shields\.io/d' \
    -e '/badge/d' \
    -e '/opencollective\.com.*contributors\.svg/d' \
    -e 's/&nbsp;/ /g' \
    "$input" > "$output"

  echo "[preprocess] Cleaned markdown written to $output"
}

# ---------------------------------------------------------------------------
# Generate EPUB
# ---------------------------------------------------------------------------
build_epub() {
  local content="${TMPDIR_WORK}/book-content.md"
  preprocess "$README" "$content"

  pandoc "$content" \
    --from markdown+raw_html \
    --to epub3 \
    --output "${OUTPUT_DIR}/${BOOK_BASENAME}.epub" \
    --metadata-file "$METADATA" \
    --toc \
    --toc-depth=3 \
    --standalone

  echo "[epub]   Built ${OUTPUT_DIR}/${BOOK_BASENAME}.epub"
}

# ---------------------------------------------------------------------------
# Generate PDF (requires XeLaTeX)
# ---------------------------------------------------------------------------
build_pdf() {
  local content="${TMPDIR_WORK}/book-content.md"
  preprocess "$README" "$content"

  pandoc "$content" \
    --from markdown+raw_html \
    --to pdf \
    --output "${OUTPUT_DIR}/${BOOK_BASENAME}.pdf" \
    --metadata-file "$METADATA" \
    --toc \
    --toc-depth=3 \
    --pdf-engine=xelatex \
    -V geometry:margin=1in \
    -V linkcolor:blue \
    -V urlcolor:blue \
    -V mainfont="DejaVu Serif" \
    -V monofont="DejaVu Sans Mono" \
    --standalone

  echo "[pdf]    Built ${OUTPUT_DIR}/${BOOK_BASENAME}.pdf"
}

# ---------------------------------------------------------------------------
# Generate standalone HTML (no special viewer needed)
# ---------------------------------------------------------------------------
build_html() {
  local content="${TMPDIR_WORK}/book-content.md"
  preprocess "$README" "$content"

  pandoc "$content" \
    --from markdown+raw_html \
    --to html5 \
    --output "${OUTPUT_DIR}/${BOOK_BASENAME}.html" \
    --metadata-file "$METADATA" \
    --toc \
    --toc-depth=3 \
    --standalone \
    --self-contained \
    --metadata title="The Book of Secret Knowledge" \
    --css=- <<'CSS'
<style>
  body {
    font-family: "DejaVu Serif", Georgia, serif;
    max-width: 900px;
    margin: 0 auto;
    padding: 2rem;
    line-height: 1.6;
    color: #333;
    background: #fefefe;
  }
  h1, h2, h3, h4, h5, h6 {
    color: #2c3e50;
    margin-top: 1.5em;
  }
  a { color: #2980b9; text-decoration: none; }
  a:hover { text-decoration: underline; }
  code {
    background: #f4f4f4;
    padding: 2px 6px;
    border-radius: 3px;
    font-size: 0.9em;
  }
  pre {
    background: #2c3e50;
    color: #ecf0f1;
    padding: 1rem;
    border-radius: 5px;
    overflow-x: auto;
  }
  pre code { background: none; color: inherit; padding: 0; }
  blockquote {
    border-left: 4px solid #2980b9;
    margin-left: 0;
    padding-left: 1rem;
    color: #555;
  }
  #TOC {
    background: #f8f9fa;
    border: 1px solid #e9ecef;
    border-radius: 5px;
    padding: 1rem 1.5rem;
    margin-bottom: 2rem;
  }
  #TOC ul { list-style-type: none; padding-left: 1rem; }
  #TOC > ul { padding-left: 0; }
</style>
CSS

  echo "[html]   Built ${OUTPUT_DIR}/${BOOK_BASENAME}.html"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
mkdir -p "$OUTPUT_DIR"

if [[ $# -eq 0 ]]; then
  build_epub
  build_pdf
  build_html
else
  for fmt in "$@"; do
    case "$fmt" in
      epub) build_epub ;;
      pdf)  build_pdf  ;;
      html) build_html ;;
      *)    echo "Unknown format: $fmt (use epub, pdf, or html)" >&2; exit 1 ;;
    esac
  done
fi

echo ""
echo "All requested formats built in ${OUTPUT_DIR}/"
