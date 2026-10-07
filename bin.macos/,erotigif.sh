#!/opt/homebrew/bin/zsh
set -euo pipefail

print -- ${(l:$(tput cols)::*:)${:-}}

echo "Syncing erotigifs to the cdn and updating index"

src=~/Documents/erotigif
website=~/code/elidon-website
out=$website/app/xxx/erotigif.json

# Sync erotigifs to the cdn
rsync -avz  --exclude='.DS_Store' --chmod=D755,F644 \
  $src janpaul@home.elidon.net:/var/www/cdn

# Make a new index
if [[ ! -d $website ]]; then
  echo "Website niet gevonden: $website" >&2
  exit 1
fi

mkdir -p ${out:h}
files=( $src/*.mp4(N.on:t) )   # :t = alleen de bestandsnaam
jq -n '$ARGS.positional' --args $files > $out.tmp && mv $out.tmp $out
echo "${#files} video's in $out"

echo
