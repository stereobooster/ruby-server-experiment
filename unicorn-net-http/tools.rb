def start_unicorn(port: 8080)
  fork do
    # https://bogomips.org/unicorn/unicorn_1.html
    exec "bundle exec unicorn -p #{port} -c unicorn.rb -w"
  end
end

# https://apidock.com/ruby/Process/kill/class
# https://bogomips.org/unicorn/SIGNALS.html
def stop_server(pid)
  Process.kill("TERM", pid)
end

def kill_server(pid)
  Process.kill("KILL", pid)
end

require "net/http"
require "uri"

def request(url, open_timeout: nil, read_timeout: nil)
  uri = URI.parse(url)
  Net::HTTP.start(uri.host, uri.port) do |http|
    http.open_timeout = open_timeout if open_timeout
    http.read_timeout = read_timeout if read_timeout
    puts "client: #{uri.request_uri}"
    http.request(Net::HTTP::Get.new(uri.request_uri))
  end
end

def async_request(*args)
  fork do
    begin
      request(*args)
    rescue Exception
      # silence exception
    end
  end
end
