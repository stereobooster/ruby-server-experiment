# sleep (2) # simuating time to load big codebase
puts "application is loaded 2 #{__FILE__}\n"
puts "#{ENV["TEST"]}\n"
puts "#{Puma::Const::VERSION}\n"

require 'multi_json'
puts "#{MultiJson::VERSION}\n"

class TestServer
  def call(env)
    [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
  end
end

run TestServer.new
