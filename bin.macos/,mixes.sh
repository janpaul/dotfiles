#!/opt/homebrew/bin/zsh
set -euo pipefail

src=~/Documents/mixes

# Sync mixes to the cdn
rsync -avz  --exclude='.DS_Store' --chmod=D755,F644 \
  $src janpaul@home.elidon.net:/var/www/cdn


