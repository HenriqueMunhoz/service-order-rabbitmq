#!/bin/sh

set -e

bundle config unset without
bundle config set force_ruby_platform true
bundle config set path 'vendor/bundle'

bundle check || bundle install --path vendor/bundle

bundle exec rails db:create db:migrate

rm -f tmp/pids/server.pid

exec bundle exec "$@"
