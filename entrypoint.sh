#!/bin/bash
set -e
rm -f /test_app/tmp/pids/server.pid
bundle exec whenever --update-crontab
service cron start
./bin/dev
exec "$@"