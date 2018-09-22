#!/usr/bin/env bash

echo "=> Waiting for database to be ready..."
while nc -z ${DB_HOST:-db} ${DB_HOST:-3306}; do sleep 1; done

if [ ! -e /status/setup ]; then
    echo "=> Running first-time setup..."
    php artisan key:generate

    sleep 10 # Let the db startup
    php artisan migrate

    touch /status/setup
fi

echo "=> Starting dev server..."
php artisan serve --host=0.0.0.0 --port=8080