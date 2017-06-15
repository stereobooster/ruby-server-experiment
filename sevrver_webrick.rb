# http://ruby-doc.org/stdlib-2.0.0/libdoc/webrick/rdoc/WEBrick.html
require 'webrick'
server = WEBrick::HTTPServer.new Port: (ARGV[0] || '8080').to_i
trap 'INT' do server.shutdown end
server.mount_proc '/' do |req, res|
  sleep(600)
  res.body = 'Hello, world!'
end
server.start
