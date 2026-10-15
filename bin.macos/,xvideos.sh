#!/opt/homebrew/bin/zsh

print -- ${(l:$(tput cols)::*:)${:-}}

require_host elvis
echo "Renaming videos in ~/Documents/videos"

setopt extendedglob nullglob

dir="${HOME}/Documents/xvideos"
ph_pattern='(#i).*.(gif|mp4|mov|webm).icloud(.)'

# 1. Fetch evicted files (.name.mp4.icloud) first
placeholders=( $dir/$~ph_pattern )
if (( ${#placeholders} )); then
  echo "${#placeholders} iCloud-placeholders, fetching..."
  for p in $placeholders; do
    brctl download "${p:h}/${${p:t}[2,-8]}"
  done
  for i in {1..60}; do
    sleep 2
    placeholders=( $dir/$~ph_pattern )
    (( ${#placeholders} )) || break
  done
  (( ${#placeholders} )) && echo "⚠️  ${#placeholders} not yet fetched, next run" >&2
fi

# 2. Only files that have not been modified for >2 min (not in the middle of a sync)
pattern='(#i)*.(gif|mp4|mov|webm)(.mm+2)'

for f in $dir/$~pattern; do
  name=${f:t}
  ext=${${f:e}:l}

  [[ $name =~ '^[0-9a-f]{24}\.(gif|mp4|mov|webm)$' ]] && continue

  hash=$(md5 -q "$f")
  new=$dir/${hash[1,24]}.$ext

  # twin still evicted? Do not rename, skip to next file
  if [[ ! -e $new && -e ${new:h}/.${new:t}.icloud ]]; then
    echo "⚠️  Twin is still a placeholder, skipping: $name" >&2
    continue
  fi

  if [[ -e $new ]]; then
    if cmp -s -- "$f" "$new"; then
      echo "Duplicate → removed: $name"
      rm -- "$f"
    else
      echo "⚠️  Hash collision, nothing done: $name vs ${new:t}" >&2
    fi
  else
    echo "Renamed: $name -> ${new:t}"
    mv -n -- "$f" "$new"
  fi
done

echo