def start_webrick(port: 8080)
  fork do
    exec "ruby sevrver_webrick.rb #{port}"
  end
end

def start_thin(port: 8080, conns: 20)
  fork do
    # https://github.com/macournoyer/thin/blob/master/lib/thin/runner.rb
    exec "bundle exec thin -R app.ru -a 127.0.0.1 -p #{port} --max-conns #{conns} start"
  end
end

# https://apidock.com/ruby/Process/kill/class
def stop_server(pid)
  Process.kill("TERM", pid)
end

def kill_server(pid)
  Process.kill("KILL", pid)
end



pid = start_webrick
sleep(0.5)

require "net/http"
require "uri"

begin
  uri = URI.parse("http://localhost:8080/")
  http = Net::HTTP.new(uri.host, uri.port)
  # http.timeout there is no timeout setting
  http.open_timeout = 1 # seconds
  http.read_timeout = 1 # seconds

  response = http.request(Net::HTTP::Get.new(uri.request_uri))

  p response
rescue Exception
  raise
ensure
  kill_server(pid)
  sleep(1)
end
