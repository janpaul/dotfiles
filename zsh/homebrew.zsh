#
# Homebrew

[[ -d /opt/homebrew ]] && eval $(/opt/homebrew/bin/brew shellenv)

LDFLAGS="-L/opt/homebrew/opt/libxml2/lib $LDFLAGS"
CPPFLAGS="-I/opt/homebrew/opt/libxml2/include $CPPFLAGS"

# uses homebrew's version of curl
PATH="/opt/homebrew/opt/curl/bin:$PATH"
LDFLAGS="-L/opt/homebrew/opt/curl/lib $LDFLAGS"
CPPFLAGS="-I/opt/homebrew/opt/curl/include $CPPFLAGS"

export HOMEBREW_INSTALL_CLEANUP=true
