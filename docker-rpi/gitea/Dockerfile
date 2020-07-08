ARG IMAGE_BASE
FROM ${IMAGE_BASE}
ENV GITEA_PIN=1.10.3 \
	GITEA_PIN_SHORT=1.10 \
	GITEA_HASH=3a0b6470a205c6b9f19a8b31469728f29818c58dd17e85a81ac4a928ab9f9512

RUN echo http://dl-cdn.alpinelinux.org/alpine/latest-stable/main > /etc/apk/repositories && \
	echo http://dl-cdn.alpinelinux.org/alpine/latest-stable/community >> /etc/apk/repositories && \
	apk --update --no-cache upgrade && \
	apk --no-cache add \
		bash \
		ca-certificates \
		curl \
		gettext \
		git \
		linux-pam \
		openssh \
		s6 \
		sqlite \
		su-exec \
		subversion \
		tzdata && \
	addgroup \
		-S -g 1000 \
		git && \
	adduser \
		-S -H -D \
		-h /data/git \
		-s /bin/bash \
		-u 1000 \
		-G git \
		git && \
	update-ca-certificates 2>/dev/null || true && \
	echo "git:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd

RUN mkdir -p	'/app/gitea/' && \
	curl -L  https://dl.gitea.io/gitea/${GITEA_PIN}/gitea-${GITEA_PIN}-linux-arm64 -o '/app/gitea/gitea' && \
		sha256sum /app/gitea/gitea && \
		echo "${GITEA_HASH}  /app/gitea/gitea" | sha256sum -c && \
		chmod 755	'/app/gitea/gitea' && \
		ln -s		'/app/gitea/gitea' '/usr/local/bin/gitea' && \
	svn export https://github.com/go-gitea/gitea/branches/release/v${GITEA_PIN_SHORT}/docker/root / --force

ENV USER=git \
	GITEA_CUSTOM=/data/gitea

EXPOSE 22 3000
VOLUME ["/data"]
ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]
