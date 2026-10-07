#!/opt/homebrew/bin/zsh

hostname=$(scutil --get LocalHostName)

print -- ${(l:$(tput cols)::*:)${:-}}

if [[ $hostname == "elvis" ]]; then
  echo "Renaming videos in ~/Documents/videos"
else
  echo "This script is only intended to run on the MacBook Pro (=elvis). Exiting."
  exit 1
fi

setopt extendedglob nullglob

dir="${HOME}/Documents/videos"
pattern='(#i)*.(gif|mp4|mov|webm)(.)'

for f in $dir/$~pattern; do
  name=${f:t}
  ext=${${f:e}:l}

  [[ $name =~ '^[0-9a-f]{24}\.(gif|mp4|mov|webm)$' ]] && continue

  hash=$(md5 -q "$f")
  new=$dir/${hash[1,24]}.$ext

  if [[ -e $new ]]; then
    if cmp -s -- "$f" "$new"; then
      echo "Duplicate → Trash: $name"
      trash -- "$f"
    else
      echo "⚠️  Hash collision, nothing done: $name vs ${new:t}" >&2
    fi
  else
    echo "Renamed: $name -> ${new:t}"
    mv -n -- "$f" "$new"
  fi
done

echo