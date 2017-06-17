require_relative 'tools'

pid = start_unicorn
sleep(1) # wait to make sure server started

async_e_request("http://localhost:8080/small/async")
async_e_request("http://localhost:8080/small/async")
sleep(0.1)

begin_at = Time.now
begin
  e_request("http://localhost:8080/small/timeout", read_timeout: 1)
  puts "client: ok ellapsed: #{Time.now - begin_at}"
rescue Exception => e
  puts "client: #{e.class.name} ellapsed: #{Time.now - begin_at}"
  raise e
ensure
  # wait to get all logs from server
  sleep(10)
  stop_server(pid)
  sleep(1)
  kill_server(pid)
end
