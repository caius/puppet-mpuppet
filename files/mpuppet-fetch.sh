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

git -C "${PUPPET_DIR}" fetch origin
git -C "${PUPPET_DIR}" checkout -fq "origin/$(cat $BRANCH_FILE)"
