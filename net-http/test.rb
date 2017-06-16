require_relative 'tools'

pid = start_webrick
sleep(1) # wait to make sure server started

begin_at = Time.now
begin
  request("http://localhost:8080/medium", read_timeout: 1)
  puts "client: Ok ellapsed: #{Time.now - begin_at}"
rescue Exception => e
  puts "client: #{e.class.name} ellapsed: #{Time.now - begin_at}"
  # raise e
ensure
  # wait to get all logs from server
  sleep(10)
  stop_server(pid)
  kill_server(pid)
end
