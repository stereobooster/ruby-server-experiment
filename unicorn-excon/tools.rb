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

require 'excon'

def e_request(url, options = nil)
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





