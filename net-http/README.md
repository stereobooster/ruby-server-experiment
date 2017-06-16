# Net::HTTP bug

[Net::HTTP retries idempotent requests once after a timeout, but its not configurable](https://bugs.ruby-lang.org/issues/10674). It means that [httparty](https://github.com/jnunemaker/httparty) and [Faraday with net_http adapter](https://github.com/lostisland/faraday/blob/f994b054f9c4eb3e1200f8fb4f8da89a21d3d346/lib/faraday/adapter.rb) are affected.

- Default network timeout is 120s, it corresponds to read timeout 60s
- `open_timeout: 60, read_timeout: 1` => `Net::ReadTimeout` in ~ 2s
- `open_timeout: 5, read_timeout: 10` => `Net::ReadTimeout` in ~ 20s
- `read_timeout: 1, open_timeout: 0.001` => `Net::OpenTimeout` in ~ 0.002s
- `request("http://not-existing/")` => `SocketError` in ~ 0.002s

```
ruby test.rb
request: /medium
server: /medium start                        <-- This is first request, timed out after 1s
server: /medium start                        <-- This is retry, timed out after 1s
client: Net::ReadTimeout ellapsed: 2.009982  <-- Exception with total timeout 2s
server: /medium end                          <-- server finished processing
- -> /medium                                 <-- but connection already closed, so error while writing to socket
ERROR Errno::ECONNRESET: Connection reset by peer @ io_fillbuf - fd:13
  webrick/httpserver.rb:80:in `eof?'
  webrick/httpserver.rb:80:in `run'
  webrick/server.rb:294:in `block in start_thread'
server: /medium end
- -> /medium
ERROR Errno::ECONNRESET: Connection reset by peer @ io_fillbuf - fd:14
  webrick/httpserver.rb:80:in `eof?'
  webrick/httpserver.rb:80:in `run'
  webrick/server.rb:294:in `block in start_thread'
```