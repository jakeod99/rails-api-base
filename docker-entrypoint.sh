#!/bin/bash
set -e

rm -f /rails-api-base/tmp/pids/server.pid

exec "$@"