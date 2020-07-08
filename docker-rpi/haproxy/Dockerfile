ARG IMAGE_BASE
FROM ${IMAGE_BASE}
RUN echo http://dl-cdn.alpinelinux.org/alpine/latest-stable/main > /etc/apk/repositories && \
	echo http://dl-cdn.alpinelinux.org/alpine/latest-stable/community >> /etc/apk/repositories && \
	apk --update --no-cache upgrade

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY tmp/cert.crt.key.pem /usr/local/etc/haproxy/certificate.key
