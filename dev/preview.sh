#!/usr/bin/env bash
# Preview the starter site with a given theme and demo content.
#
#   dev/preview.sh [theme] [build|serve]
#
# Defaults: theme "clean", "serve" on http://localhost:4000.
# "build" writes the site to dev/.build/_site and exits.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
THEME="${1:-clean}"
MODE="${2:-serve}"
THEME_CSS="$ROOT/plugins/site/themes/$THEME/theme.css"
[ -f "$THEME_CSS" ] || { echo "No theme named '$THEME'"; exit 1; }

SRC="$ROOT/dev/.build/src"
rm -rf "$SRC" && mkdir -p "$SRC"
cp -R "$ROOT/plugins/site/template/." "$SRC/"
cp "$THEME_CSS" "$SRC/assets/css/theme.css"
cp -R "$ROOT/dev/demo/." "$SRC/"
rm -f "$SRC/_posts/"*-hello-world.md

case "$MODE" in
  build) CMD="bundle exec jekyll build -s /src -d /build/.build/_site --config /src/_config.yml,/src/_config.demo.yml" ;;
  serve) CMD="bundle exec jekyll serve -s /src -d /tmp/site --host 0.0.0.0 --config /src/_config.yml,/src/_config.demo.yml" ;;
  *) echo "Mode must be build or serve"; exit 1 ;;
esac

exec docker run --rm --name lite-site-preview -p 4000:4000 \
  -v "$SRC":/src:ro -v "$ROOT/dev":/build -v lite-site-gems:/usr/local/bundle \
  -e BUNDLE_GEMFILE=/build/Gemfile -e PAGES_REPO_NWO=example/example.github.io \
  ruby:3.3 sh -c "bundle install --quiet && $CMD"
