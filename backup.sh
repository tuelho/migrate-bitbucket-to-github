#!/bin/bash

GIT_USERNAME=
GIT_PASSWORD=

if [ -z "$GIT_USERNAME" ]; then
    echo "No GIT_USERNAME supplied"
    exit
fi
if [ -z "$GIT_PASSWORD" ]; then
    echo "No GIT_PASSWORD supplied"
    exit
fi

rm -rf allrepositories.txt

user=$GIT_USERNAME:$GIT_PASSWORD
url='https://api.bitbucket.org/2.0/user/permissions/repositories'
echo curl -u $user -X GET $url
while [ ! "$url" == "null" ]
do
  curl -u $user -X GET $url > repositories.json
  jq -r '.values[] | .repository.links.html.href' repositories.json > repositories.txt
  cat repositories.txt >> allrepositories.txt
  for repo in `cat repositories.txt`
  do
    REPOSITORYNAME=`basename "$repo"`
    echo "Cloning" $REPOSITORYNAME
    git clone --mirror $repo
  done
  url=`jq -r '.next' repositories.json`
done

rm -rf repositories.json
rm -rf repositories.txt
