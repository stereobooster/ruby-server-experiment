#!/usr/bin/env puma
# https://github.com/puma/puma/blob/master/examples/config.rb

rackup 'config.ru'

threads 0, 1

bind 'tcp://0.0.0.0:8080'

# bind 'unix:///var/run/puma.sock'
# bind 'unix:///var/run/puma.sock?umask=0111'
# bind 'ssl://127.0.0.1:9292?key=path_to_key&cert=path_to_cert'

preload_app!

worker_timeout 10

