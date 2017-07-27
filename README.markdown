# idempotent-bash
_Idempotent [Bash] setup scripts made easy._

## Examples
See the [Example directory](./examples).

## What does idempotent mean?
It means that applying the same function multiple times is the same as applying it once. In other words, don't run code if the effect of the code is already present.

For setup scripts, this means that when you re-run your setup script, it only runs the commands that whose conditions are not yet satisfied thereby saving time on potentially long-running actions.

## What about other projects?
This project was inspired by [Ansible] and [Bash Booster]. I like the idea of idempotent setup scripts, but I needed more reporting of status to log files so I can debug particularly tricky environments.

[Puppet] and [Chef] are other popular alternatives for writing setup scripts, but I haven't used them extensively.

## License
Licensed under the MIT License.

[Ansible]: https://www.ansible.com/
[Bash Booster]: http://www.bashbooster.net/
[Bash]: https://www.gnu.org/software/bash/
[Chef]: https://www.chef.io/chef/
[Puppet]: https://puppetlabs.com/
