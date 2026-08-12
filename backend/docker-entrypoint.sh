#!/bin/sh
# Applies pending migrations (never `migrate dev` in production, per spec §13.2) before
# starting the API. Safe to run on every container start: no-op when already up to date.
set -e

echo "Running database migrations..."
npx prisma migrate deploy

exec "$@"
