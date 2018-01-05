#!/usr/bin/env bash
#
# Fetches latest puppet changes from remote repo
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
readonly BRANCH_FILE="/etc/puppetlabs/puppet/release_branch"

if [[ ! -f $BRANCH_FILE ]]; then
  echo "Error: release_branch file missing" >> /dev/stderr
  exit 1
fi

export GIT_DIR="${PUPPET_DIR}"
git fetch origin
git checkout -fq "$(cat $BRANCH_FILE)"
