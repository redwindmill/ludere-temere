#!/bin/sh
set -e

echo `date -u` "(entrypoint): configuring"
EXTRAOPTIONS=" --languageModel ${NGRAMS_PATH}"

echo `date -u` "(entrypoint): running service"
if [ "$1" = "run" ]; then
	shift
	exec "$@"
elif [ "$1" = "test" ]; then
	java \
		-cp languagetool-server.jar org.languagetool.server.HTTPServer \
		--port ${LANGTOOL_PORT} \
		--allow-origin '*' \
		--public ${EXTRAOPTIONS}
else
	exec java \
		-cp languagetool-server.jar org.languagetool.server.HTTPServer \
		--port ${LANGTOOL_PORT} \
		--allow-origin '*' \
		--public ${EXTRAOPTIONS}
fi
