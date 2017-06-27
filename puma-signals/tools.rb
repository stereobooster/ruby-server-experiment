def start_puma()
  fork do
    exec "bundle exec puma -C puma_config.rb"
  end
end

# https://github.com/puma/puma/blob/master/docs/signals.md#puma-signals
def stop(pid)
  Process.kill("TERM", pid)
end

def force_stop(pid)
  Process.kill("QUIT", pid)
end

# restart workers in phases, a rolling restart.
def restart(pid)
  Process.kill("USR1", pid)
end

def rotate_logs(pid)
  # only works with stdout_redirect
  Process.kill("HUP", pid)
end

require "net/http"
require_relative "net_http_patch"
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
