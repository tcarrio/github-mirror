#!/usr/bin/env sh

SSH_TOKEN_PATH=${SSH_TOKEN_PATH:-~/.ssh/git_ssh_token}
GIT_LOCAL_REPO=${1:-${PWD}}
GIT_TARGET_REPO=${GIT_TARGET_REPO}
GIT_TARGET_REMOTE=downstream
GIT_SSH_COMMAND="ssh -i \"${SSH_TOKEN_PATH}\""

if [ ! -d "${GIT_LOCAL_REPO}" ]
then
  echo "No local repo found! Exiting"
  exit 1
fi

if [ -z "${GIT_TARGET_REPO}" ]
then
  echo "No target repo configured! Exiting"
  exit 1
fi

if [ ! -f "${SSH_TOKEN_PATH}" ]
then
  echo "No SSH token configured! Exiting"
  exit 1
fi

if ! which git
then
  echo "Git command was not found! Exiting"
  exit 1
fi

pushd "${GIT_LOCAL_REPO}"

set -x
git remote add ${GIT_TARGET_REMOTE} ${GIT_TARGET_REPO}
git branch | grep -E '^\* ' | sed 's/* //' | xargs git push --force --mirror ${GIT_TARGET_REMOTE}

set +x
if [ $? -eq 0 ]
then
  echo "Successfully pushed to mirror"
else
  echo "Failed to push to mirror"
fi

popd