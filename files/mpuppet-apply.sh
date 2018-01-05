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

exec 1> >(logger -s -t "$(basename "$0")") 2>&1

readonly PUPPET_DIR="/etc/puppetlabs/code/environments/production"
readonly PUPPET="/opt/puppetlabs/bin/puppet"

export PATH=/opt/puppetlabs/bin:$PATH

(cd ${PUPPET_DIR}; /opt/puppetlabs/puppet/bin/librarian-puppet install)

$PUPPET apply "$@" "$PUPPET_DIR/manifests"
