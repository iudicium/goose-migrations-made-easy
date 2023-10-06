#!/bin/bash

STATE="u"

while getopts "s:" opt; do
  case "${opt}" in
    s)
      STATE="${OPTARG}"
      ;;
    *)
      echo "Usage: $0 [-s state]"
      exit 1
      ;;
  esac
done
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    source .env
else
    echo "Error: .env file not found."
    exit 1
fi

DATABASE_URL="${DB_TYPE}://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}"


if [ "$DB_TYPE" == "postgres" ]; then
    DATABASE_URL="${DATABASE_URL}?sslmode=disable"
fi


if [ "$STATE" == "u" ]; then
    echo "Running Goose migrations up!"
    goose -dir internal/database/schema "${DB_TYPE}" "${DATABASE_URL}" up
else
    echo "Running goose migrations down"
    goose -dir internal/database/schema "${DB_TYPE}" "${DATABASE_URL}" down

fi
