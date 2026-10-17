#!/opt/homebrew/bin/zsh
set -euo pipefail

print -- ${(l:$(tput cols)::*:)${:-}}

require_host elvis

echo "Syncing xvideos to the cdn and updating index"

src=~/Documents/xvideos
out=$src/xvideos.json

files=( $src/*.mp4(N.om:t) )   # :t = only the filename
jq -n '$ARGS.positional' --args $files > $out.tmp && mv $out.tmp $out
echo "${#files} video's in $out"

# Sync xvideos to the cdn
rsync -avz  --exclude='.DS_Store' --chmod=D755,F644 \
  $src janpaul@home.elidon.net:/var/www/cdn

echo
