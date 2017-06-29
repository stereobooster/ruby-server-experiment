require 'dotenv'
require 'logger'

class TestServer
  class << self
    attr_accessor :logger
  end

  def call(env)
    req = Rack::Request.new(env)
    TestServer.logger.info('test')
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

TestServer.logger = Logger.new('app.log')

Signal.trap("HUP") {
  TestServer.logger = Logger.new('app.log')
}

Signal.trap("HUP") {
  p "rotating logs"
}

run TestServer.new
