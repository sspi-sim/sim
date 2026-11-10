#!/bin/sh
# Pull the latest concrete v4 source from the concrete repo into this folder, then rebuild ../concrete/.
#   npm run sync                             (concrete repo at ../../concrete, the usual Projects layout)
#   CONCRETE_REPO=/path/to/concrete npm run sync
# Copies only what v4 needs to run: v4/src/*, v4/index.html and the 10 images it references
# from the repo's shared public/ folder. (v4's *.mjs measurement scripts aren't needed.)
set -e
HERE="$(cd "$(dirname "$0")/.." && pwd)"
REPO="${CONCRETE_REPO:-$HERE/../../concrete}"
[ -d "$REPO/v4/src" ] || { echo "concrete repo not found at $REPO (set CONCRETE_REPO)"; exit 1; }

TITLE_LINE="$(grep -o '<title>.*</title>' "$HERE/index.html")"   # keep this folder's page title
rm -rf "$HERE/src" && mkdir -p "$HERE/src" && cp "$REPO"/v4/src/* "$HERE/src/"
cp "$REPO/v4/index.html" "$HERE/"
sed -i.bak "s#<title>.*</title>#$TITLE_LINE#" "$HERE/index.html" && rm -f "$HERE/index.html.bak"
for f in 0Sandbar 20Sandbar 40Sandbar 60Sandbar 80Sandbar BeamTestNoBeam brick Pusher Rabbit Turtle; do
  cp "$REPO/public/$f.png" "$HERE/public/"
done
# warn if v4 now references an image that isn't copied
for f in $(grep -oh "/concrete/[A-Za-z0-9_.-]*\.\(png\|svg\|jpg\|webp\)" "$HERE"/src/* "$HERE/index.html" | sort -u); do
  [ -f "$HERE/public/${f#/concrete/}" ] || echo "WARNING: $f is referenced but not in public/ — add it to this script"
done

echo "synced from $REPO ($(cd "$REPO" && git log --oneline -1 2>/dev/null); uncommitted changes included)"
cd "$HERE" && npm run build
