#!/bin/sh
# Pull the latest glass v4 source from the glass repo into this folder, then rebuild ../glass/.
#   npm run sync                       (glass repo at ../../glass, the usual Projects layout)
#   GLASS_REPO=/path/to/glass npm run sync
# Copies only what v4 needs to run: v4/*.js|jsx|css|html, the three toolbar icons, and the
# candidate-state generator's source (bulkMelt.js comes over with v4).
set -e
HERE="$(cd "$(dirname "$0")/.." && pwd)"
GLASS="${GLASS_REPO:-$HERE/../../glass}"
[ -d "$GLASS/v4" ] || { echo "glass repo not found at $GLASS (set GLASS_REPO)"; exit 1; }

# keep this folder's own page title
TITLE_LINE="$(grep -o '<title>.*</title>' "$HERE/index.html")"
cp "$GLASS"/v4/*.js "$GLASS"/v4/*.jsx "$GLASS"/v4/*.css "$GLASS"/v4/index.html "$HERE/"
sed -i.bak "s#<title>.*</title>#$TITLE_LINE#" "$HERE/index.html" && rm -f "$HERE/index.html.bak"
cp "$GLASS"/public/Turtle.png "$GLASS"/public/Rabbit.png "$GLASS"/public/Stopwatch.png "$HERE/public/"

echo "synced from $GLASS ($(cd "$GLASS" && git log --oneline -1 2>/dev/null))"
cd "$HERE" && npm run build
