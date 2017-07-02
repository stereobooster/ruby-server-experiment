loop do
  Signal.trap("HUP") do
    puts "HUP"
    exit 1
  end
  sleep 1
end
