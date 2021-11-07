#!/bin/bash
# OAuth and OrgId are taken from environment variables

issues="https://api.tracker.yandex.net/v2/issues/"

headerAuth="Authorization: OAuth $OAuth"
headerOrgId="X-Org-Id: $OrgId"
headerContentType="Content-Type: application/json"

tag=$(git describe --tags --abbrev=0)

taskId=$(curl --silent --location --request POST ${issues}_search \
  --header "$headerOrgId" \
  --header "$headerAuth" \
  --header "$headerContentType" \
  --data-raw '{
      "filter": {
        "unique": "'"codebor/${tag}"'"
      }
    }' | jq -r '.[0].key')


validation=$(yarn test 2>&1 | tail -n +3 | tr -s "\n" " ")

comment="Tests:\n $validation"
commented=$(curl --location --request POST ${issues}${taskId}/comments \
--header "$headerAuth" \
--header "$headerOrgId" \
--header "$headerContentType" \
--data-raw '{
  "text": "'"$comment"'"
}')

status=$(echo "$commented" | jq -r '.statusCode')

if [ $status = 201 ]; then
  echo "Added comment: TEST RESULT"
elif [ $status = 404 ]; then
  echo "Cannot add comment, task is not found"
fi
