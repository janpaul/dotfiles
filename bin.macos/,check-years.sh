#!/bin/bash
#
# Zoekt via de MusicBrainz API het vroegste bekende releasejaar per track op,
# en vergelijkt dat met het jaar dat in je eigen mp3/m4a-tags staat.
# Maakt GEEN wijzigingen aan bestanden of tags — genereert alleen een CSV-rapport
# zodat je zelf kan beoordelen welke afwijkingen kloppen.
#
# HERVATBAAR: schrijft direct (per track) naar het CSV-bestand. Onderbreek je het
# script (Ctrl+C, crash, laptop dicht), draai je gewoon exact hetzelfde commando
# opnieuw — bestanden die al in de CSV staan worden overgeslagen.
#
# OPTIONEEL derde argument: een filterbestand ("artist,title,year") met alleen de
# "actie-gevallen": status AFWIJKING waarbij tag_jaar > musicbrainz_jaar (jouw tag is
# waarschijnlijk een latere/foute reissue-datum, MusicBrainz suggereert een ouder jaar).
# NIET_GEVONDEN_OP_MUSICBRAINZ wordt bewust NIET meegenomen: te veel ruis, vaak klopt de
# tag daar al en is er simpelweg niks om automatisch mee te vergelijken.
# Dit filterbestand wordt bij elke run volledig herbouwd uit het hoofdrapport, dus
# blijft consistent ook als je het script meerdere keren hervat.
#
# Gebruik:
#   ./check_years.sh "/pad/naar/Dance Classics" jaar_rapport.csv [actie_gevallen.csv]
#
# Vereist: ffmpeg (voor ffprobe) en jq
#   macOS: brew install ffmpeg jq

set -euo pipefail

DIR="${1:-}"
OUTFILE="${2:-}"
FILTERFILE="${3:-}"

if [[ -z "$DIR" || ! -d "$DIR" || -z "$OUTFILE" ]]; then
  echo "Gebruik: $0 <map> <output.csv> [actie_gevallen.csv]" >&2
  exit 1
fi

for cmd in ffprobe jq curl awk; do
  if ! command -v "$cmd" &> /dev/null; then
    echo "$cmd niet gevonden. Installeer met: brew install ffmpeg jq" >&2
    exit 1
  fi
done

# MusicBrainz vraagt een duidelijke User-Agent en max ~1 request/seconde
USER_AGENT="DanceClassicsYearCheck/1.0 ( janpaul@example.com )"

url_encode() {
  jq -sRr @uri <<< "$1" | tr -d '\n'
}

# Escaped een veld voor gebruik binnen dubbele quotes in CSV (dubbele quotes -> twee dubbele quotes)
csv_escape() {
  echo "${1//\"/\"\"}"
}

# Strip alles tussen haakjes/blokhaken (Remastered, Radio Edit, 2016, feat. X, etc.)
# zodat de zoekopdracht op de kale titel gebeurt. Wordt alleen gebruikt voor de MusicBrainz-query,
# de originele tag_title in het rapport blijft onaangeroerd.
clean_for_search() {
  echo "$1" | sed -E 's/\([^)]*\)//g; s/\[[^]]*\]//g' | sed -E 's/[[:space:]]+/ /g' | sed -E 's/^ +| +$//g'
}

# Normaliseert allerlei apostrof-achtige tekens (´ ` ’ ‘) naar de gewone rechte apostrof '.
# MusicBrainz-titels gebruiken vrijwel altijd de rechte apostrof, dus "Can´t" (accent aigu,
# vaak per ongeluk gebruikt i.p.v. een echte apostrof) matcht anders niet met "Can't".
normalize_apostrophes() {
  echo "$1" | sed -E "s/[´\`’‘]/'/g"
}

# Bouwt (of herbouwt) het filterbestand volledig uit het hoofdrapport, in het simpele
# formaat "artist,title,year" (year = voorgesteld_jaar). Alleen AFWIJKING-regels waar
# tag_jaar > musicbrainz_jaar (NIET_GEVONDEN wordt bewust niet meegenomen, dat is te veel
# ruis: vaak klopt de tag al gewoon, er is dan simpelweg niks om mee te vergelijken).
read -r -d '' AWK_FILTER_PROG << 'AWKEOF' || true
function parse_csv(line, fields,    i, ch, field, inquotes, n) {
  n = 0
  field = ""
  inquotes = 0
  for (i = 1; i <= length(line); i++) {
    ch = substr(line, i, 1)
    if (inquotes) {
      if (ch == "\"") {
        if (substr(line, i+1, 1) == "\"") { field = field "\""; i++ }
        else { inquotes = 0 }
      } else {
        field = field ch
      }
    } else {
      if (ch == "\"") { inquotes = 1 }
      else if (ch == ",") { fields[++n] = field; field = "" }
      else { field = field ch }
    }
  }
  fields[++n] = field
}
function csv_field(s,    r) {
  r = s
  gsub(/"/, "\"\"", r)
  return "\"" r "\""
}
NR == 1 { next }
{
  delete f
  parse_csv($0, f)
  status = f[10]
  tag_jaar = f[4] + 0
  mb_jaar = f[6] + 0
  neem_mee = 0
  if (status == "AFWIJKING" && f[6] != "" && tag_jaar > mb_jaar) neem_mee = 1
  if (neem_mee) print csv_field(f[2]) "," csv_field(f[3]) "," csv_field(f[9])
}
AWKEOF

regenerate_filterfile() {
  [[ -z "$FILTERFILE" || ! -f "$OUTFILE" ]] && return
  {
    echo "artist,title,year"
    awk "$AWK_FILTER_PROG" "$OUTFILE"
  } > "$FILTERFILE"
}

# Appendt (niet herschrijft) een regel aan het filterbestand als 'ie aan de criteria voldoet.
# Dit houdt het bestand echt append-only, fijn te combineren met `tail -f`.
maybe_append_to_filterfile() {
  local status="$1" tag_jaar="$2" mb_jaar="$3" artist="$4" title="$5" voorgesteld_jaar="$6"
  [[ -z "$FILTERFILE" ]] && return
  local neem_mee=0
  if [[ "$status" == "AFWIJKING" && -n "$mb_jaar" && "$tag_jaar" -gt "$mb_jaar" ]]; then
    neem_mee=1
  fi
  if [[ "$neem_mee" == "1" ]]; then
    echo "\"$(csv_escape "$artist")\",\"$(csv_escape "$title")\",\"$voorgesteld_jaar\"" >> "$FILTERFILE"
  fi
}

if [[ ! -f "$OUTFILE" ]]; then
  echo "bestand,tag_artist,tag_title,tag_jaar,zoekterm,musicbrainz_jaar,musicbrainz_titel,musicbrainz_artiest,voorgesteld_jaar,status" > "$OUTFILE"
  echo "Nieuw rapport gestart: $OUTFILE"
else
  al_verwerkt=$(($(wc -l < "$OUTFILE") - 1))
  echo "Bestaand rapport gevonden ($al_verwerkt tracks al verwerkt), ga verder waar ik gebleven was..."
fi

if [[ -n "$FILTERFILE" ]]; then
  regenerate_filterfile
  echo "Filterbestand actief: $FILTERFILE (alleen AFWIJKING met tag_jaar > mb_jaar)"
fi

totaal=0
overgeslagen_al_gedaan=0
verwerkt_deze_run=0

while IFS= read -r -d '' filepath; do
  filename="$(basename "$filepath")"
  ((totaal++)) || true

  # Check of deze bestandsnaam al als eerste CSV-kolom in het rapport staat -> dan skippen
  if grep -qF "\"$(csv_escape "$filename")\"," "$OUTFILE"; then
    ((overgeslagen_al_gedaan++)) || true
    continue
  fi

  artist=$(ffprobe -v error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$filepath" 2>/dev/null || true)
  title=$(ffprobe -v error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$filepath" 2>/dev/null || true)
  date_tag=$(ffprobe -v error -show_entries format_tags=date -of default=noprint_wrappers=1:nokey=1 "$filepath" 2>/dev/null || true)
  [[ -z "$date_tag" ]] && date_tag=$(ffprobe -v error -show_entries format_tags=year -of default=noprint_wrappers=1:nokey=1 "$filepath" 2>/dev/null || true)
  tag_year=$(echo "$date_tag" | grep -oE '[0-9]{4}' | head -n1 || true)

  if [[ -z "$artist" || -z "$title" ]]; then
    echo "\"$(csv_escape "$filename")\",,,\"$tag_year\",,,,,,GEEN_ARTIST_OF_TITLE_TAG" >> "$OUTFILE"
    ((verwerkt_deze_run++)) || true
    echo "[$verwerkt_deze_run] $filename -> geen artist/title tag"
    continue
  fi

  search_title=$(clean_for_search "$(normalize_apostrophes "$title")")
  # Bij meerdere artiesten (Camille Jones, Fedde Le Grand) alleen de eerste gebruiken voor de zoekopdracht,
  # exacte multi-artist strings matchen zelden precies met MusicBrainz' artist-credit format.
  # (lowercase voor de split, hoofdletters zijn niet relevant voor de zoekopdracht zelf)
  search_artist=$(normalize_apostrophes "$artist" | tr '[:upper:]' '[:lower:]' | awk '{
    split($0, a, /,| feat\.?| ft\.?| featuring | vs\.?| x /);
    gsub(/^ +| +$/, "", a[1]);
    print a[1]
  }')

  query="artist:\"${search_artist}\" AND recording:\"${search_title}\""
  encoded_query=$(url_encode "$query")
  zoekterm="${search_artist} - ${search_title}"

  # Haal op met HTTP-statuscode erbij, en probeer max 3x bij een fout/rate-limit (503),
  # zodat een tijdelijk hikje niet ten onrechte als "niet gevonden" wordt gelabeld.
  # limit=15 (i.p.v. 5): bij oudere classics (jaren 70/80) staat de originele release soms
  # verder terug in de zoekresultaten, achter latere remasters/compilaties/heruitgaves.
  http_code=""
  response=""
  for poging in 1 2 3; do
    raw=$(curl -s -w "\n%{http_code}" -A "$USER_AGENT" \
      "https://musicbrainz.org/ws/2/recording/?query=${encoded_query}&fmt=json&limit=15" || true)
    http_code=$(echo "$raw" | tail -n1)
    response=$(echo "$raw" | sed '$d')

    if [[ "$http_code" == "200" ]]; then
      break
    fi
    echo "  [waarschuwing] poging $poging: HTTP $http_code van MusicBrainz voor '$filename', wacht en probeer opnieuw..." >&2
    sleep 3
  done

  if [[ "$http_code" != "200" ]]; then
    echo "\"$(csv_escape "$filename")\",\"$(csv_escape "$artist")\",\"$(csv_escape "$title")\",\"$tag_year\",\"$(csv_escape "$zoekterm")\",,,,\"$tag_year\",API_FOUT_HTTP_${http_code}" >> "$OUTFILE"
    ((verwerkt_deze_run++)) || true
    echo "[$verwerkt_deze_run] $filename -> API_FOUT (HTTP $http_code, na 3 pogingen)"
    sleep $(( (RANDOM % 5) + 1 ))
    continue
  fi

  # Zoek de recording met het vroegste first-release-date, en bewaar diens titel + artiest
  # zodat je kan zien of MusicBrainz echt hetzelfde nummer matchte of iets anders (cover/remix/live).
  mb_match=$(echo "$response" | jq -r '
    [.recordings[]? | select(.["first-release-date"]? // empty | length >= 4)]
    | map({
        year: (.["first-release-date"][0:4]),
        title: .title,
        artist: ([.["artist-credit"][]?.name] | join(" "))
      })
    | map(select(.year | test("^[0-9]{4}$")))
    | sort_by(.year)
    | .[0]
    | if . == null then "||" else "\(.year)|\(.title)|\(.artist)" end
  ' 2>/dev/null || echo "||")

  mb_year="${mb_match%%|*}"
  rest="${mb_match#*|}"
  mb_title="${rest%%|*}"
  mb_artist="${rest#*|}"

  if [[ -z "$mb_year" ]]; then
    status="NIET_GEVONDEN_OP_MUSICBRAINZ"
    voorgesteld_jaar="$tag_year"
  elif [[ -z "$tag_year" ]]; then
    status="TAG_HEEFT_GEEN_JAAR"
    voorgesteld_jaar="$mb_year"
  elif [[ "$mb_year" == "$tag_year" ]]; then
    status="KOMT_OVEREEN"
    voorgesteld_jaar="$tag_year"
  else
    status="AFWIJKING"
    # Vuistregel: het oudste van de twee jaartallen is meestal het originele releasejaar.
    # Een latere heruitgave/remaster/compilatie-datum overschrijft nooit een eerder bekend jaar.
    if [[ "$mb_year" -gt "$tag_year" ]]; then
      voorgesteld_jaar="$tag_year"
    else
      voorgesteld_jaar="$mb_year"
    fi
  fi

  csv_line="\"$(csv_escape "$filename")\",\"$(csv_escape "$artist")\",\"$(csv_escape "$title")\",\"$tag_year\",\"$(csv_escape "$zoekterm")\",\"$mb_year\",\"$(csv_escape "$mb_title")\",\"$(csv_escape "$mb_artist")\",\"$voorgesteld_jaar\",$status"
  echo "$csv_line" >> "$OUTFILE"

  ((verwerkt_deze_run++)) || true
  echo "[$verwerkt_deze_run] $filename -> $status ($tag_year / $mb_year)"
  maybe_append_to_filterfile "$status" "$tag_year" "$mb_year" "$artist" "$title" "$voorgesteld_jaar"

  # Random pauze tussen de 1 en 5 seconden i.p.v. een vaste 1.1s, dat is minder voorspelbaar
  # voor MusicBrainz' rate-limiter en geeft minder 503's bij langere runs.
  sleep $(( (RANDOM % 5) + 1 ))

done < <(find "$DIR" -maxdepth 1 -type f \( -iname "*.mp3" -o -iname "*.m4a" \) -print0)

echo ""
echo "Klaar met deze run. Totaal gevonden: $totaal, al eerder gedaan (overgeslagen): $overgeslagen_al_gedaan, nieuw verwerkt: $verwerkt_deze_run"
if [[ -n "$FILTERFILE" ]]; then
  aantal_actie=$(($(wc -l < "$FILTERFILE") - 1))
  echo "Filterbestand: $FILTERFILE ($aantal_actie tracks om na te lopen)"
fi
