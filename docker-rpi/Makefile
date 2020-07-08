SCRIPTS_DIR:= scripts
BUILD_ROOT_DIR:= bin

TARGET_CONTAINERS:= $(shell \
	find . -maxdepth 1 -type d | \
	grep -v '^.$$' | \
	sort | \
	sed -e 's/.\///' | \
	grep -v '^.git\|^$(SCRIPTS_DIR)|^$(TMP_DIR)' \
)

TARGET_POSTFIXES:= \
	pullbase \
	build \
	push \
	up \
	shell \
	logs \
	down \
	purge \
	help

SCRIPTS_PATH:= $(CURDIR)/$(SCRIPTS_DIR)
BUILD_ROOT_PATH:= $(CURDIR)/$(BUILD_ROOT_DIR)

MAKEFILE_BUILDER:= $(SCRIPTS_PATH)/container.mk

#------------------------------------------------------------------------------#

CMD_TARGETS:= $(foreach TARGET_POSTFIX, $(TARGET_POSTFIXES), \
	$(strip $(patsubst %, %-$(TARGET_POSTFIX), $(TARGET_CONTAINERS))))

.PHONY: $(CMD_TARGETS)
$(CMD_TARGETS):
	@$(MAKE) -C $(CURDIR)/$(@:%-$(lastword $(subst -, ,$@))=%) \
		OVERRIDE_TAG=$(TAG) \
		SCRIPTS_PATH=$(SCRIPTS_PATH) \
		BUILD_ROOT_PATH=$(BUILD_ROOT_PATH) \
		MAKEFILE_BUILDER=$(MAKEFILE_BUILDER) \
		-f meta.mk $(lastword $(subst -, ,$@))

#------------------------------------------------------------------------------#
.DEFAULT_GOAL:= help

.PHONY:help
help::
	@echo "BUILD TARGETS"
	@echo "--------------------------------------------------------------------"
	@echo "Override the default tag by setting the 'TAG' variable."
	@echo "$(CMD_TARGETS)" | tr ' ' '\n' | awk '{print "  "$$0}'
	@echo
	@echo "USAGE NOTES"
	@echo "--------------------------------------------------------------------"
	@echo "- Override the default tab by setting the 'TAG' variable."
