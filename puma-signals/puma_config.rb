#!/usr/bin/env puma
# https://github.com/puma/puma/blob/master/examples/config.rb

rackup 'config.ru'

threads_count = 1
threads threads_count, threads_count

stdout_redirect "puma.log", "puma.log", true

bind 'tcp://0.0.0.0:8080'

# worker_timeout 5
workers 2

# before_fork do
#   p "before_fork"
# end

# on_worker_boot do |worker|
#   p "on_worker_boot", worker
# end

# on_worker_shutdown do |worker|
#   p "on_worker_shutdown", worker
# end

# on_worker_fork do |worker|
#   p "on_worker_fork", worker
# end

# after_worker_fork do |worker|
#   p "after_worker_fork", worker
# end

# lowlevel_error_handler do |e|
#   Rollbar.critical(e)
#   [500, {}, ["An error has occurred, and engineers have been informed. Please reload the page. If you continue to have problems, contact support@example.com\n"]]
# end

# worker_timeout
# worker_boot_timeout
# worker_shutdown_timeout
