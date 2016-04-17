# 1.1.1 (2016-04-17)
- #12: add documentation to public-facing functions
- #13: add `ib-os-copy-link` to toggle copying or linking directories
- #14: add `ib-parse-args` to parse label and quiet args
- #15: add dry run options (global and per-action)
- #16: fix unbound variable in `ib-pip-install`
- #17: fix using grep with PCRE
- #18: add multiple line blocks with `ib-os-append`

# 1.1.0 (2016-03-31)
- #5: add basic functions for installing and starting/stopping services
- #7: add [apt-cyg] functions to install [Cygwin] packages
- #9: add quick start to README 
- #10: fix stat of `apt-get` package cache if missing
- #11: add `ib-command?` to check if a command exists

[apt-cyg]: https://github.com/transcode-open/apt-cyg
[Cygwin]: https://cygwin.com

# 1.0.0 (2016-03-28)
- #1: add base action, testing functions
- #2: add basic OS functions to create directories, check/change permissions
- #3: add basic [Apt] functions to install Linux packages
- #4: add basic [pip] functions to install python packages
- #6: add [jinja2-cli] functions to generate configuration files
- #8: add [PostgreSQL] functions to execute SQL files

[Apt]: https://wiki.debian.org/Apt
[pip]: https://pip.pypa.io/en/stable/
[PostgreSQL]:http://www.postgresql.org/ 
[jinja2-cli]: https://github.com/mattrobenolt/jinja2-cli
