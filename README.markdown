# idempotent-bash
_Idempotent [Bash] setup scripts made easy._

## Quick Start
Create a file called `setup.sh`:

```bash
#!/usr/bin/env bash
set -uo pipefail
IFS=$'\n\t'

source "idempotent-bash.sh"

# Set the log file path so you can follow along.
IB_LOG="/tmp/${BASH_SOURCE[0]}.log"

# Most setup scripts require root.
if [[ $EUID != 0 ]]; then
    echo "Re-run this script with root privileges."
    exit 1
fi

setup_pip() {
  printf "\n=== Pip ===\n"
  local label="[python] install pip"
  local skip=$(command -v pip)
  local url="https://bootstrap.pypa.io/get-pip.py"
  ib-action -l "$label" -s "$skip" -- wget --quiet -O - $url \| sudo python

  ib pip-install pyyaml jinja2-cli
}

setup_pip
```

If you run `./setup.sh` it will ensure that `pip`, `pyyaml`, and `jinja2-cli` are installed.

## What does idempotent mean?
It means that applying the same function multiple times is the same as applying it once. In other words, don't run code if the effect of the code is already present.

For setup scripts, this means that when you re-run your setup script, it only runs the commands that whose conditions are not yet satisfied thereby saving time on potentially long-running actions.

## What about other projects?
This project was inspired by [Ansible] and [Bash Booster]. I liked the idea of idempotent setup scripts, but I needed more reporting of status to log files so I can debug particularly tricky environments.

I haven't used [Puppet] or [Chef], but those seem popular right now.

## License
Licensed under the MIT License.

[Ansible]: https://www.ansible.com/
[Bash Booster]: http://www.bashbooster.net/
[Bash]: https://www.gnu.org/software/bash/
[Chef]: https://www.chef.io/chef/
[Puppet]: https://puppetlabs.com/
