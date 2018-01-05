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

readonly BRANCH_OVERRIDE_FILE="/etc/puppetlabs/puppet/branch"
if [[ -f $BRANCH_OVERRIDE_FILE ]]; then
  readonly PUPPET_BRANCH=$(cat $BRANCH_OVERRIDE_FILE)
else
  readonly PUPPET_BRANCH="origin/master"
fi

export GIT_DIR="${PUPPET_DIR}"
git fetch origin
git checkout -fq "${PUPPET_BRANCH}"
