# Selenium tests using Python and Firefox within various Docker image environments

The objective of this project is to offer a practical learning opportunity for conducting automated browser tests using Selenium in Python, spanning multiple Docker images. This facilitates the ability to construct and execute identical tests through diverse Docker images featuring distinct configurations.

Within this repository, you'll encounter comprehensive guidelines, code excerpts, and setups for constructing and executing automated browser tests using a variety of Docker containers.

## Table of Contents

1. [Pre-requirements](#pre-requirements)
2. [Installation](#installation)
3. [Running Google Search](#running-google-search)

## Pre-requirements

To get started with this project, you'll need to install the following tools:

- [Python](https://www.python.org/): Python is a programming language used for writing test scripts and managing dependencies.
- [Pyenv](https://github.com/pyenv/pyenv): Pyenv is a tool that allows you to install and manage multiple versions of Python on your system.
- [Docker](https://www.docker.com/): Docker is a platform that allows you to develop, ship, and run applications inside containers, ensuring consistent environments across different machines.
- [Visual Studio Code](https://code.visualstudio.com/): Visual Studio Code is a lightweight and powerful code editor with great support for Python development and a wide range of extensions.
- [Git](https://git-scm.com/): Git is a version control system used for tracking changes in your code and collaborating with others.

Please follow the links provided for each tool to access the respective installation instructions for your specific operating system. Once you have these tools installed, you'll be ready to proceed with the experimentation project.

## Prerequisites

Before you start setting up the project, make sure you have the following environment variables set:

* `GITLAB_PERSONAL_ACCESS_TOKEN`: Your GitLab private token for authentication.
* `PRIVATE_PYTHON_MODULES_GROUP_HOST`: The host of the private Python libraries in GitLab, e.g., if your host is `https://PRIVATE_HOST/api/v4/groups/GROUP_ID/-/packages/pypi/simple`, you need to set an environment variable with `PRIVATE_HOST/api/v4/groups/GROUP_ID/-/packages/pypi/simple`.

## Installation

This chapter guides you through the installation process, ensuring that you have all the necessary tools and dependencies to run the project.

### Set Up a virtual environment

Guidance on establishing and forming a virtual environment within the project directory using the native [venv](https://docs.python.org/3/library/venv.html) module.

```bash
make create-virtual-env
```

And for activating the virtual environment

```bash
make activate-virtual-env
```

If necessary, you can still uninstall it by executing

```bash
make remove-virtual-env
```

Set up Python requirements

```bash
make install-dependencies
```

## Running Google Search with Firefox

This chapter provides instructions on running the Google search tests using [Firefox](https://www.mozilla.org/en-US/firefox/new/).

### Within your local environment

```bash
make run-tests-locally
```

### Inside a Docker Container 🐳

Select the image type you wish to create using the helper tool 👷‍♂️

```bash
make help | grep build

build                           🛠️  Build docker image using default Dockerfile
build-selenium-arm              🛠️  Build docker image for build-selenium-arm
build-selenium-arm-venv         🛠️  Build docker image for build-selenium-arm-venv
build-selenium-intel            🛠️  Build docker image for build-selenium-intel 
build-selenium-intel-python3.10 🛠️  Build docker image for build-selenium-intel-python3.10
build-selenium-intel-venv       🛠️  Build docker image for build-selenium-intel-venv
```

Execute the command, specifying your intention to construct and launch a Docker image based on [Intel](https://en.wikipedia.org/wiki/X86-64) architecture 🏗️🐳.

```bash
make build-selenium-intel 
```

Then simply initiate the tests 🚀

```bash
make run-tests-intel
```

You can achieve the same by building and running a Docker image based on the [ARM64](https://en.wikipedia.org/wiki/AArch64) architecture, as demonstrated below:

```bash
make build-selenium-arm
make run-tests-arm
```
