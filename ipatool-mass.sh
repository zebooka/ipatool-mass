#!/bin/bash

while read L; do
    B=$(echo "$L" | awk '{ print $1 }')
    S=$(echo "$L" | awk '{ $1=""; print $0 }' | sed -E 's/^[ \n\r\t]+//g')
    if [ -z "$S" ]; then
        echo -e "\033[31m$L \033[1;7;31m No search term \033[0m"
        continue
    fi
    V=$(ipatool search --format json "$S" | jq ".apps[] | select(.bundleID==\"$B\") | .version" -r)
    if find . -type f -iname "${B}_*_${V}.ipa" | grep -qz . ; then
        echo -e "\033[2;37m$(find . -type f -iname "${B}_*.ipa" | sort --version-sort -r | head -n1 | sed -E 's#^\./##') \033[0;37m$S\033[0m"
    else
        echo -e "\033[2;37m$B \033[0;37m$S \033[1;32m$V\033[0m"
        ipatool download -b "$B" --purchase
    fi
    mkdir -p "${S}" && test -f ${B}_*.ipa && mv -v ${B}_*.ipa "${S}/"
done < "${1:-/dev/stdin}"

echo -e "\033[31m"
find . -type d -maxdepth 1 -mindepth 1 | while read D; do
    find "$D" -type f -iname '*.ipa' -flags nouchg | \
    sort --version-sort -r | \
    tail -n+2 | \
    while read O; do rm -v "$O"; done
done
echo -e "\033[0m"
