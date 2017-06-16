# http://ruby-doc.org/stdlib-2.0.0/libdoc/webrick/rdoc/WEBrick.html
require 'webrick'
server = WEBrick::HTTPServer.new Port: (ARGV[0] || '8080').to_i
trap 'INT' do server.shutdown end
server.mount_proc '/long' do |req, res|
  puts "/long start"
  sleep(600)
  res.body = 'Hello, world!'
  puts "/long end"
end
server.mount_proc '/medium' do |req, res|
  puts "/medium start"
  sleep(5)
  res.body = 'Hello, world!'
  puts "/medium end"
end
server.mount_proc '/' do |req, res|
  res.body = 'Hello, world!'
end
server.start
