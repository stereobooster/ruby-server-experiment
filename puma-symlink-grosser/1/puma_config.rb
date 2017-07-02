#!/usr/bin/env puma
# https://github.com/puma/puma/blob/master/examples/config.rb

require 'bundler/setup'
Puma::Runner.prepend(Module.new do
  def before_restart
    puts "before_restart\n"
    ENV.replace(Bundler.clean_env)
    super
  end
end)

rackup "config.ru"
bind "tcp://0.0.0.0:8080"
threads 1, 1
workers 2
log_requests

puts "puma_config.rb is loaded 1 #{__FILE__}\n"
puts "#{Puma::Const::VERSION}\n"
puts ENV["TEST"]

stdout_redirect "../puma.log", "../puma.log", true

# before_fork { puts "before_fork\n" }
# after_worker_fork { puts "after_worker_fork\n" }
# on_worker_boot { puts "on_worker_boot\n" }
# on_worker_shutdown { puts "on_worker_shutdown\n" }
# on_worker_fork { puts "on_worker_fork\n" }
