#!/usr/bin/env puma
# https://github.com/puma/puma/blob/master/examples/config.rb

rackup 'config.ru'

threads 1, 1

bind 'tcp://0.0.0.0:8080'

preload_app!

worker_timeout 5
