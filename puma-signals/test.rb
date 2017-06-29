require_relative 'tools'
# pid = start_puma
# sleep(1)

begin
  request("http://localhost:8080/long", read_timeout: 1)
rescue
end
request("http://localhost:8080/", read_timeout: 1)