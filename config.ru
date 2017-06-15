# # https://github.com/heroku/rack-timeout
# require "rack-timeout"

# class Rack::TimeoutHelper
#   def initialize(app)
#     @app = app
#   end

#   def call(env)
#     @app.call(env)
#   rescue Rack::Timeout::RequestTimeoutError
#     [504, {"Content-Type" => "text/html"}, ["Gateway Timeout"]]
#   end
# end

# use Rack::TimeoutHelper

# # Call as early as possible so rack-timeout runs before all other middleware.
# # Setting service_timeout is recommended. If omitted, defaults to 15 seconds.
# use Rack::Timeout, service_timeout: 5

class TestServer
  def call(env)
    req = Rack::Request.new(env)
    # puts "#{req.path_info} start"
    case req.path_info
    when /long/
      sleep(600)
      [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
    when /medium/
      sleep(5)
      # puts "#{req.path_info} end"
      [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
    else
      [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
    end
  end
end

run TestServer.new
