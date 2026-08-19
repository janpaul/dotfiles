#!/bin/bash
#
# Hernoemt mp3- en m4a-bestanden naar "Artist - Title (Jaar).ext" op basis van tags.
# De originele extensie (.mp3 / .m4a) blijft behouden per bestand.
# Gebruikt ffprobe (onderdeel van ffmpeg) om metadata uit te lezen.
#
# Gebruik:
#   ./rename_mp3s.sh "/pad/naar/Dance Classics"          # dry-run
#   ./rename_mp3s.sh "/pad/naar/Dance Classics" --apply  # voert het echt uit
#
# Vereist: ffmpeg  (macOS: brew install ffmpeg)

set -euo pipefail

DIR="${1:-}"
APPLY=false

for arg in "$@"; do
  if [[ "$arg" == "--apply" ]]; then
    APPLY=true
  fi
done

if [[ -z "$DIR" ]]; then
  echo "Gebruik: $0 <map> [--apply]"
  exit 1
fi

if [[ ! -d "$DIR" ]]; then
  echo "Map niet gevonden: $DIR"
  exit 1
fi

if ! command -v ffprobe &> /dev/null; then
  echo "ffprobe niet gevonden. Installeer ffmpeg met: brew install ffmpeg"
  exit 1
fi

sanitize() {
  # Verwijder tekens die niet in bestandsnamen mogen (macOS-safe) en trim whitespace
  echo "$1" | sed -E 's/[\/:*?"<>|\\]//g' | sed -E 's/[[:space:]]+/ /g' | sed -E 's/^ +| +$//g'
}

renamed=0
skipped=0
errors=0

# find gebruikt hier -print0 / read -d '' om spaties en rare tekens in bestandsnamen aan te kunnen
while IFS= read -r -d '' filepath; do
  filename="$(basename "$filepath")"
  dirpath="$(dirname "$filepath")"

  artist=$(ffprobe -v error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$filepath" 2>/dev/null || true)
  title=$(ffprobe -v error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$filepath" 2>/dev/null || true)
  date_tag=$(ffprobe -v error -show_entries format_tags=date -of default=noprint_wrappers=1:nokey=1 "$filepath" 2>/dev/null || true)

  if [[ -z "$date_tag" ]]; then
    # Sommige bestanden gebruiken "year" i.p.v. "date" als tagnaam
    date_tag=$(ffprobe -v error -show_entries format_tags=year -of default=noprint_wrappers=1:nokey=1 "$filepath" 2>/dev/null || true)
  fi

  # Pak alleen de eerste 4 cijfers (jaartal) uit de tag, ongeacht formaat (2019-05-01, 2019, etc.)
  year=$(echo "$date_tag" | grep -oE '[0-9]{4}' | head -n1 || true)

  if [[ -z "$artist" || -z "$title" ]]; then
    echo "[SKIP]    $filename -> mist artist/title tag"
    ((skipped++)) || true
    continue
  fi

  clean_artist=$(sanitize "$artist")
  clean_title=$(sanitize "$title")

  extension="${filename##*.}"

  if [[ -n "$year" ]]; then
    new_name="${clean_artist} - ${clean_title} (${year}).${extension}"
  else
    new_name="${clean_artist} - ${clean_title}.${extension}"
  fi
  new_path="${dirpath}/${new_name}"

  if [[ "$new_path" == "$filepath" ]]; then
    echo "[OK]      $filename (al correct)"
    continue
  fi

  if [[ -e "$new_path" ]]; then
    if $APPLY; then
      rm "$filepath"
      echo "[VERWIJDERD] $filename  (duplicaat van bestaand bestand: $new_name)"
    else
      echo "[DRY-RUN] zou verwijderen: $filename  (duplicaat van bestaand bestand: $new_name)"
    fi
    ((skipped++)) || true
    continue
  fi

  if $APPLY; then
    mv "$filepath" "$new_path"
    echo "[HERNOEMD] $filename  ->  $new_name"
  else
    echo "[DRY-RUN] $filename  ->  $new_name"
  fi

  ((renamed++)) || true

done < <(find "$DIR" -maxdepth 1 -type f \( -iname "*.mp3" -o -iname "*.m4a" \) -print0)

echo ""
echo "Klaar. Hernoemd: $renamed, overgeslagen: $skipped"
if ! $APPLY; then
  echo "Dit was een dry-run, er is niets gewijzigd. Voeg --apply toe om echt te hernoemen."
fi
