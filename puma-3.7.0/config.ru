class TestServer
  def call(env)
    [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
  end
end

run TestServer.new
