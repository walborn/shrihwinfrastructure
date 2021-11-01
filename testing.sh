#!/bin/bash
# OAuth и OrgId берутся из переменных окружения
OAuth=$(grep OAuth .env.local | cut -d '=' -f2)
OrgId=$(grep OrgId .env.local | cut -d '=' -f2)

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
        "unique": "'"${tag}"'"
      }
    }' | jq -r '.[0].key')

# todo - понять как проверять успешность тестов
validation=$(yarn test | tr -s "")


comment="Tests:\n $validation"

commented=$(curl --location --request POST ${issues}${taskId}/comments \
  --header "$headerOrgId" \
  --header "$headerAuth" \
  --header "$headerContentType" \
  --data-raw '{
    "text": "'"${comment}"'"
  }')


status=$(echo "$commented" | jq -r '.statusCode')
echo "Created new comment: $commented"

if [ $status = 201 ]; then
  echo "Added new comment TEST RESULT"
elif [ $status = 404 ]; then
  echo "Cannot add new comment, task is not found"
fi

