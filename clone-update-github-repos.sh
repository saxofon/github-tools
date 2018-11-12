#!/bin/bash

# Author : Per Hallsmark <per@hallsmark.se>
#
# small simple script to backup or get-all-in-once repositories from GitHub

source github/token.shinc

ORGS="orgs/DUSg2 orgs/WindRiver-OpenSourceLabs orgs/WindRiver-Labs orgs/Wind-River orgs/axxia"
USERS="users/saxofon"

for team in ${ORGS} ${USERS}; do
  URL="https://api.github.com/${team}"

  mkdir -p github/${team}/mirrors
  for r in $(curl -s -i -H "Authorization: token ${TOKEN}" ${URL}/repos?per_page=200 | grep ssh_url | cut -d: -f2-3 | tr -d "\","); do
    repo=$(basename $r)
    if [ ! -d github/${team}/mirrors/${repo} ]; then
      echo "Cloning ${team}:${repo}"
      git -C github/${team}/mirrors clone --bare --mirror $r 1>/dev/null 2>&1
    else
      echo "Updating ${ORG}:${repo}"
      git -C github/${team}/mirrors/${repo} remote update 1>/dev/null 2>&1
    fi
    echo ""
  done
done
