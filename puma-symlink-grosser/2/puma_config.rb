#!/usr/bin/env puma
# https://github.com/puma/puma/blob/master/examples/config.rb

require 'bundler/setup'
# this will be triggered only for USR2
on_restart do
  puts "on_restart\n"
  ENV.replace(Bundler.clean_env)
end

rackup "config.ru"
bind "tcp://0.0.0.0:8080"
threads 1, 1
workers 2
log_requests

puts "puma_config.rb is loaded 2 #{__FILE__}\n"
puts "#{Puma::Const::VERSION}\n"

stdout_redirect "../puma.log", "../puma.log", true

# before_fork { puts "before_fork\n" }
# after_worker_fork { puts "after_worker_fork\n" }
# on_worker_boot { puts "on_worker_boot\n" }
# on_worker_shutdown { puts "on_worker_shutdown\n" }
# on_worker_fork { puts "on_worker_fork\n" }
