def start_webrick(port: 8080)
  fork do
    exec "ruby sevrver_webrick.rb #{port}"
  end
end

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
    puts "request: #{uri.request_uri}"
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

require 'excon'

def e_request(url, options = nil)
  # connect_timeout: nil, read_timeout: nil, write_timeout: nil
  Excon.get(url, options || {})
end

def async_e_request(*args)
  fork do
    begin
      e_request(*args)
    rescue Exception => e
      # p e # silence exception
    end
  end
end

def e_request_timeout(url, options)
  pid = fork do
    begin
      e_request(url, options)
    # rescue Excon::Error::Timeout
    #   Process.kill("KILL", pid)
    rescue Exception => e
      # p e # silence exception
    end
  end
  timeout = options.fetch(:timeout)
  sleep(timeout)
  Process.kill("KILL", pid)
end

def curl(url, read_timeout: nil, open_timeout: nil)
  open_timeout = open_timeout ? "--connect-timeout #{open_timeout}" : nil
  read_timeout = read_timeout ? "-m #{read_timeout}" : nil
  system("curl --no-keepalive #{open_timeout} #{read_timeout} #{url}")
end

def curl_fork(url, read_timeout: nil, open_timeout: nil)
  open_timeout = open_timeout ? "--connect-timeout #{open_timeout}" : nil
  read_timeout = read_timeout ? "-m #{read_timeout}" : nil
  pid = fork do
    exec("curl --no-keepalive #{open_timeout} #{read_timeout} #{url}")
  end
  sleep(1)
  Process.kill("KILL", pid)
end






