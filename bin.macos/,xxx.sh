#!/opt/homebrew/bin/zsh
VIDEOS_DIR="$HOME/Documents/videos"
EROTIGIF_DIR="$HOME/Documents/erotigif"
MIN_TIME_SECONDS=14
MAX_TIME_SECONDS=120
MIN_RESOLUTION=480
PLAYLIST="$HOME/.xxx-playlist.m3u"
ENV_FILE="${0:A:h:h}/.env"

draw_progress() {
  local current=$1
  local total=$2
  local width=$(( $(tput cols) - 10 ))
  local percent=$(( current * 100 / total ))
  local filled=$(( width * current / total ))
  local empty=$(( width - filled ))

  printf "\r["
  printf "%0.s#" $(seq 1 $filled) 2>/dev/null
  printf "%0.s-" $(seq 1 $empty) 2>/dev/null
  printf "] %3d%%" "$percent"
  tput el
}

if [ "$1" = "refresh" ]; then
  echo "refreshing playlist..."
  rm -f "$PLAYLIST"
fi

# Enable the following to re-build the playlist
# rm -f "$PLAYLIST"

if [ -f "$ENV_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
fi


if [ ! -e "$PLAYLIST" ]; then
  echo "playlist does not exist, creating..."
  touch "$PLAYLIST"

  if [ -z "$BLOB_READ_WRITE_TOKEN" ]; then
    :
  else
    echo "doing erotic videos"
    pushd || exit
    cd "$EROTIGIF_DIR" || exit

    pathnames=()
    cursor=""
     while true; do
       if [ -z "$cursor" ]; then
         response=$(curl -s "https://blob.vercel-storage.com?limit=1000" \
           -H "Authorization: Bearer $BLOB_READ_WRITE_TOKEN" \
           -H "x-api-version: 7")
       else
         response=$(curl -s "https://blob.vercel-storage.com?limit=1000&cursor=$cursor" \
           -H "Authorization: Bearer $BLOB_READ_WRITE_TOKEN" \
           -H "x-api-version: 7")
       fi

       page_pathnames=("${(@f)$(echo "$response" | jq -r '.blobs[].pathname')}")
       for i in {1..${#page_pathnames[@]}}; do
         page_pathnames[$i]="${page_pathnames[$i]:t}"
       done
       pathnames+=("${page_pathnames[@]}")

       has_more=$(echo "$response" | jq -r '.hasMore')
       if [ "$has_more" != "true" ]; then
         break
       fi
       cursor=$(echo "$response" | jq -r '.cursor')
     done

    files=(*.mp4)
    count=0
    total=${#files[@]}
    for f in "${files[@]}"; do
      ((count++))
      if [[ -z "${pathnames[(r)$f]}" ]]; then
        echo "uploading: $f"
        curl -s -X PUT "https://blob.vercel-storage.com/$f" \
              -H "Authorization: Bearer $BLOB_READ_WRITE_TOKEN" \
              -H "x-api-version: 7" \
              -H "x-add-random-suffix: 0" \
              --data-binary "@$f" \
              -o /dev/null -w "  -> HTTP %{http_code}\n"
      fi
      draw_progress "$count" "$total"

    done

    popd || exit
  fi


  files=("${(@f)$(find "$VIDEOS_DIR" -maxdepth 1 -type f -iname "*.mp4")}")
  total=${#files[@]}
  count=0
  for filepath in "${files[@]}"; do
    ((count++))
    ext="${filepath##*.}"
    ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    hash=$(md5sum "$filepath" | cut -c1-24)
    newname="$VIDEOS_DIR/$hash.$ext_lower"

    if [ "$filepath" = "$newname" ]; then
      : # no action needed
    elif [ -f "$newname" ]; then
      rm "$filepath"
      draw_progress "$count" "$total"
      continue
    else
      mv "$filepath" "$newname"
      filepath="$newname"
    fi

    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$filepath")
    duration_int=${duration%.*}
    [ -z "$duration_int" ] && duration_int=0

    resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$filepath")
    width=${resolution%x*}
    height=${resolution#*x}
    [ -z "$width" ] && width=0
    [ -z "$height" ] && height=0

#    echo "testing ${filepath} = ${duration_int}s (${width}x${height})"
    if [ "$duration_int" -ge "$MIN_TIME_SECONDS" ] && \
        [ "$duration_int" -le "$MAX_TIME_SECONDS" ] && \
        [ "$width" -ge "$MIN_RESOLUTION" ] && \
        [ "$height" -ge "$MIN_RESOLUTION" ]; then
      echo "$filepath" >> "$PLAYLIST"
    else
      rm -- "$filepath"
    fi

    draw_progress "$count" "$total"
  done
fi

caffeinate -d -i -w $$ &

# greyscale: add --saturation=0
open -a VLC --args  \
  --fullscreen \
  --random \
  --loop \
  --no-video-title-show --no-osd --no-video-deco --mouse-hide-timeout=0 --video-on-top \
  --avcodec-hw=any \
  --no-audio \
  --video-filter=adjust:sharpen --contrast=1.15 --brightness=1.05 --gamma=1.1 --sharpen-sigma=0.3 \
  "$PLAYLIST"