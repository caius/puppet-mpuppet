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

exec 1> >(tee >(logger -t $(basename $0))) 2>&1

if [[ -x /opt/puppetlabs/bin/puppet ]]; then
  # Debian-esque installed puppet from puppetlabs deb release
  readonly PUPPET="/opt/puppetlabs/bin/puppet"
  readonly PUPPET_DIR="/etc/puppetlabs/code/environments/production"
  readonly BRANCH_FILE="/etc/puppetlabs/puppet/release_branch"
elif [[ -x /opt/local/bin/puppet ]]; then
  # SmartOS-esque installed puppet from gem under /opt/local
  readonly PUPPET="/opt/local/bin/puppet"
  readonly PUPPET_DIR="/opt/local/etc/puppetlabs/code/environments/production"
  readonly BRANCH_FILE="/opt/local/etc/puppetlabs/puppet/release_branch"
else
  # Something installed puppet from gem under /usr/local
  readonly PUPPET="/usr/local/bin/puppet"
  readonly PUPPET_DIR="/etc/puppetlabs/code/environments/production"
  readonly BRANCH_FILE="/etc/puppetlabs/puppet/release_branch"
fi

if [[ ! -f $BRANCH_FILE ]]; then
  echo "Error: release_branch file missing" >> /dev/stderr
  exit 1
fi

git -C "${PUPPET_DIR}" fetch origin
git -C "${PUPPET_DIR}" checkout -fq "origin/$(cat $BRANCH_FILE)"
