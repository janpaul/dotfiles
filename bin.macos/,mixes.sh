#!/opt/homebrew/bin/zsh
set -euo pipefail

src=~/Documents/mixes

print -- ${(l:$(tput cols)::*:)${:-}}

require_host elvis
echo "Syncing mixes to the cdn"

# Sync mixes to the local cdn
rsync -avz  --exclude='.DS_Store' --chmod=D755,F644 \
  $src janpaul@home.elidon.net:/home/www/cdn

# Sync to vercel blob storage
sync_dir=~/code/vercel-blob-sync
node --env-file=$sync_dir/.env.local $sync_dir/blob-sync.ts $src --prefix=mixes "$@"

echo

