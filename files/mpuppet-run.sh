#!/usr/bin/env bash
#
# Fetches latest masterless puppet changes, then applies them.
#
# Leans on mpuppet-fetch & mpuppet-apply.
#

[[ "$TRACE" ]] && set -o xtrace
set -o errexit
set -o nounset
set -o pipefail
set -o noclobber

exec 1> >(logger -s -t "$(basename "$0")") 2>&1

# Find the directory we are located in
readonly BINDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Fetch & apply. Fetch, and apply.
"$BINDIR/mpuppet-fetch"
"$BINDIR/mpuppet-apply" "$@"
