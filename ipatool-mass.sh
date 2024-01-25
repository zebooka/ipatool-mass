#!/bin/sh

while read L; do
    B=$(echo "$L" | awk '{ print $1 }')
    S=$(echo "$L" | awk '{ $1=""; print $0 }' | sed -E 's/^[ \n\r\t]+//g')
    if [ -z "$S" ]; then
        echo "\033[31m$L \033[1;7;31m No search term \033[0m"
        continue
    fi
    V=$(ipatool search --format json "$S" | jq ".apps[] | select(.bundleID==\"$B\") | .version" -r)
    if find . -type f -iname "${B}_*_${V}.ipa" | grep -qz . ; then
        echo "\033[2;37m$(find . -type f -iname "${B}_*.ipa" | sort -r | head -n1 | sed -E 's#^\./##') \033[0;37m$S\033[0m"
    else
        echo "\033[2;37m$B \033[0;37m$S \033[1;32m$V\033[0m"
        ipatool download -b "$B" --non-interactive --purchase
    fi
    mkdir -p "${S}" && test -f ${B}_*.ipa && mv -v ${B}_*.ipa "${S}/"
done < "${1:-/dev/stdin}"
