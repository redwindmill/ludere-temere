ARG IMAGE_BASE
FROM ${IMAGE_BASE}
ENV NGRAMS_PIN=20150817 \
	NGRAMS_PATH=/docker/ngrams \
	NGRAMS_HASH=3a0b6470a205c6b9f19a8b31469728f29818c58dd17e85a81ac4a928ab9f9512 \
	LANGTOOL_PIN=5.2 \
	LANGTOOL_PORT=8081 \
	LANTOOL_PATH=/docker/languagetool \
	LANTOOL_HASH=3a0b6470a205c6b9f19a8b31469728f29818c58dd17e85a81ac4a928ab9f9512

RUN echo http://dl-cdn.alpinelinux.org/alpine/latest-stable/main > /etc/apk/repositories && \
	echo http://dl-cdn.alpinelinux.org/alpine/latest-stable/community >> /etc/apk/repositories && \
	apk --update --no-cache upgrade && \
	apk --no-cache add \
		gcompat \
		libgomp \
		libstdc++ \
	&& update-ca-certificates 2>/dev/null

COPY root /
RUN chmod 755 '/docker/entrypoint.sh' &&
	curl -L https://www.languagetool.org/download/LanguageTool-${LANGTOOL_PIN}.zip -o '${LANGTOOL_PATH}.zip' && \
		sha256sum ${LANGTOOL_PATH}.zip && \
		echo "${LANGTOOL_HASH}  ${LANGTOOL_PATH}.zip" | sha256sum -c && \
		unzip ${LANGTOOL_PATH}.zip &&
		rm ${LANGTOOL_PATH}.zip
	curl -L https://languagetool.org/download/ngram-data/ngrams-en-${NGRAMS_PIN} -o '${NGRAMS_PATH}.zip' && \
		sha256sum ${NGRAMS_PATH}.zip && \
		echo "${NGRAMS_HASH}  ${NGRAMS_PATH}.zip" | sha256sum -c && \
		unzip ${NGRAMS_PATH}.zip &&
		rm ${NGRAMS_PATH}.zip

USER nobody
EXPOSE ${LANGTOOL_PORT}
WORKDIR ${LANGTOOL_PATH}
VOLUME ["/tmp"]
ENTRYPOINT ["/docker/entrypoint.sh"]
