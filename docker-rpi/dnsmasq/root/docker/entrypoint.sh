#!/bin/sh
set -e

echo `date -u` "(entrypoint): configuring"
dnsmasq --test -C /docker/dnsmasq.conf

echo `date -u` "(entrypoint): running service"
if [ "$1" = "run" ]; then
	shift
	exec "$@"
elif [ "$1" = "test" ]; then
	dnsmasq -k \
		-C /docker/dnsmasq.conf \
		-H /docker/dnsmasq_hosts \
		--log-facility=- \
		--log-queries
else
	exec dnsmasq -k \
		-C /docker/dnsmasq.conf \
		-H /docker/dnsmasq_hosts \
		--log-facility=-
fi
