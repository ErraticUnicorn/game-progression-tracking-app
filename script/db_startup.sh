#!/bin/bash
set -e

echo "Waiting for PostgreSQL to be ready..."
until pg_isready -h db -p 5432 -U myuser; do
  sleep 1
done

echo "Setting up database..."
if [ ! -f /rails/tmp/db_setup_done ]; then
  bin/rails db:prepare
  bin/rails db:test:prepare
  touch /rails/tmp/db_setup_done
fi

echo "Starting Rails server..."
exec "$@"