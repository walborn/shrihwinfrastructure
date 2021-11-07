#!/bin/bash
# OAuth and OrgId are taken from environment variables

issues="https://api.tracker.yandex.net/v2/issues/"

headerAuth="Authorization: OAuth $OAuth"
headerOrgId="X-Org-Id: $OrgId"
headerContentType="Content-Type: application/json"

# detect current release tag number
tag=$(git describe --tags --abbrev=0)

author=$(git show $tag  --pretty=format:"Author: %an" --date=format:'%Y-%m-%d %H:%M:%S' --no-patch)
date=$(git show ${tag} | grep Date:)

# write changelog by commit history, from previous release tag till current
prev=$(git describe --tags --abbrev=0 $tag^)
commits=$(git log $prev..$tag --pretty=format:"%h - %s (%an, %ar)\n" | tr -s "\n" " ")
echo -e "# $tag\n$commits\n$(cat CHANGELOG.md)" > CHANGELOG.md

created=$(curl --silent --location --request POST ${issues} \
--header "$headerAuth" \
--header "$headerOrgId" \
--header "$headerContentType" \
--data-raw '{
  "queue": "TMP",
  "summary": "'"codebor/$tag"'",
  "type": "task",
  "assignee": "codebor",
  "description": "'"$commits"'",
  "unique": "'"codebor/$tag"'"
}')

status=$(echo "$created" | jq -r '.statusCode')

echo $created
if [ $status = 201 ]; then
  echo "Release created successfully"
elif [ $status = 404 ]; then
  echo "Not found"
elif [ $status = 409 ]; then
  echo "Cannot create task with the same release version"
  echo "Adding new comment then"

  taskId=$(curl --silent --location --request POST ${issues}_search \
    --header "$headerOrgId" \
    --header "$headerAuth" \
    --header "$headerContentType" \
    --data-raw '{
        "filter": {
          "unique": "'"codebor/${tag}"'"
        }
      }' | jq -r '.[0].key')

  updated=$(curl --location --request PATCH ${issues}${taskId} \
  --header "$headerAuth" \
  --header "$headerOrgId" \
  --header "$headerContentType" \
  --data-raw '{
    "summary": "'"codebor/$tag"'",
    "type": "task",
    "assignee": "codebor",
    "description": "'"$commits"'"
  }')

  status=$(echo "$updated" | jq -r '.statusCode')

  if [ $status = 200 ]; then
    echo "Task updated"
  elif [ $status = 404 ]; then
    echo "Task not found"
  elif [ $status = 422 ]; then
    echo "Unable to process the contained instructions"
  fi
else
  echo $created
fi
