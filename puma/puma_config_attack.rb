#!/usr/bin/env puma
# https://github.com/puma/puma/blob/master/examples/config.rb

rackup 'config_rack_attack.ru'

# stdout_redirect 'puma.log', 'puma.log', true

threads 100, 100

bind 'tcp://0.0.0.0:8080'

preload_app!

worker_timeout 5
