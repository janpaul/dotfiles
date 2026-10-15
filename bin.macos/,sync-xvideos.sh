#!/opt/homebrew/bin/zsh

print -- ${(l:$(tput cols)::*:)${:-}}

require_host elvis

echo "Syncing xvideos to the cdn and updating index"

set -euo pipefail

src=~/Documents/xvideos
website=~/code/stiffnipples
out=$website/app/xvideos/xvideos.json

# Sync xvideos to the cdn
rsync -avz  --exclude='.DS_Store' --chmod=D755,F644 \
  $src janpaul@home.elidon.net:/var/www/cdn

# Make a new index
if [[ ! -d $website ]]; then
  echo "Website not found: $website" >&2
  exit 1
fi

mkdir -p ${out:h}
files=( $src/*.mp4(N.on:t) )   # :t = only the filename
jq -n '$ARGS.positional' --args $files > $out.tmp && mv $out.tmp $out
echo "${#files} video's in $out"

echo
