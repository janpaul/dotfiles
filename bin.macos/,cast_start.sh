#!/opt/homebrew/bin/zsh

# ONLY WORKS ON THE MACBOOK PRO WITH EXTERNAL MONITOR, NOT ON THE BUILT-IN DISPLAY

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Use: $0 <bank|bed>"
    exit 1
fi

case "$1" in
    bank)
        DEVICE_OFFSET="+0,-80"
        ;;
    bed)
        DEVICE_OFFSET="+0,-50"
        ;;
    *)
        echo "Unknown option: $1"
        echo "Use: $0 <bank|bed>"
        exit 1
        ;;
esac

cliclick -f - << EOF
m:2400,10
c:+0,+0
w:500
m:+110,+220
c:+0,+0
w:500
m:${DEVICE_OFFSET}
w:500
c:+0,+0
EOF


