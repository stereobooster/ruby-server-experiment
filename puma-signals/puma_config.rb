#!/usr/bin/env puma
# https://github.com/puma/puma/blob/master/examples/config.rb

rackup 'config.ru'

# as much as your server can take
threads_count = 1
threads threads_count, threads_count

# required for HUP signal
stdout_redirect "puma.log", "puma.log", true

# prefer tcp socket over unix, because it can prevent disconected clients to be processed
bind 'tcp://0.0.0.0:8080'

workers 2 # number of cores

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
end

after_worker_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end

# required for zero-downtime restart
prune_bundler

require 'dotenv'

# this will be triggered only for USR2
on_restart do
  # required for symlink deployment, like to `/current` folder
  ENV["BUNDLE_GEMFILE"] = "#{Dir.pwd}/Gemfile"
  # reloading env variables
  Dotenv.overload("#{Dir.pwd}/example.env")
end

# on_worker_boot do |worker|
#   p "on_worker_boot", worker
# end

# on_worker_shutdown do |worker|
#   p "on_worker_shutdown", worker
# end

# on_worker_fork do |worker|
#   p "on_worker_fork", worker
# end

# lowlevel_error_handler do |e|
#   Rollbar.critical(e)
#   [500, {}, ["An error has occurred, and engineers have been informed. Please reload the page. If you continue to have problems, contact support@example.com\n"]]
# end

# worker_timeout
# worker_boot_timeout
# worker_shutdown_timeout
