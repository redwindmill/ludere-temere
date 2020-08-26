#!/bin/bash
set -e

if [ -z "${1}" ] || [ -n "${2}" ]; then
	echo "arguments are <directory-to search>"
fi

find "${1}" -iname '*.mov' -print0 | \
while IFS= read -r -d '' SRC; do
	if [[ "$SRC" == *".mov"* ]]; then
		DST=${SRC%.mov}.m4v
	else
		DST=${SRC%.MOV}.m4v
	fi

	echo $SRC $DST
	avconvert -p PresetAppleM4V720pHD -s "${SRC}" -o "${DST}"
	gtouch --reference="${SRC}" "${DST}"
done
