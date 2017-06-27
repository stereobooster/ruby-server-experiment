require_relative 'tools'
pid = start_puma
sleep(1)

p "rotate_logs"
rotate_logs(pid)

sleep(1)

p "stop"
stop(pid)

sleep(1)
