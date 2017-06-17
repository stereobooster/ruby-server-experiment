worker_processes 1
preload_app true
timeout 10

# https://github.com/defunkt/unicorn/commit/5c700fc2cf398848ddcf71a2aa3f0f2a6563e87b
check_client_connection true
listen "#{Dir.pwd}/unicorn.sock", reuseport: true
