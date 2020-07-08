IMAGE:= redwindmill/rpi-kanboard
TAG:= test
BASE:= arm64v8/alpine:latest
RUN_NAME:= rpi-kanboard
RUN_VOL:= /mnt/kanboard/data

include $(MAKEFILE_BUILDER)
#------------------------------------------------------------------------------#

.PHONY: up
up::
	@mkdir -pv $(RUN_VOL)
	@docker run -d --restart=always \
		--init \
		--log-opt max-size=128k \
		--log-opt tag="$(RUN_NAME)" \
		--name "$(RUN_NAME)" \
		--hostname "$(RUN_NAME)-cont" \
		--security-opt no-new-privileges \
		--net proxy \
		-v $(RUN_VOL)/data:/var/www/app/data \
		-v $(RUN_VOL)/plugins:/var/www/app/plugins \
		-v $(RUN_VOL)/ssl:/etc/nginx/ssl/ \
		$(IMAGE)
