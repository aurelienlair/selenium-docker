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

export PIPENV_VENV_IN_PROJECT=true

help:
	@echo "❓ helps section"
	@grep -E '^[a-zA-Z_-]+.*?## .*$$' Makefile | sed 's/:.*##/##/' | sort | awk 'BEGIN {FS = "## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Common build arguments
BUILD_ARGS = \
	--progress=plain \
	--tag selenium-firefox-standalone \
	--build-arg SELENIUM_IMAGE_TAG=$(SELENIUM_IMAGE_TAG) \
	--build-arg GITLAB_TOKEN=$(GITLAB_PERSONAL_ACCESS_TOKEN) \
	--build-arg PRIVATE_PYTHON_MODULES_GROUP=$(PRIVATE_PYTHON_MODULES_GROUP) \
	--build-arg PYTHON_VERSION=$(PYTHON_VERSION)

# Common run tests options
RUN_TESTS_OPTIONS = \
	--rm \
	--platform linux/amd64 \
	selenium-firefox-standalone pytest -s -v tests

.PHONY: build bash echo-requirements firefox-version

build: ## 🛠️      Build docker image using default Dockerfile
	@echo "🔨 Building docker image using default Dockerfile"
	docker build $(BUILD_ARGS) -f $(DOCKERFILE) .

bash: ## 💻     Bash
	@echo "🐚 Running Bash"
	docker run --interactive --tty --rm selenium-firefox-standalone bash 

echo-requirements: ## 🔍     Echo requirements
	@echo "🔎 Echoing requirements"
	docker run --rm selenium-firefox-standalone bash -c 'cat /app/requirements.txt' 

create-virtual-env: ## 🛠️        Create Python virtual environment
	@echo "🌐 installing python virtual environment"
	python3 -m venv .venv

activate-virtual-env: ## 🔌      Activate Python virtual environment
	@echo "🔌 activating python virtual environment"
	. .venv/bin/activate

remove-virtual-env: ## 🗑️      Remove Python virtual environment
	@echo "🧹️ Activating the Python virtual environment"
	rm -rf .venv/

install-dependencies: ## 🔌       Install Python dependencies
	@echo "🧹️ Installing Python dependencies"
	pip install --no-cache-dir --extra-index-url=$(PRIVATE_PYTHON_MODULES_GROUP) -r requirements.txt

firefox-version: ## 🏃     Echo Firefox version 
	@echo "🦊 Echoing Firefox version"
	docker run --rm selenium-firefox-standalone bash -c 'firefox --version'

# Additional build targets
build-selenium-intel-venv: ## 🛠️      Build docker image for build-selenium-intel-venv
	@echo "🔨 Building docker image for build-selenium-intel-venv"
	$(MAKE) build DOCKERFILE=$(DOCKERFILE).selenium.intel.venv SELENIUM_IMAGE_TAG=116.0

build-selenium-intel: ## 🛠️      Build docker image for build-selenium-intel 
	@echo "🔨 Building docker image for build-selenium-intel"
	$(MAKE) build DOCKERFILE=$(DOCKERFILE).selenium.intel

build-selenium-arm-venv: ## 🛠️      Build docker image for build-selenium-arm-venv
	@echo "🔨 Building docker image for build-selenium-arm-venv"
	$(MAKE) build DOCKERFILE=$(DOCKERFILE).selenium.arm.venv

build-selenium-arm: ## 🛠️      Build docker image for build-selenium-arm
	@echo "🔨 Building docker image for build-selenium-arm"
	$(MAKE) build DOCKERFILE=$(DOCKERFILE).selenium.arm

build-selenium-intel-python3.10: ## 🛠️     Build docker image for build-selenium-intel-python3.10
	@echo "🔨 Building docker image for build-selenium-intel-python3.10"
	$(MAKE) build DOCKERFILE=$(DOCKERFILE).selenium.intel.python3.10 PYTHON_VERSION=3.10

run-tests-locally: ## ✅🧪   Running tests on Firefox locally 
	@echo "✅🧪 Running tests on Firefox locally"
	pytest -s -v tests

run-tests-intel: ## ✅🧪   Running tests on Firefox on Intel platform
	@echo "✅🧪 Running tests on Firefox on Intel platform"
	docker run $(RUN_TESTS_OPTIONS)

run-tests-arm: ## ✅🧪   Running tests on Firefox on ARM platform
	@echo "✅🧪 Running tests on Firefox on ARM platform"
	docker run --rm --platform linux/arm64 $(RUN_TESTS_OPTIONS)
