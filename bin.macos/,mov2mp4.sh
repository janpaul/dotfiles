#!/bin/bash
FOLDER="/Users/janpaul/Downloads"

for f in "$FOLDER"/*.mov; do
  [ -e "$f" ] || continue
  output="${f%.mov}.mp4"
  ffmpeg -i "$f" -c:v libx264 -crf 18 -preset slow -c:a aac -b:a 192k "$output"
done
