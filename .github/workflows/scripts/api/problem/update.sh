#!/usr/bin/env bash

# Запрос на поиск задачи
SEARCH_TASK=$(
  curl --location --request POST "$YT_HOST"'/v2/issues/_search' \
  --header 'Authorization: OAuth '"$YT_TOKEN" \
  --header 'X-Org-ID: '"$YT_ORG_ID" \
  --header 'Content-Type: application/json' \
  --data '{
    "filter": {
      "unique": "'"$YT_UNIQUE_PREFIX"'_'"$CURRENT_TAG_NAME"'"
    }
  }'
)

TASK_ID=$(echo "$SEARCH_TASK" | awk -F '"id":"' '{ print $2 }' | awk -F '","' '{ print $1 }')

# Запрос на обновление задачи
UPDATE_TASK_CODE_RESPONSE=$(
  curl -o /dev/null -s -w "%{http_code}\n" --location --request PATCH "$YT_HOST"'/v2/issues/'"$TASK_ID" \
  --header 'Authorization: OAuth '"$YT_TOKEN" \
  --header 'X-Org-ID: '"$YT_ORG_ID" \
  --header 'Content-Type: application/json' \
  --data "$REQUEST_DATA_TASK"
)

FIRST_CHAR_HTTP_RESPONSE=$(echo "$UPDATE_TASK_CODE_RESPONSE" | cut -c 1)

[ "$FIRST_CHAR_HTTP_RESPONSE" = "2" ]
exit $?