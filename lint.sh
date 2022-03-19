#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

# shellcheck disable=SC2046
shellcheck --exclude=SC1090,SC1091,SC2155,SC2164 "$@" \
    init \
    lint.sh \
    common/??-* \
    shrc/*bash* \
    $(file bin/* | grep 'shell script' | cut -d: -f1)

# SC1090 Can't follow non-constant source. Use a directive to specify location.
# SC1091 Not following: (error message here)
# SC2155 Declare and assign separately to avoid masking return values.
# SC2164 Use cd ... || exit in case cd fails.
