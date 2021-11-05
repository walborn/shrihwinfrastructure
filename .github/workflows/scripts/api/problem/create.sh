#!/usr/bin/env bash

# Запрос на создание задачи (записи в реестре релизов)
ADD_TASK_RESPONSE_CODE_RESPONSE=$(
  curl -o /dev/null -s -w "%{http_code}\n" --location --request POST "$YT_HOST"'/v2/issues/' \
  --header 'Authorization: OAuth '"$YT_TOKEN" \
  --header 'X-Org-ID: '"$YT_ORG_ID" \
  --header 'Content-Type: application/json' \
  --data "$REQUEST_DATA_TASK"
)

if [ "$ADD_TASK_RESPONSE_CODE_RESPONSE" = "409" ]; then
  # Обновление задачи в Яндекс Трекер
  chmod +x ./.github/workflows/sh/api/task/update.sh
  ./.github/workflows/sh/api/task/update.sh

  if [ $? != 0 ]; then
    exit $?
  fi
else
  FIRST_CHAR_HTTP_RESPONSE=$(echo "$ADD_TASK_RESPONSE_CODE_RESPONSE" | cut -c 1)

  [ "$FIRST_CHAR_HTTP_RESPONSE" = "2" ]
  exit $?
fi