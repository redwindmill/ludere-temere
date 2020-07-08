IMAGE:= redwindmill/rpi-dnsmasq
TAG:= test
BASE:= arm64v8/alpine:latest
RUN_NAME:= rpi-dnsmasq

include $(MAKEFILE_BUILDER)
#------------------------------------------------------------------------------#

.PHONY: up
up::
	@docker run -d --restart=always \
		--init \
		--log-opt max-size=128k \
		--log-opt tag="$(RUN_NAME)" \
		--name "$(RUN_NAME)" \
		--hostname "$(RUN_NAME)-cont" \
		--cap-add=NET_ADMIN \
		--security-opt no-new-privileges \
		-p 53:53/tcp \
		-p 53:53/udp \
		$(IMAGE)
