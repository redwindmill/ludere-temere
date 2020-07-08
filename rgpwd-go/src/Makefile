TARGET_OS?= linux
TARGET_PLATFORM?= amd64
OUTPUT_NAME?= output
OUTPUT_OPTS?=
MODULE_NAME?= module-unknown
DIR_BIN?= $(CURDIR)/bin

GO_FMT_TARGETS:= $(patsubst %, %.go_fmt, \
	$(shell find . -type f -name "*.go" | grep -iv '/vendor/') \
)

#------------------------------------------------------------------------------#

OUTPUT_DIR:= $(DIR_BIN)/$(TARGET_OS)_$(TARGET_PLATFORM)
ifeq ($(TARGET_OS),windows)
	OUTPUT_FILE:= $(OUTPUT_DIR)/$(OUTPUT_NAME).exe
else
	OUTPUT_FILE:= $(OUTPUT_DIR)/$(OUTPUT_NAME)
endif

# PROJECT BUILD
#------------------------------------------------------------------------------#

.PHONY: build
build: go-version
	@env GOOS=$(TARGET_OS) GOARCH=$(TARGET_PLATFORM) \
		go build --mod=vendor -v -o $(OUTPUT_FILE)

.PHONY: build-race
build-race: go-version
	@env GOOS=$(TARGET_OS) GOARCH=$(TARGET_PLATFORM) \
		go build --race --mod=vendor -v -o $(OUTPUT_FILE).race

.PHONY: build-msan
build-msan: go-version
	@env GOOS=$(TARGET_OS) GOARCH=$(TARGET_PLATFORM) \
	CC=clang \
		go build --msan --mod=vendor -v -o $(OUTPUT_FILE).race

.PHONY: run
run:
	@go run --mod=vendor -v ./

# PROJECT VERIFICATION
#------------------------------------------------------------------------------#

.PHONY: audit-vet
audit-vet:
	@go vet ./...

.PHONY: audit-test
audit-test:
	@go test ./...

.PHONY: audit-race
audit-test-race:
	@go test --race ./...

.PHONY: audit-msan
audit-test-msan:
	@CC=clang \
		go test --msan ./...

.PHONY: audit-escape
audit-escape:
	go build -gcflags '-m' .

.PHONY: audit-bench
audit-profile:
	@mkdir -vp $(OUTPUT_DIR)
	@go test \
		-cpuprofile $(OUTPUT_DIR)/cpu.prof \
		-memprofile $(OUTPUT_DIR)/mem.prof \
		 -bench \
		 -o -o $(OUTPUT_FILE).profile

# UTILITIES
#------------------------------------------------------------------------------#

.PHONY: go-fmt
go-fmt: $(GO_FMT_TARGETS)

.PHONY: $(GO_FMT_TARGETS)
$(GO_FMT_TARGETS):
	@go fmt $(basename $@)

.PHONY: go-init
go-init:
	@go mod init $(MODULE_NAME)

.PHONY: go-vendor
go-vendor:
	@go mod tidy
	@go mod vendor
	@go mod edit --go=$(GOLANG_VERSION)

.PHONY: go-version
go-version:
	@go version

# HELP
#------------------------------------------------------------------------------#
.DEFAULT_GOAL:=help

.PHONY: help-env
help-env:
	@echo "[ENVIRONMENT GOLANG]"
	@go env
	@echo
	@echo "[ENVIRONMENT SHELL]"
	@printenv
	@ls -al /usr/local/go

.PHONY: help
help:
	@echo "[BUILD OPTIONS]"
	@echo "    run        : build and the target executable."
	@echo "    build      : build the target executable."
	@echo "    build-race : build the target executable with race detection."
	@echo "    build-msan : build the target executable with the memory sanitizer."
	@echo "                 TARGET_OS='$(TARGET_OS)' (linux/darwin/windows)"
	@echo "                 TARGET_PLATFORM='$(TARGET_PLATFORM)' (amd64/arm)"
	@echo "                 OUTPUT_NAME='$(OUTPUT_NAME)' name for executable."
	@echo
	@echo "[UTIL OPTIONS]"
	@echo "    audit-vet       : runs go vet on the source code."
	@echo "    audit-test      : runs go test on the source code."
	@echo "    audit-test-race : runs go test with race on the source code."
	@echo "    audit-test-msan : runs go test with msan on the source code."
	@echo
	@echo "    go-fmt     : runs go format on non vendor source code."
	@echo "    go-init    : initializes the go project."
	@echo "                 MODULE_NAME='$(MODULE_NAME)' name for module"
	@echo "    go-vendor  : tidies and vendors external dependencies."
	@echo "    help-env   : dump the go and shell environment."
