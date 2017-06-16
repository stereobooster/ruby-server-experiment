require_relative '../tools'

pid = start_unicorn
sleep(1) # wait to make sure server started

async_e_request("http://localhost:8080/long/async")
async_e_request("http://localhost:8080/long/async")
sleep(0.1)

begin_at = Time.now
begin
  # e_request_timeout("http://localhost:8080/small/timeout", timeout: 1)
  e_request("http://localhost:8080/long/timeout", read_timeout: 1)
  # curl("http://localhost:8080/small/timeout", read_timeout: 1)
  # curl_fork("http://localhost:8080/small/timeout", read_timeout: 1)
  puts "Ok ellapsed: #{Time.now - begin_at}"
rescue Exception => e
  puts "#{e.class.name} ellapsed: #{Time.now - begin_at}"
  raise e
ensure
  # wait to get all logs from server
  sleep(10)
  stop_server(pid)
  sleep(10)
  kill_server(pid)
end
