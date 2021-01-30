IMAGE:= redwindmill/rpi-languagetool
TAG:= test
BASE:= arm64v8/openjdk:15-alpine
RUN_NAME:= rpi-languagetool
RUN_TMP:= /tmp/languagetool

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
		-v $(RUN_TMP):/tmp \
		-e EXTRAOPTIONS="-Xmx128M"
		$(IMAGE)
