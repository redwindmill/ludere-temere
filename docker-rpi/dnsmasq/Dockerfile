ARG IMAGE_BASE
FROM ${IMAGE_BASE}
RUN echo http://dl-cdn.alpinelinux.org/alpine/latest-stable/main > /etc/apk/repositories && \
	echo http://dl-cdn.alpinelinux.org/alpine/latest-stable/community >> /etc/apk/repositories && \
	apk --update --no-cache upgrade && \
	apk --no-cache add \
		dnsmasq

COPY root /
RUN chmod 755				'/docker/entrypoint.sh' && \
	chmod 644				'/docker/dnsmasq_hosts' && \
	chmod 644				'/docker/dnsmasq.conf'

EXPOSE 53/tcp 53/udp
ENTRYPOINT ["/docker/entrypoint.sh"]
