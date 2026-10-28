#!/opt/homebrew/bin/zsh

set -uo pipefail


require_host elvis
print -- ${(l:$(tput cols)::*:)${:-}}

echo "Doing xvideos"

#
# 1. Rename files to their md5 hash, avoiding collisions and duplicates
#

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

#
# 2. Create video thumbnails
#

limit=${opt_n[2]:-0}       # 0 = no no, no no no no, no no no no, no no there's no limit
dir="${1:-$HOME/Documents/xvideos}"
thumbs="$dir/thumbs"
width=640          # thumbnail width, height follows aspect ratio
height=360
pos=0.10           # grab frame at 10% of the duration

echo
echo "Creating thumbnails for xvideos in $dir"

cd "$dir" || { echo "Can't cd to $dir"; exit 1; }
mkdir -p "$thumbs"

made=0 skipped=0 failed=0

setopt extendedglob
for f in (^*\ <->).(#i)mp4(N); do
    jpeg="$thumbs/${f:r}.jpg"
    if [[ -f $jpeg ]]; then ((skipped++)); continue; fi
    (( limit && made + failed >= limit )) && break

    dur=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f" 2>/dev/null)
    [[ $dur == [0-9.]## ]] || dur=0
    ss=$(( dur > 0 ? dur * pos : 5 ))

    if ffmpeg -nostdin -v error -ss "$ss" -i "$f" -frames:v 1 \
              -vf "split[a][b];[a]scale=${width}:${height}:force_original_aspect_ratio=increase,crop=${width}:${height},boxblur=20:2,eq=brightness=-0.15[bg];[b]scale=${width}:${height}:force_original_aspect_ratio=decrease[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2" \
              "$jpeg"; then
        echo "✓ $jpeg"; ((made++))
    else
        echo "✗ $f"; rm -f "$jpeg"; ((failed++))
    fi
done

echo "Done: $made made, $skipped skipped, $failed failed"

#
# 3. Synchronize to CDN
#

echo
echo "Syncing xvideos to the cdn and updating index"

src=~/Documents/xvideos
out=$src/xvideos.json

files=( $src/*.mp4(N.om:t) )   # :t = only the filename
jq -n '$ARGS.positional' --args $files > $out.tmp && mv $out.tmp $out
echo "${#files} video's in $out"

# Sync xvideos to the cdn
rsync -avz  --exclude='.DS_Store' --chmod=D755,F644 \
  $src janpaul@home.elidon.net:/home/www/cdn

echo