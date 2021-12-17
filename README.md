<!-- omit in toc -->
# Shellib

![GitHub top language](https://img.shields.io/github/languages/top/xebis/shellib)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

![GitHub](https://img.shields.io/github/license/xebis/shellib)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/xebis/shellib)
![GitHub issues](https://img.shields.io/github/issues/xebis/shellib)
![GitHub last commit](https://img.shields.io/github/last-commit/xebis/shellib)
[![pipeline status](https://gitlab.com/xebis/shellib/badges/main/pipeline.svg?ignore_skipped=true)](https://gitlab.com/xebis/shellib/-/commits/main)

Simple Bash scripting library.

The goal of the library is to have a small yet useful set of functions. It is **not** intended to obscure or replace Bash idioms.

**The project is under active development.**

<!-- omit in toc -->
## Table of Contents

- [Features](#features)
- [Installation and Configuration](#installation-and-configuration)
- [Usage](#usage)
- [Contributing](#contributing)
  - [Testing](#testing)
    - [Test at Docker Container](#test-at-docker-container)
  - [Packaging](#packaging)
- [To-Do list](#to-do-list)
- [Roadmap](#roadmap)
- [Credits and Acknowledgments](#credits-and-acknowledgments)
- [Copyright and Licensing](#copyright-and-licensing)
- [Changelog and News](#changelog-and-news)
- [Notes and References](#notes-and-references)
  - [Dependencies](#dependencies)
  - [Recommendations](#recommendations)
  - [Further Reading](#further-reading)

## Features

- `get_version`: Outputs Shellib version to stdout

## Installation and Configuration

```bash
shellib_latest_deb_url=$(curl https://gitlab.com/api/v4/projects/26143455/releases | jq --raw-output '.[0].assets.links | .[0].direct_asset_url') # Get the latest deb package URL
shellib_downloaded_deb_file=$(mktemp --suffix='deb') # Set the package download destination
curl "$shellib_latest_deb_url" -o "$shellib_downloaded_deb_file" # Download the latest deb package
sudo dpkg -i "$shellib_downloaded_deb_file" # Install the package
rm "$shellib_downloaded_deb_file" # Clean up after yourself
```

## Usage

Recommended, but not necessary:

```bash
#!/usr/bin/env bash

# Use Bash Strict Mode, see http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Set safe basic locale
LANG=C
```

Source the library:

```bash
. /usr/lib/shellib.sh
```

Use library functions:

```bash
out 'Hello world!' '😀'
# Result is similar to:
# your/script 😀 Hello world!
```

## Contributing

Please read [CONTRIBUTING](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting merge requests to us.

### Testing

- Git hooks check a lot of things for you, including running automated tests `scripts/test full`
- Stuff inherited from [repository-template](https://github.com/xebis/repository-template) should be tested there.
- Make sure all _non-inherited_ `scripts/*` work as expected, testing checklist:

- `scripts/*` scripts
  - [ ] [`scripts/build`](scripts/build)
  - [ ] [`scripts/pack`](scripts/pack)
  - [ ] [`scripts/set-ver`](scripts/set-ver) - covered by unit tests
- GitLab CI
  - [ ] Built DEB package, see [Installation And Configuration](#installation-and-configuration)

#### Test at Docker Container

To test your changes in a different environment, you might try to run a Docker container and test it from there.

Run the container:

```bash
sudo docker run -it --rm -v "$(pwd)":/repository-template alpine:latest # Create disposal docker container
```

In the container:

```bash
cd repository-template
# Set variables GL_TOKEN and GH_TOKEN when needed
# Put here commands from .gitlab-ci.yml job:before_script and job:script
# For example job test-full:
apk -U upgrade
apk add bats
bats tests
# Result is similar to:
# 1..1
# ok 1 dummy test
```

### Packaging

Build, and pack:

```bash
ver_next='1.5.25-alpha'
scripts/set-ver "$ver_next" # Set version at source codes
# ... Do not forget to commit the change
scripts/build # Create build at ./build
scripts/pack "$ver_next" # Create package at ./build
```

## To-Do list

- [ ] Fix workaround for pre-commit `jumanjihouse/pre-commit-hooks` hook `script-must-have-extension` - `*.bats` shouldn't be excluded

## Roadmap

- [ ] Find a satisfactory way how to manage (list, install, update) dependencies across various distributions and package managers
- [ ] Add [pre-commit meta hooks](https://pre-commit.com/#meta-hooks)
- [ ] Speed up CI/CD by preparing a set of Docker images with pre-installed dependencies for each CI/CD stage, or by cache for `apk`, `pip`, and `npm`

## Credits and Acknowledgments

- [Martin Bružina](https://bruzina.cz/) - Author

## Copyright and Licensing

- [MIT License](LICENSE)
- Copyright © 2021 Martin Bružina

## Changelog and News

- [Changelog](CHANGELOG.md)

## Notes and References

### Dependencies

- [GitHub - xebis/repository-template: Well-manageable and well-maintainable repository template.](https://github.com/xebis/repository-template) - a lot of stuff is inherited from there, including **git hooks**, **GitLab CI**, scripts, or **Visual Studio Code** suggested extensions
- [GitHub - mvdan/sh: A shell parser, formatter, and interpreter with bash support; includes shfmt](https://github.com/mvdan/sh)
- [GitHub - koalaman/shellcheck: ShellCheck, a static analysis tool for shell scripts](https://github.com/koalaman/shellcheck)
- [GitHub - bats-core/bats-core: Bash Automated Testing System](https://github.com/bats-core/bats-core)
  - [GitHub - bats-core/bats-support: Supporting library for Bats test helpers](https://github.com/bats-core/bats-support)
  - [GitHub - bats-core/bats-assert: Common assertions for Bats](https://github.com/bats-core/bats-assert)
  - [GitHub - bats-core/bats-file: Common filesystem assertions for Bats](https://github.com/bats-core/bats-file)

### Recommendations

- [aaron maxwell: Use Bash Strict Mode (Unless You Love Debugging)](http://redsymbol.net/articles/unofficial-bash-strict-mode/)

### Further Reading

- [GNU Bash: Bash Reference Manual](https://www.gnu.org/software/bash/manual/html_node/index.html)
- [The Debian GNU/Linux FAQ: Chapter 7. Basics of the Debian package management system](https://www.debian.org/doc/manuals/debian-faq/pkg-basics.en.html)
