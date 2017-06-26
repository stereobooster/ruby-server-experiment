class RackExceptionCatcher
  def initialize(app)
    @app = app
  end
  def call(env)
    @app.call(env)
  rescue Rack::Timeout::RequestTimeoutError
    # TODO: log timeout
    [504, {"Content-Type" => "text/html"}, ["Gateway Timeout"]]
  end
end
use RackExceptionCatcher
require "rack-timeout"
use Rack::Timeout, service_timeout: 5

class TestServer
  def call(env)
    req = Rack::Request.new(env)
    puts "server: #{req.path_info} start"
    case req.path_info
    when /long/
      sleep(10)
      puts "server: #{req.path_info} stop"
      [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
    when /medium/
      sleep(5)
      # puts "#{req.path_info} end"
      [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
    when /small/
      sleep(2)
      # puts "#{req.path_info} end"
      [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
    else
      [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
    end
  end
end

run TestServer.new
