IMAGE:= redwindmill/rpi-gitea
TAG:= test
BASE:= arm64v8/alpine:latest
RUN_NAME:= rpi-gitea
RUN_VOL:= /mnt/gitea/data

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
		-v $(RUN_VOL):/data \
		$(IMAGE)
