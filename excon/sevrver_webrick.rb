# http://ruby-doc.org/stdlib-2.0.0/libdoc/webrick/rdoc/WEBrick.html
require 'webrick'
server = WEBrick::HTTPServer.new Port: (ARGV[0] || '8080').to_i
trap 'INT' do server.shutdown end
server.mount_proc '/long' do |req, res|
  puts "server: #{req.path} start"
  sleep(10)
  res.body = 'Hello, world!'
  puts "server: #{req.path} end"
end
server.mount_proc '/medium' do |req, res|
  puts "server: #{req.path} start"
  sleep(5)
  res.body = 'Hello, world!'
  puts "server: #{req.path} end"
end
server.mount_proc '/small' do |req, res|
  puts "server: #{req.path} start"
  sleep(2)
  res.body = 'Hello, world!'
  puts "server: #{req.path} end"
end
server.mount_proc '/' do |req, res|
  res.body = 'Hello, world!'
end
server.start
