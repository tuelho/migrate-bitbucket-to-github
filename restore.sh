#!/bin/bash

#GITHUB_ORGANIZATION=
#GITHUB_URL_ORGANIZATION=https://api.github.com/orgs/${GITHUB_ORGANIZATION}/repos
GITHUB_URL_USER=https://api.github.com/user/repos
GITHUB_USER=
GITHUB_TOKEN=


if [ -z "$GITHUB_TOKEN" ]; then
    echo "No GITHUB_TOKEN supplied"
    exit
fi

if [ -z "$GITHUB_URL_ORGANIZATION" ]; then
    GITHUB_URL=$GITHUB_URL_USER
fi

if [ -z "$GITHUB_URL_USER" ]; then
    GITHUB_URL=$GITHUB_URL_ORGANIZATION
    GITHUB_USER=$GITHUB_ORGANIZATION
fi

for repo in `cat allrepositories.txt`
do
  REPOSITORYNAME=`basename "$repo"`

  echo "Restoring" $REPOSITORYNAME
  curl -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    ${GITHUB_URL} \
    -d "{\"name\":\"${REPOSITORYNAME}\",\"description\":\"${REPOSITORYNAME}\",\"private\":true,\"has_issues\":true,\"has_projects\":true,\"has_wiki\":true}"


  # git clone ${REPOSITORYNAME}.git ${REPOSITORYNAME}
  cd ${REPOSITORYNAME}.git
  git remote add github git@github.com:${GITHUB_USER}/${REPOSITORYNAME}
  git push github --mirror
  cd ..
  rm -rf ${REPOSITORYNAME}.git
  # git push github --tags "refs/remotes/origin/*:refs/heads/*"

done
