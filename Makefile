.DEFAULT_GOAL := help
CUR_DIR := $(shell pwd)
SHELL := /bin/bash

# Configuration
DOCKERFILE ?= Dockerfile
SELENIUM_IMAGE_TAG ?= latest
GITLAB_PERSONAL_ACCESS_TOKEN ?= $(error GITLAB_PERSONAL_ACCESS_TOKEN is not set)
PRIVATE_PYTHON_MODULES_GROUP_HOST ?= $(error PRIVATE_PYTHON_MODULES_GROUP_HOST is not set)
PRIVATE_PYTHON_MODULES_GROUP = https://__token__:$(GITLAB_PERSONAL_ACCESS_TOKEN)@$(PRIVATE_PYTHON_MODULES_GROUP_HOST)
PYTHON_VERSION ?= 3.11
IMAGE_TAG_NAME = selenium-firefox-python

export PIPENV_VENV_IN_PROJECT=true

help:
	@echo "❓ helps section"
	@grep -E '^[a-zA-Z_-]+.*?## .*$$' Makefile | sed 's/:.*##/##/' | sort | awk 'BEGIN {FS = "## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Common build arguments
COMMON_BUILD_ARGS = \
	--progress=plain \
	--tag $(IMAGE_TAG_NAME) \
	--build-arg SELENIUM_IMAGE_TAG=$(SELENIUM_IMAGE_TAG) \
	--build-arg PRIVATE_PYTHON_MODULES_GROUP=$(PRIVATE_PYTHON_MODULES_GROUP) \

# Common run tests options
RUN_TESTS_OPTIONS = \
	-it \
	--rm \
	$(IMAGE_TAG_NAME)

.PHONY: bash echo-requirements firefox-version

define build_platform_target
build-$(1):	##  🛠️      Build docker image (eg. make build-debian-intel, build-selenium-intel-venv, make build-selenium-intel, make build-selenium-arm-venv, make build-selenium-arm)
	@echo "🔨 Building docker image for `$(1)` using file `$(2)` for platform `$(3)`"
	docker build \
		$(COMMON_BUILD_ARGS) \
		--build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
		--file $(2) \
		--platform $(3) \
		.
endef

# Call the build_platform_target function for each platform
$(eval $(call build_platform_target,debian-intel,Dockerfile.intel,linux/amd64))
$(eval $(call build_platform_target,selenium-intel-venv,Dockerfile.selenium.intel.venv,linux/amd64))
$(eval $(call build_platform_target,selenium-intel,Dockerfile.selenium.intel,linux/amd64))
$(eval $(call build_platform_target,selenium-arm-venv,Dockerfile.selenium.arm.venv,linux/arm64))
$(eval $(call build_platform_target,selenium-arm,Dockerfile.selenium.arm,linux/arm64))


build-selenium-intel-python3.10: ## 🛠️      Build docker image for build-selenium-intel-python3.10
	@echo "🔨 Building docker image for build-selenium-intel-python3.10"
	docker build \
		$(COMMON_BUILD_ARGS) \
		--build-arg PYTHON_VERSION=3.10 \
		--file Dockerfile.selenium.intel.python3.10 \
		--platform linux/amd64 \
		.

run-tests-locally: ##  ✅🧪   Running tests on Firefox locally 
	@echo "✅🧪 Running tests on Firefox"
	pytest -s -v tests

run-tests: ##  ✅🧪   Running tests on Firefox
	@echo "✅🧪 Running tests on Firefox "
	docker run $(RUN_TESTS_OPTIONS)

run-tests-with-entrypoint: ##  ✅🧪   Running tests on Firefox by specifying the entrypoint
	@echo "✅🧪 Running tests on Firefox "
	docker run $(RUN_TESTS_OPTIONS) python3 -m pytest tests