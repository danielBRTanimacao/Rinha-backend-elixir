#!/bin/sh

set -e

echo ">> Running migrations..."
/app/bin/rinha_backend eval "RinhaBackend.Release.migrate"

echo ">> Starting the server..."
exec /app/bin/rinha_backend start
