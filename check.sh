#!/bin/bash

cd "$(dirname "$(readlink -f "$0")")"
shopt -s globstar

# shellcheck disable=SC2046
shellcheck -e SC1091,SC2016,SC2155,SC2209,SC2034,SC2164 --shell=bash ./**/*.{,z}sh $(grep -F '#!/bin/bash' -lr bin)
