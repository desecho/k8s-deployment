.DEFAULT_GOAL := help

include help.mk

#------------------------------------
# Installation
#------------------------------------
BIN_DIR := /usr/local/bin

SHFMT_VERSION := 3.4.3
SHFMT_PATH := ${BIN_DIR}/shfmt

.PHONY: install-shfmt
## Install shfmt | Installation
install-shfmt:
	sudo curl https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_linux_amd64 -Lo ${SHFMT_PATH}
	sudo chmod +x ${SHFMT_PATH}
#------------------------------------

#------------------------------------
# Commands
#------------------------------------
.PHONY: lint
## Run linters | Commands
lint:
	shfmt -l -d .
	shellcheck scripts/*.sh
	markdownlint README.md
	yamllint .github cert-manager mysql nginx-ingress redis

.PHONY: format
## Format files
format:
	shfmt -l -w .
	markdownlint README.md --fix
