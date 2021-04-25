# Shellib

![GitHub top language](https://img.shields.io/github/languages/top/xebis/shellib)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

![GitHub](https://img.shields.io/github/license/xebis/shellib)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/xebis/shellib)
![GitHub issues](https://img.shields.io/github/issues/xebis/shellib)
![GitHub last commit](https://img.shields.io/github/last-commit/xebis/shellib)

Simple Bash scripting library.

## Usage

```bash
. path/to/shellib.sh
```

## Development

Run tests:

```bash
tools/test
```

Build, and pack:

```bash
tools/set-ver "1.5.25-rc0" # Set version at source codes
# ... Do not forget to git add, commit, push, ... to make it persistent
tools/build # Create build at ./build
tools/pack "1.5.25" # Create package at at ./build
```

## Authors

[Martin Bružina](https://bruzina.cz/)

## License

[MIT License](LICENSE)

## Dependencies

- [GitHub - mvdan/sh: A shell parser, formatter, and interpreter with bash support; includes shfmt](https://github.com/mvdan/sh)
- [GitHub - koalaman/shellcheck: ShellCheck, a static analysis tool for shell scripts](https://github.com/koalaman/shellcheck)
- [GitHub - kward/shunit2: shUnit2 is a xUnit based unit test framework for Bourne based shell scripts.](https://github.com/kward/shunit2)
- [GitHub - xebis/repository-template: Well-manageable and well-maintainable repository template.](https://github.com/xebis/repository-template)

## See Also

- [GNU Bash: Bash Reference Manual](https://www.gnu.org/software/bash/manual/html_node/index.html)
- [The Debian GNU/Linux FAQ: Chapter 7. Basics of the Debian package management system](https://www.debian.org/doc/manuals/debian-faq/pkg-basics.en.html)
