#!/usr/bin/env bash
#
# Applies masterless puppet to node
#
# Designed to be invoked every so often by an external force (cron).
#

[[ "$TRACE" ]] && set -o xtrace
set -o errexit
set -o nounset
set -o pipefail
set -o noclobber

exec 1>| >(tee >(logger -t $(basename $0))) 2>&1

if [[ -x /opt/puppetlabs/bin/puppet ]]; then
  # Debian-esque installed puppet from puppetlabs deb release
  readonly PUPPET="/opt/puppetlabs/bin/puppet"
  readonly LIBRARIAN_PUPPET="/opt/puppetlabs/puppet/bin/librarian-puppet"
  readonly PUPPET_DIR="/etc/puppetlabs/code/environments/production"
  export PATH=/opt/puppetlabs/bin:$PATH
elif [[ -x /opt/local/bin/puppet ]]; then
  # SmartOS-esque installed puppet from gem under /opt/local
  readonly PUPPET="/opt/local/bin/puppet"
  readonly LIBRARIAN_PUPPET="/opt/local/bin/librarian-puppet"
  readonly PUPPET_DIR="/opt/local/etc/puppetlabs/code/environments/production"
else
  # Something installed puppet from gem under /usr/local
  readonly PUPPET="/usr/local/bin/puppet"
  readonly LIBRARIAN_PUPPET="/usr/local/puppet/bin/librarian-puppet"
  readonly PUPPET_DIR="/etc/puppetlabs/code/environments/production"
fi

(cd ${PUPPET_DIR}; $LIBRARIAN_PUPPET install)

$PUPPET apply "$@" "$PUPPET_DIR/manifests"
