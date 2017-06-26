require_relative 'tools'

pid = start_puma_attack
sleep(2) # wait to make sure server started

begin
  # https://github.com/wg/wrk
  exec("wrk -t1 -c1 -d2s http://0.0.0.0:8080/")
ensure
  # wait to get all logs from server
  sleep(10)
  stop_server(pid)
  kill_server(pid)
end
