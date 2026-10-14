#!/opt/homebrew/bin/zsh

zparseopts -D -E n:=opt_n
limit=${opt_n[2]:-0}       # 0 = no no, no no no no, no no no no, no no there's no limit
dir="${1:-$HOME/Documents/xvideos}"
thumbs="$dir/thumbs"
width=640          # thumbnail width, height follows aspect ratio
height=360
pos=0.10           # grab frame at 10% of the duration

print -- ${(l:$(tput cols)::*:)${:-}}

require_host elvis
echo "Creating thumbnails for xvideos in $dir"

set -uo pipefail

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

