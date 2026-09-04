#!/opt/homebrew/bin/zsh
FOLDERS=("$HOME/Documents/videos" "$HOME/Downloads/gif")
MIN_TIME_SECONDS=14
MAX_TIME_SECONDS=120
MIN_RESOLUTION=480
PLAYLIST="$HOME/.xxx-playlist.m3u"

# Enable the following to re-build the playlist
# rm -f "$PLAYLIST"

caffeinate -d -i -w $$ &

if [ ! -e "$PLAYLIST" ]; then
  echo "playlist does not exist, creating..."
  for FOLDER in "${FOLDERS[@]}"; do

    if [ ! -d $FOLDER ]; then
       echo "video folder ${FOLDER} does not exist"
       continue
    fi

    for f in "$FOLDER"/*.mp4; do
      [ -e "$f" ] || continue

      duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f")
      duration_int=${duration%.*}
      [ -z "$duration_int" ] && duration_int=0

      resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$f")
      width=${resolution%x*}
      height=${resolution#*x}
      [ -z "$width" ] && width=0
      [ -z "$height" ] && height=0

      echo "testing ${f} = ${duration_int}s (${width}x${height})"
      if [ "$duration_int" -ge "$MIN_TIME_SECONDS" ] && \
       [ "$duration_int" -le "$MAX_TIME_SECONDS" ] && \
       [ "$width" -ge "$MIN_RESOLUTION" ] && \
       [ "$height" -ge "$MIN_RESOLUTION" ]; then
        echo " (✅ adding)"
        echo "$f" >> "$PLAYLIST"
      else
        echo " (❌ removing [${duration_int}s, ${width}x${height}])"
        rm -- "${f}"
      fi
    done
  done

  echo "playlist ready: $(wc -l < "$PLAYLIST") videos" >&2
fi

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