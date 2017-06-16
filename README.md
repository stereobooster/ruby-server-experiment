# Small experiments with web servers and timeouts

## net/http experiments

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

## Unicorn with check_client_connection + excon timeout experiment

### Problem with closing socket

- https://www.ruby-forum.com/topic/201994
- http://www.ssfnet.org/Exchange/tcp/tcpTutorialNotes.html

## Unicorn links

- [Unicorn docs](https://bogomips.org/unicorn/Unicorn/Configurator.html)
- https://shopifyengineering.myshopify.com/blogs/engineering/17489012-what-does-your-webserver-do-when-a-user-hits-refresh

