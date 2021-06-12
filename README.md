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

**The project is under active development.**

<!-- omit in toc -->
## Table of Contents

- [Installation and Configuration](#installation-and-configuration)
- [Usage](#usage)
- [Contributing](#contributing)
  - [Testing](#testing)
  - [Packaging](#packaging)
- [Credits and Acknowledgments](#credits-and-acknowledgments)
- [Copyright and Licensing](#copyright-and-licensing)
- [Changelog and News](#changelog-and-news)
- [Notes and References](#notes-and-references)
  - [Dependencies](#dependencies)
  - [Further Reading](#further-reading)

## Installation and Configuration

```bash
SHELLIB_LATEST_DEB_URL=$(curl https://gitlab.com/api/v4/projects/26143455/releases | jq --raw-output '.[0].assets.links | .[0].direct_asset_url') # Get the latest deb package URL
SHELLIB_LATEST_DEB_FILE="/tmp/shellib_latest_all.deb" # Set the package destination
curl "$SHELLIB_LATEST_DEB_URL" -o "$SHELLIB_LATEST_DEB_FILE" # Download the latest deb package
sudo dpkg -i "$SHELLIB_LATEST_DEB_FILE" # Install the package
rm "$SHELLIB_LATEST_DEB_FILE" # Clean up after yourself
```

## Usage

```bash
. /usr/lib/shellib.sh
```

## Contributing

Please read [CONTRIBUTING](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting merge requests to us.

### Testing

Run tests:

```bash
tools/test
```

### Packaging

Build, and pack:

```bash
tools/set-ver "1.5.25-rc0" # Set version at source codes
# ... Do not forget to git add, commit, push, ... to make it persistent
tools/build # Create build at ./build
tools/pack "1.5.25" # Create package at at ./build
```

## Credits and Acknowledgments

- [Martin Bružina](https://bruzina.cz/) - Author

## Copyright and Licensing

- [MIT License](LICENSE)
- Copyright © 2021 Martin Bružina

## Changelog and News

- [Changelog](CHANGELOG.md)

## Notes and References

### Dependencies

- [GitHub - mvdan/sh: A shell parser, formatter, and interpreter with bash support; includes shfmt](https://github.com/mvdan/sh)
- [GitHub - koalaman/shellcheck: ShellCheck, a static analysis tool for shell scripts](https://github.com/koalaman/shellcheck)
- [GitHub - kward/shunit2: shUnit2 is a xUnit based unit test framework for Bourne based shell scripts.](https://github.com/kward/shunit2)
- [GitHub - xebis/repository-template: Well-manageable and well-maintainable repository template.](https://github.com/xebis/repository-template) - contains `pre-commit`, `semantic-release`, and `Visual Studio Code` suggested extensions

### Further Reading

- [GNU Bash: Bash Reference Manual](https://www.gnu.org/software/bash/manual/html_node/index.html)
- [The Debian GNU/Linux FAQ: Chapter 7. Basics of the Debian package management system](https://www.debian.org/doc/manuals/debian-faq/pkg-basics.en.html)
