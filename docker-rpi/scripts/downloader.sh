#!/bin/sh
set -e

#------------------------------------------------------------------------------#
NAME_SCRIPT=$(basename "${0}")

if [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ] || [ -n "${4}" ]; then
	echo "${NAME_SCRIPT}: arguments are <link> <hash> <dest>"
fi

LINK="${1}"
HASH="${2}"
DEST="${3}"

#------------------------------------------------------------------------------#

echo "${NAME_SCRIPT}: checking ${DEST}"
if !(echo "${HASH} ${DEST}" | sha256sum -c > /dev/null); then
	curl -L "${LINK}" --output "${DEST}"
	sha256sum "${DEST}"
	echo "${HASH} ${DEST}" | sha256sum -c
fi
