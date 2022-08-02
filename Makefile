.DEFAULT_GOAL := help

include makefiles/colors.mk
include makefiles/help.mk
include makefiles/macros.mk

#------------------------------------
# Installation
#------------------------------------
BIN_DIR := /usr/local/bin

SHFMT_VERSION := 3.4.3
SHFMT_PATH    := ${BIN_DIR}/shfmt

.PHONY: install-shfmt
install-shfmt:
	$(call print,Installing shfmt)
	@sudo curl https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_linux_amd64 -Lo ${SHFMT_PATH}
	@sudo chmod +x ${SHFMT_PATH}

ACTIONLINT_VERSION := 1.6.13
ACTIONLINT_PATH    := ${BIN_DIR}/actionlint
ACTIONLINT_URL     := https://github.com/rhysd/actionlint/releases/download/v${ACTIONLINT_VERSION}/actionlint_${ACTIONLINT_VERSION}_linux_amd64.tar.gz
ACTIONLINT_TMP_DIR := $(shell mktemp -d)
ACTIONLINT_ARCHIVE := actionlint.tar.gz

.PHONY: install-actionlint
install-actionlint:
	$(call print,Installing actionlint)
	@cd ${ACTIONLINT_TMP_DIR} && \
	curl ${ACTIONLINT_URL} -Lo ${ACTIONLINT_ARCHIVE} && \
	tar -xvf ${ACTIONLINT_ARCHIVE} && \
	sudo mv actionlint ${ACTIONLINT_PATH}

.PHONY: install-linters-binaries
## Install linters binaries | Installation
install-linters-binaries: install-shfmt install-actionlint
#------------------------------------

#------------------------------------
# Commands
#------------------------------------
.PHONY: lint
## Run linters | Commands
lint:
	$(call print,Linting)
	@shfmt -l -d .
	@shellcheck scripts/*.sh
	@markdownlint README.md
	@prettier --check ./.github/**/*.yaml ./**/*.yaml
	@actionlint

.PHONY: format
## Format files
format:
	$(call print,Formatting)
	@shfmt -l -w .
	@markdownlint README.md --fix
	@prettier --write ./.github/**/*.yaml ./**/*.yaml
#------------------------------------
