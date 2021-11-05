#!/usr/bin/env bash

npm ci
npm run build
TEST_RESULT=$(npm run test 2>&1 | tail -n +3 | tr -s "\n" " ")


ADD_TEST_TASK_CODE_RESPONSE=$(
  curl -o /dev/null -s -w "%{http_code}\n" --location --request POST "$YT_HOST"'/v2/issues/' \
  --header 'Authorization: OAuth '"$YT_TOKEN" \
  --header 'X-Org-ID: '"$YT_ORG_ID" \
  --header 'Content-Type: application/json' \
  --data '{
    "queue": "'"$YT_QUEUE"'",
    "summary": "TEST. Release '"$CURRENT_TAG_NAME"' ('"$CURRENT_TAG_AUTHOR_NAME"', '"$CURRENT_TAG_AUTHOR_DATE"')",
    "description": "'"$TEST_RESULT"'"
  }'
)

FIRST_CHAR_CODE_RESPONSE=$(echo "$ADD_TEST_TASK_CODE_RESPONSE" | cut -c 1)

[ "$FIRST_CHAR_CODE_RESPONSE" = "2" ]
exit $?