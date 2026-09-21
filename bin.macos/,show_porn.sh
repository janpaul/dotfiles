#!/opt/homebrew/bin/zsh

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Use: $0 <bank|bed>"
    exit 1
fi

DIR=$(dirname "$0")

. "$DIR"/,cast_start.sh "$1"
. "$DIR"/,xxx.sh
#. "$DIR"/,cast_stop.sh