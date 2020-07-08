BUILD_IMAGE_NAME:= $(NAME)
BUILD_IMAGE_BASE:= $(BASE)

ifeq ($(OVERRIDE_TAG),"")
BUILD_IMAGE_TAG:= $(OVERRIDE_TAG)
else
BUILD_IMAGE_TAG:= $(TAG)
endif

META_GIT_HASH:= $(shell git log -1 --pretty=%H)
META_GIT_BRANCH_CLEAN:= $(shell [[ $$(git status --porcelain 2>/dev/null) ]] && echo "--unclean" || echo "")
META_GIT_BRANCH:= $(shell git symbolic-ref --short HEAD 2>/dev/null)$(META_GIT_BRANCH_CLEAN)
META_GIT_AUTHOR:= $(shell git log -1 --pretty=%aE)
META_GIT_AUTHOR_DATE:= $(shell git log -1 --pretty=%ai)
META_GIT_COMMITTER:= $(shell git log -1 --pretty=%cE)
META_GIT_COMMITTER_DATE:= $(shell git log -1 --pretty=%ci)
META_BUILD_SOURCE:= $(shell whoami)@$(shell hostname)

#------------------------------------------------------------------------------#
DOWNLOADER_SCRIPT:= $(SCRIPTS_PATH)/downloader.sh
DOWNLOADER_PATH:= $(BUILD_ROOT_PATH)/downloads

.PHONY: sync
sync:: $(DOWNLOADS_PATH)

$(DOWNLOADS_PATH):
	@mkdir -pv $@

.PHONY: build
build: __build-docker-image __build-docker-clean __build-docker-inspect

.PHONY: __build-docker-image
__build-docker-image:
	@docker build \
		--label red.git.hash="$(META_GIT_HASH)" \
		--label red.git.branch="$(META_GIT_BRANCH)" \
		--label red.git.author.email="$(META_GIT_AUTHOR)" \
		--label red.git.author.date="$(META_GIT_AUTHOR_DATE)" \
		--label red.git.committer.email="$(META_GIT_COMMITTER)" \
		--label red.git.committer.date="$(META_GIT_COMMITTER_DATE)" \
		--label red.build.image.base="$(BUILD_IMAGE_BASE)" \
		--label red.build.source="$(META_BUILD_SOURCE)" \
		--build-arg http_proxy="$(HTTP_PROXY)" \
		--build-arg https_proxy="$(HTTPS_PROXY)" \
		--build-arg IMAGE_BASE="$(BUILD_IMAGE_BASE)" \
		-t $(BUILD_IMAGE_NAME):$(BUILD_IMAGE_TAG) .
	@docker image tag $(BUILD_IMAGE_NAME):$(BUILD_IMAGE_TAG) $(BUILD_IMAGE_NAME):latest

.PHONY: __build-docker-clean
__build-docker-clean:
	@docker container prune -f
	@docker image prune -f

.PHONY: __build-docker-inspect
__build-docker-inspect:
	@docker inspect -f "{{.Config.Labels}}" ${BUILD_IMAGE_NAME}:${BUILD_IMAGE_TAG}

#------------------------------------------------------------------------------#

.PHONY: pullbase
pullbase:
	@docker pull "$(BUILD_IMAGE_BASE)"

.PHONY: push
push:
	@docker push $(BUILD_IMAGE_NAME):$(BUILD_IMAGE_TAG)
	@docker push $(BUILD_IMAGE_NAME):latest

#------------------------------------------------------------------------------#

.PHONY: up
up::

.PHONY: shell
shell:
	@docker exec -it $(RUN_NAME) sh

.PHONY: logs
logs:
	@docker logs -f $(RUN_NAME)

.PHONY: down
down:
	@docker rm -f $(RUN_NAME)

.PHONY: purge
purge:
	@docker rmi `docker images | grep $(RUN_NAME) | awk '{ print $$3 }'`

#------------------------------------------------------------------------------#
.DEFAULT_GOAL:=help

.PHONY: help
help:
	@echo "ENVIRONMENT"
	@echo "--------------------------------------------------------------------"
	@echo "  IMAGE_NAME: '$(BUILD_IMAGE_NAME)'"
	@echo "  IMAGE_TAG : '$(BUILD_IMAGE_TAG)'"
	@echo "  IMAGE_BASE: '$(BUILD_IMAGE_BASE)'"
	@echo "  RUN_NAME:   '$(RUN_NAME)'"
	@echo
	@echo "  META_BUILD_SOURCE: '$(META_BUILD_SOURCE)'"
	@echo
	@echo "  META_GIT_HASH          : '$(META_GIT_HASH)'"
	@echo "  META_GIT_BRANCH        : '$(META_GIT_BRANCH)'"
	@echo "  META_GIT_AUTHOR        : '$(META_GIT_AUTHOR)'"
	@echo "  META_GIT_AUTHOR_DATE   : '$(META_GIT_AUTHOR_DATE)'"
	@echo "  META_GIT_COMMITTER     : '$(META_GIT_COMMITTER)'"
	@echo "  META_GIT_COMMITTER_DATE: '$(META_GIT_COMMITTER_DATE)'"
	@echo
	@echo "  HTTP_PROXY : '$(HTTP_PROXY)'"
	@echo "  HTTPS_PROXY: '$(HTTPS_PROXY)'"
	@echo
