#!/usr/bin/env bash

docker build -t shri-2021-task-infrastructure:"$CURRENT_TAG_NAME" .

if [ $? != 0 ]; then
  exit $?
fi

ADD_ARTIFACT_TASK_CODE_RESPONSE=$(
  curl -o /dev/null -s -w "%{http_code}\n" --location --request POST "$YT_HOST"'/v2/issues/' \
  --header 'Authorization: OAuth '"$YT_TOKEN" \
  --header 'X-Org-ID: '"$YT_ORG_ID" \
  --header 'Content-Type: application/json' \
  --data '{
    "queue": "'"$YT_QUEUE"'",
    "summary": "ARTIFACT. Release '"$CURRENT_TAG_NAME"' ('"$CURRENT_TAG_AUTHOR_NAME"', '"$CURRENT_TAG_AUTHOR_DATE"')",
    "description": "Docker image shri-2021-task-infrastructure:'"$CURRENT_TAG_NAME"' built"
  }'
)

FIRST_CHAR_CODE_RESPONSE=$(echo "$ADD_ARTIFACT_TASK_CODE_RESPONSE" | cut -c 1)

[ "$FIRST_CHAR_CODE_RESPONSE" = "2" ]
exit $?