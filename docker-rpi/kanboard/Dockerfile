ARG IMAGE_BASE
FROM ${IMAGE_BASE}
ENV KANBOARD_PIN=1.2.18 \
	KANBOARD_HASH=5c5eb3d4eb0f90fd8e10b68f43f065c68ffa67ca882edf13cf6b0aaf26422109

RUN echo http://dl-cdn.alpinelinux.org/alpine/latest-stable/main > /etc/apk/repositories && \
	echo http://dl-cdn.alpinelinux.org/alpine/latest-stable/community >> /etc/apk/repositories && \
	apk --update --no-cache upgrade && \
	apk --no-cache add \
		bash \
		ca-certificates \
		curl \
		mailx \
		nginx \
		openssl \
		php7 \
		php7-bcmath \
		php7-ctype \
		php7-curl \
		php7-dom \
		php7-fpm \
		php7-gd \
		php7-iconv \
		php7-json \
		php7-ldap \
		php7-mbstring \
		php7-mcrypt \
		php7-opcache \
		php7-openssl \
		php7-pdo \
		php7-pdo_mysql \
		php7-pdo_pgsql \
		php7-pdo_sqlite \
		php7-phar \
		php7-posix \
		php7-session \
		php7-simplexml \
		php7-sockets \
		php7-xml \
		php7-zip \
		php7-zlib \
		s6 \
		subversion \
		ssmtp \
		tzdata
		unzip \
	&& rm -rf /var/www/localhost \
	&& rm -f /etc/php7/php-fpm.d/www.conf

RUN curl -L https://github.com/kanboard/kanboard/archive/v${KANBOARD_PIN}.zip -o /tmp/kanboard.zip && \
		sha256sum /tmp/kanboard.zip && \
		echo "${KANBOARD_HASH}  /tmp/kanboard.zip" | sha256sum -c && \
		unzip /tmp/kanboard.zip -d /var/www && \
		mv /var/www/kanboard-${KANBOARD_PIN} /var/www/app && \
		rm -f /tmp/kanboard.zip && \
	svn export https://github.com/kanboard/kanboard/branches/master/docker / --force && \
		mkdir -vp /etc/nginx/ssl

EXPOSE 80
VOLUME [ \
	"/var/www/app/data", \
	"/var/www/app/plugins", \
	"/etc/nginx/ssl/", \
]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
