#!/bin/bash

# Author : Per Hallsmark <per@hallsmark.se>
#
# small simple script to backup or get-all-in-once repositories from GitHub

source ./token.shinc

ORGS="DUSg2 WindRiver-OpenSourceLabs WindRiver-Labs Wind-River axxia"

for ORG in ${ORGS}; do
  URL="https://api.github.com/orgs/${ORG}"

  mkdir -p orgs/${ORG}/mirrors
  for r in $(curl -s -i -H "Authorization: token ${TOKEN}" ${URL}/repos?per_page=200 | grep ssh_url | cut -d: -f2-3 | tr -d "\","); do
    repo=$(basename $r)
    if [ ! -d orgs/${ORG}/mirrors/${repo} ]; then
      echo "Cloning ${ORG}:${repo}"
      git -C orgs/${ORG}/mirrors clone --bare --mirror $r
    else
      echo "Updating ${ORG}:${repo}"
      git -C orgs/${ORG}/mirrors/${repo} remote update
    fi
    echo ""
  done
done
