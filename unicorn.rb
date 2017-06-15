worker_processes Integer(ENV["WEB_CONCURRENCY"] || 1)
# timeout 5
preload_app true
# https://github.com/defunkt/unicorn/commit/5c700fc2cf398848ddcf71a2aa3f0f2a6563e87b
# check_client_connection true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end
end
