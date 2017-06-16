# Small experiments with web servers and timeouts

## net/http experiments

There is nasty bug in `net/http` if you plan to use it with timeout option. See [net-http](net-http) folder.

## Other http clients:
- https://github.com/excon/excon (uses proper `IO.select` with timeout, but [does not close socket in case of timeout](https://github.com/excon/excon/issues/632))
- https://github.com/toland/patron (based on libcurl)
- https://github.com/typhoeus/typhoeus (based on libcurl)
- https://github.com/httprb/http (uses [Timeout](https://flushentitypacket.github.io/ruby/2015/02/21/ruby-timeout-how-does-it-even-work.html))
- https://github.com/nahi/httpclient (uses [Timeout](https://flushentitypacket.github.io/ruby/2015/02/21/ruby-timeout-how-does-it-even-work.html))
- https://github.com/igrigorik/em-http-request

## Unicorn with check_client_connection + excon timeout experiment

See [unicorn-excon](unicorn-excon) folder.

### Problem with closing socket

- https://www.ruby-forum.com/topic/201994
- http://www.ssfnet.org/Exchange/tcp/tcpTutorialNotes.html

## Unicorn links

- [Unicorn docs](https://bogomips.org/unicorn/Unicorn/Configurator.html)
- https://shopifyengineering.myshopify.com/blogs/engineering/17489012-what-does-your-webserver-do-when-a-user-hits-refresh

