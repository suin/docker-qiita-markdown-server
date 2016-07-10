#!/bin/sh
set -eux
if [ "$RACK_ENV" == "production" ]
then
  bundle exec rackup -s Rhebok -p $PORT config.ru
else
  bundle exec shotgun -p $PORT -o '0.0.0.0'
fi
