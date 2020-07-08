DOCKER_IMG_NAME:= redwindmill/red-gpwd
DOCKER_IMG_BUILDER:= $(DOCKER_IMG_NAME)-builder:dev

META_BUILD_SOURCE?= $(shell hostname)
META_GIT_HASH= $(shell git log -1 --pretty=%H)
META_GIT_AUTHOR= $(shell git log -1 --pretty=%aE)
META_GIT_AUTHOR_DATE= $(shell git log -1 --pretty=%at)
META_GIT_COMMITTER= $(shell git log -1 --pretty=%cE)
META_GIT_COMMITTER_DATE= $(shell git log -1 --pretty=%ct)

#------------------------------------------------------------------------------#

DIR_SRC:= $(CURDIR)/src
DIR_BIN:= $(CURDIR)/bin
DIR_GO_BUILD:= $(DIR_BIN)/go_build
DIR_GO_TMP:= $(DIR_BIN)/go_tmp

DIR_TARGETS:= \
	$(DIR_BIN) \
	$(DIR_GO_BUILD) \
	$(DIR_GO_TMP)

# ARTIFACTS
#------------------------------------------------------------------------------#

AF_MODULE:= red-gpwd
AF_NAME:= rgpwd
AF_OS?= linux
AF_PLAT?= amd64

ARTIFACT_PREFIX:= af-
ARTIFACT_COMMANDS:= \
	help \
	help-env \
	build \
	build-race \
	build-msan \
	run \
	audit-vet \
	audit-test \
	audit-test-race \
	audit-test-msan \
	audit-escape \
	audit-profile \
	go-fmt \
	go-init \
	go-vendor

ARTIFACT_TARGETS:= $(strip $(patsubst %, $(ARTIFACT_PREFIX)%, $(ARTIFACT_COMMANDS)))

.PHONY: $(ARTIFACT_TARGETS)
$(ARTIFACT_TARGETS): $(DIR_TARGETS)
	@echo "#    STEP: ARTIFACTS $(@:$(ARTIFACT_PREFIX)%=%)"
	@docker run --rm -t \
		-v $(DIR_SRC):/mnt/src \
		-v $(DIR_BIN):/mnt/out \
		-e GOCACHE=/mnt/out/go_build \
		-e GOTMPDIR=/mnt/out/go_tmp \
		$(DOCKER_IMG_BUILDER) \
		make $(@:$(ARTIFACT_PREFIX)%=%) \
			DIR_BIN=/mnt/out \
			TARGET_OS=$(AF_OS) \
			TARGET_PLATFORM=$(AF_PLAT) \
			MODULE_NAME=$(AF_MODULE) \
			OUTPUT_NAME=$(AF_NAME)
		@echo
		@echo "#    STEP: END"

# ENVIRONMENT
#------------------------------------------------------------------------------#

.PHONY: util-purge
util-purge:
	@rm -r $(DIR_BIN)/*

.PHONY: util-init
util-init: $(DIR_TARGETS)
	@echo "#    STEP: BUILD INIT"
	@docker build \
		--label red.git.hash=$(META_GIT_HASH) \
		--label red.git.author.email=$(META_GIT_AUTHOR) \
		--label red.git.author.date=$(META_GIT_AUTHOR_DATE) \
		--label red.git.committer.email=$(META_GIT_COMMITTER) \
		--label red.git.committer.date=$(META_GIT_COMMITTER_DATE) \
		--label red.build.source=$(META_BUILD_SOURCE) \
		-t $(DOCKER_IMG_BUILDER) \
		-f $(CURDIR)/docker/builder.dockerfile \
		$(CURDIR)/docker/
	@echo
	@echo "#    STEP: END"

$(DIR_TARGETS):
	@mkdir -pv $@

# HELP
#------------------------------------------------------------------------------#
.DEFAULT_GOAL:=help

.PHONY: help
help:
	@echo "[ENVIRONMENT OPTIONS]"
	@echo "  util-init  : initialize build environment"
	@echo "  util-purge : clean up build artifacts"
	@echo
	@echo "[ARTIFACT OPTIONS]"
	@echo "$(ARTIFACT_TARGETS)" | tr ' ' '\n' | awk '{print "    "$$0}'
	@echo "  AF_OS   : TARGET_OS for $(ARTIFACT_PREFIX)build ($(AF_OS))"
	@echo "  AF_PLAT : TARGET_PLATFORM for $(ARTIFACT_PREFIX)build ($(AF_PLAT))"
	@echo "  *see '$(ARTIFACT_PREFIX)help' for more information."
