#!/opt/homebrew/bin/zsh

src=~/Downloads/m
dest=~/Documents/AIFF

cd "$src" || return 1

for file in *.flac
do
  [ -e "$file" ] || continue
  base="${file%.flac}"
  clean_base="$(echo "$base" | sed -E 's/^[0-9]+\. //')"
  target="$dest/$clean_base.aiff"

  if [ -f "$target" ]; then
    echo "exists - skip: $base.aiff"
    rm -- "$file"
    continue
  fi

  echo "converting: $file → $target"
  if ffmpeg -loglevel error -nostats -i "$file" -map_metadata 0 -c:a pcm_s16be "$target"; then
    echo "success, removing src: $file"
    rm -- "$file"
  fi
done