require 'rack/attack'
require 'redis-activesupport'
ENV["REDIS_URL"] = "redis://localhost:6379/0"
Rack::Attack.cache.store  = ActiveSupport::Cache::RedisStore.new
Rack::Attack.cache.prefix = "rack-attack"
pr = Proc.new { "requests_day" }
Rack::Attack.throttle("requests_day", limit: 20_000_000, period: 24*60*60, &pr)
use Rack::Attack

class TestServer
  def call(env)
    req = Rack::Request.new(env)
    # puts "server: #{req.path_info} start"
    case req.path_info
    when /long/
      sleep(10)
      # puts "server: #{req.path_info} stop"
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