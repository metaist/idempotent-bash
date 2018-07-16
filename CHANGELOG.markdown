# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog] and this project adheres to [Semantic Versioning].

[Keep a Changelog]: http://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: http://semver.org/spec/v2.0.0.html

---
[#32]: https://github.com/metaist/idempotent-bash/issues/32
[#33]: https://github.com/metaist/idempotent-bash/issues/33
[#34]: https://github.com/metaist/idempotent-bash/issues/34
[#37]: https://github.com/metaist/idempotent-bash/issues/37
[Unreleased]: https://github.com/metaist/idempotent-bash/compare/1.1.2...HEAD
## [Unreleased]
**Added**
- [#32]: `ib-quiet` to suppress output
- [#34]: `ib-in?` to check if item is in array

**Changed**
- [#33]: `ib-os-append` uses the first line of a multiline text to pass to `grep`
- [#37]: changelog to follow [Keep a Changelog] format

---
[#19]: https://github.com/metaist/idempotent-bash/issues/19
[#20]: https://github.com/metaist/idempotent-bash/issues/20
[#21]: https://github.com/metaist/idempotent-bash/issues/21
[#22]: https://github.com/metaist/idempotent-bash/issues/22
[#23]: https://github.com/metaist/idempotent-bash/issues/23
[#24]: https://github.com/metaist/idempotent-bash/issues/24
[#25]: https://github.com/metaist/idempotent-bash/issues/25
[#26]: https://github.com/metaist/idempotent-bash/issues/26
[#27]: https://github.com/metaist/idempotent-bash/issues/27
[#28]: https://github.com/metaist/idempotent-bash/issues/28
[#29]: https://github.com/metaist/idempotent-bash/issues/29
[#30]: https://github.com/metaist/idempotent-bash/issues/30
[#31]: https://github.com/metaist/idempotent-bash/issues/31
[1.1.2]: https://github.com/metaist/duil.js/compare/1.1.1...1.1.2
## [1.1.2] - 2017-07-27
**Added**
- [#24]: [git] functions to manage repositories
- [#25]: `ib-postgresql-sql` to conditionally execute a single command
- [#28]: examples
- [#29]: `--user` flag to handle different user

**Changed**
- [#26]: requirement that scripts run as `sudo` (see also [#29])

**Fixed**
- [#19]: tests on Cygwin
- [#20]: extra whitespace in `ib-pip-install` output
- [#21]: documentation for `ib-postgresql-file`
- [#22]: `ib-os-link` to prevent recursive removal of incorrect links
- [#23]: package iteration in `ib-apt-install` and `ib-apt-cyg-install`
- [#27]: dry run indicator when using global `IB_DRY_RUN`
- [#30]: `ib-postgresql-ok?` to return boolean
- [#31]: character escaping in `ib-os-append`

[git]: https://git-scm.com/

---
[#12]: https://github.com/metaist/idempotent-bash/issues/12
[#13]: https://github.com/metaist/idempotent-bash/issues/13
[#14]: https://github.com/metaist/idempotent-bash/issues/14
[#15]: https://github.com/metaist/idempotent-bash/issues/15
[#16]: https://github.com/metaist/idempotent-bash/issues/16
[#17]: https://github.com/metaist/idempotent-bash/issues/17
[#18]: https://github.com/metaist/idempotent-bash/issues/18
[1.1.1]: https://github.com/metaist/duil.js/compare/1.1.0...1.1.1
## [1.1.1] - 2016-04-17
**Added**
- [#12]: documentation to public-facing functions
- [#13]: `ib-os-copy-link` to toggle copying or linking directories
- [#14]: `ib-parse-args` to parse label and quiet args
- [#15]: dry run options (global and per-action)
- [#18]: multiple line blocks with `ib-os-append`

**Fixed**
- [#16]: unbound variable in `ib-pip-install`
- [#17]: using grep with PCRE

---
[#5]: https://github.com/metaist/idempotent-bash/issues/5
[#7]: https://github.com/metaist/idempotent-bash/issues/7
[#9]: https://github.com/metaist/idempotent-bash/issues/9
[#10]: https://github.com/metaist/idempotent-bash/issues/10
[#11]: https://github.com/metaist/idempotent-bash/issues/11
[1.1.0]: https://github.com/metaist/duil.js/compare/1.0.0...1.1.0
## [1.1.0] - 2016-03-31
**Added**
- [#5]: basic functions for installing and starting/stopping services
- [#7]: [apt-cyg] functions to install [Cygwin] packages
- [#9]: quick start to README
- [#11]: `ib-command?` to check if a command exists

**Fixed**
- [#10]: stat of `apt-get` package cache if missing

[apt-cyg]: https://github.com/transcode-open/apt-cyg
[Cygwin]: https://cygwin.com

---
[#1]: https://github.com/metaist/idempotent-bash/issues/1
[#2]: https://github.com/metaist/idempotent-bash/issues/2
[#3]: https://github.com/metaist/idempotent-bash/issues/3
[#4]: https://github.com/metaist/idempotent-bash/issues/4
[#6]: https://github.com/metaist/idempotent-bash/issues/6
[#8]: https://github.com/metaist/idempotent-bash/issues/8
[1.0.0]: https://github.com/metaist/idempotent-bash/tree/1.0.0
## [1.0.0] - 2016-03-28
- Initial release.

**Added**
- [#1]: base action, testing functions
- [#2]: basic OS functions to create directories, check/change permissions
- [#3]: basic [Apt] functions to install Linux packages
- [#4]: basic [pip] functions to install python packages
- [#6]: [jinja2-cli] functions to generate configuration files
- [#8]: [PostgreSQL] functions to execute SQL files

[Apt]: https://wiki.debian.org/Apt
[pip]: https://pip.pypa.io/en/stable/
[PostgreSQL]: http://www.postgresql.org/
[jinja2-cli]: https://github.com/mattrobenolt/jinja2-cli
