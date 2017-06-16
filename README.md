Small experiment with web servers and timeouts

https://shopifyengineering.myshopify.com/blogs/engineering/17489012-what-does-your-webserver-do-when-a-user-hits-refresh

### net/http experiments

- Default network timeout is 120s, it corresponds to read timeout 60s
- `open_timeout: 60, read_timeout: 1` => `Net::ReadTimeout` in ~ 2s
- `open_timeout: 5, read_timeout: 10` => `Net::ReadTimeout` in ~ 20s
- `read_timeout: 1, open_timeout: 0.001` => `Net::OpenTimeout` in ~ 0.002s
- `request("http://not-existing/")` => `SocketError` in ~ 0.002s
- [Net::HTTP retries idempotent requests once after a timeout, but its not configurable](https://bugs.ruby-lang.org/issues/10674). It means that [httparty](https://github.com/jnunemaker/httparty) and [Faraday with net_http adapter](https://github.com/lostisland/faraday/blob/f994b054f9c4eb3e1200f8fb4f8da89a21d3d346/lib/faraday/adapter.rb) are affected.

Other http clients:
- https://github.com/excon/excon (uses proper `IO.select` with timeout, but [does not close socket in case of timeout](https://github.com/excon/excon/issues/632))
- https://github.com/toland/patron (based on libcurl)
- https://github.com/typhoeus/typhoeus (based on libcurl)
- https://github.com/httprb/http (uses [Timeout](https://flushentitypacket.github.io/ruby/2015/02/21/ruby-timeout-how-does-it-even-work.html))
- https://github.com/nahi/httpclient (uses [Timeout](https://flushentitypacket.github.io/ruby/2015/02/21/ruby-timeout-how-does-it-even-work.html))
- https://github.com/igrigorik/em-http-request

### Problem with closing socket

- https://www.ruby-forum.com/topic/201994
- http://www.ssfnet.org/Exchange/tcp/tcpTutorialNotes.html

### Unicorn experiments

[Unicorn docs](https://bogomips.org/unicorn/Unicorn/Configurator.html)

1. default
```
request("http://localhost:8080/long", read_timeout: 5)

Net::ReadTimeout ellapsed: 10.01436
```

2. unicorn timeout
```
unicorn timeout 5
request("http://localhost:8080/", read_timeout: 20)

ERROR -- : worker=0 PID:55986 timeout (6s > 5s), killing
ERROR -- : reaped #<Process::Status: pid 55986 SIGKILL (signal 9)> worker=0
 INFO -- : worker=0 ready
ERROR -- : worker=0 PID:55989 timeout (6s > 5s), killing
ERROR -- : reaped #<Process::Status: pid 55989 SIGKILL (signal 9)> worker=0
EOFError ellapsed: 11.35429
```

3. Rack::Timeout
```
use Rack::Timeout, service_timeout: 5

 INFO -- : worker=0 ready
ERROR -- : source=rack-timeout id=4b163e1247cf077e7fc39eb5c88f788e timeout=5000ms service=5008ms state=timed_out
127.0.0.1 - - [15/Jun/2017:23:20:08 +0200] "GET /long HTTP/1.1" 504 - 5.0140
Ok ellapsed: 5.019617
```

4.
```
async_request("http://localhost:8080/medium/async")
sleep(0.1)
request("http://localhost:8080/medium", read_timeout: 1)

request: /medium/async
/medium/async start
request: /medium
Net::ReadTimeout ellapsed: 2.009287
/medium/async end
 /medium/async HTTP/1.1" 200 - 5.0072
/medium start
/medium end
"GET /medium HTTP/1.1" 200 - 5.0029
/medium start
/medium end
"GET /medium HTTP/1.1" 200 - 5.0024
```
