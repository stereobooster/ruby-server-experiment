worker_processes 1 # Integer(ENV["WEB_CONCURRENCY"] || 1)
preload_app true
# logger Logger.new($stdout)

# https://github.com/defunkt/unicorn/commit/5c700fc2cf398848ddcf71a2aa3f0f2a6563e87b
check_client_connection true
# timeout 5
listen(8080, reuseport: true) #, backlog: 10)

before_fork do |server, worker|
  # server.logger.info('before_fork')
  Signal.trap 'TERM' do
    # logger can't be called from trap context
    # server.logger.info('Unicorn master intercepting TERM and sending myself QUIT instead')
    Process.kill 'QUIT', Process.pid
  end
end

after_fork do |server, worker|
  # server.logger.info('after_fork')
  Signal.trap 'TERM' do
    # logger can't be called from trap context
    # server.logger.info('Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT')
  end
end

after_worker_exit do |server, worker, status|
  # server.logger.info('after_worker_exit')
  # status is a Process::Status instance for the exited worker process
  unless status.success?
    server.logger.error("worker process failure: #{status.inspect}")
  end
end

# before_exec do |server|
#   server.logger.info('before_exec')
# end

# after_worker_ready do |server, worker|
#   server.logger.info('after_worker_ready')
# end