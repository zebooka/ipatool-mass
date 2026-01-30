#!/bin/bash

while read L; do
    B=$(echo "$L" | awk '{ print $1 }')
    S=$(echo "$L" | awk '{ $1=""; print $0 }' | sed -E 's/^[ \n\r\t]+//g')
    if [ -z "$S" ]; then
        echo -e "\033[31m$L \033[1;7;31m No search term \033[0m"
        continue
    fi
    V=$(ipatool search --format json "$S" | jq ".apps[] | select(.bundleID==\"$B\") | .version" -r)
    D=$(dirname "$(find . -mindepth 1 -type f -iname "${B}_*.ipa" | head -n1 | grep . || echo "./${S}/.")")
    if find . -type f -iname "${B}_*_${V}.ipa" | grep -q . ; then
        echo -e "\033[2;37m$B \033[0;37m$D \033[2;37m$V\033[0m"
    else
        W=`find . -type f -iname "${B}_*.ipa" | sort --version-sort -r | head -n1 | xargs -I {} basename -s .ipa "{}" | tr _ ' ' | awk '{ print \$3 }'`
        echo -e "\033[2;37m$B \033[0;37m$D \033[2;37m$W » \033[0;1;32m$V\033[0m"
        ipatool download -b "$B" --purchase && echo -en "\r\033[A\033[K"
    fi
    mkdir -p "$D" && compgen -G ${B}_*.ipa >/dev/null && mv ${B}_*.ipa "${D}/"
done < "${1:-/dev/stdin}"

echo -en "\033[35m"
find . -type d | while read D; do
    find "$D" -maxdepth 1 -type f -iname '*.ipa' -flags nouchg | \
    sort --version-sort -r | \
    tail -n+2 | \
    while read O; do rm -v "$O"; done
done
find . -maxdepth 1 -type f -iname '*.ipa.tmp' -flags nouchg | while read F; do rm -v "$F"; done
echo -en "\033[0m"
