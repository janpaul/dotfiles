#!/opt/homebrew/bin/zsh
set -euo pipefail

print -- ${(l:$(tput cols)::*:)${:-}}
require_host elvis
echo "Syncing erotigifs to the cdn and updating index"

src=~/Documents/erotigif
out=$src/erotigif.json

files=( $src/*.mp4(N.on:t) )   # :t = alleen de bestandsnaam
jq -n '$ARGS.positional' --args $files > $out.tmp && mv $out.tmp $out
echo "${#files} videos in $out"

# Sync erotigifs to the cdn
rsync -avz  --exclude='.DS_Store' --chmod=D755,F644 \
  $src janpaul@home.elidon.net:/home/www/cdn

echo
