#!/usr/bin/env bash

export CURRENT_TAG_NAME=$(git tag --sort version:refname | tail -1 | head -n1)
PREVIOUS_TAG_NAME=$(git tag --sort version:refname | tail -2 | head -n1)
export CURRENT_TAG_AUTHOR_NAME=$(git show "$CURRENT_TAG_NAME" --pretty=format:"%an" --no-patch)
export CURRENT_TAG_AUTHOR_DATE=$(git show "$CURRENT_TAG_NAME" --pretty=format:"%ar" --no-patch)
CHANGELOG=$(git log "$PREVIOUS_TAG_NAME".. --pretty=format:"%h - %s (%an, %ar)\n" | tr -s "\n" " ")

export YT_HOST="https://api.tracker.yandex.net"
export YT_TOKEN="AQAAAAAHBiYUAAd4sTc6OsldZEfwpY6Hfuu6ZvE"
export YT_ORG_ID="6461097"
export YT_QUEUE="TMP"
export YT_UNIQUE_PREFIX="viktor-ulyankin"

export REQUEST_DATA_TASK='{
  "queue": "'$YT_QUEUE'",
  "summary": "CHANGELOG. Release '"$CURRENT_TAG_NAME"' ('"$CURRENT_TAG_AUTHOR_NAME"', '"$CURRENT_TAG_AUTHOR_DATE"')",
  "description": "'"$CHANGELOG"'",
  "unique": "'"$YT_UNIQUE_PREFIX"'_'"$CURRENT_TAG_NAME"'"
}'

# Добавление/обновление задачи в Яндекс Трекер
chmod +x ./.github/workflows/sh/api/task/add.sh
./.github/workflows/sh/api/task/add.sh

if [ $? != 0 ]; then
  exit $?
fi

# Запуск тестов
chmod +x ./.github/workflows/sh/test.sh
./.github/workflows/sh/test.sh

if [ $? != 0 ]; then
  exit $?
fi

# Создание артефакта (Docker)
chmod +x ./.github/workflows/sh/artifact.sh
./.github/workflows/sh/artifact.sh

if [ $? != 0 ]; then
  exit $?
fi