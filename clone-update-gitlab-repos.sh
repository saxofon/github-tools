#!/bin/bash

# Author : Per Hallsmark <per@hallsmark.se>
#
# small simple script to backup or get-all-in-once repositories from Gitlab

source gitlab/token.shinc

USERS="users/saxofon"

for team in ${USERS}; do
  URL="https://gitlab.com/api/v4/${team}/projects"

  mkdir -p gitlab/${team}/mirrors
  for r in $(curl -s -H "PRIVATE-TOKEN: ${TOKEN}" ${URL} | jq -r '.[] | .ssh_url_to_repo'); do
    repo=$(basename $r)
    if [ ! -d gitlab/${team}/mirrors/${repo} ]; then
      echo "Cloning ${team}:${repo}"
      git -C gitlab/${team}/mirrors clone --bare --mirror $r 1>/dev/null 2>&1
    else
      echo "Updating ${team}:${repo}"
      git -C gitlab/${team}/mirrors/${repo} remote update 1>/dev/null 2>&1
    fi
    echo ""
  done
done
