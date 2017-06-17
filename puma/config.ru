class TestServer
  def call(env)
    req = Rack::Request.new(env)
    puts "server: #{req.path_info} start"
    case req.path_info
    when /long/
      sleep(10)
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
