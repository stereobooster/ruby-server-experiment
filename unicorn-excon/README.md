# Expereiment

See https://github.com/excon/excon/issues/632

```
bundle exec ruby test.rb
server: /small/async start
client: Excon::Error::Timeout ellapsed: 1.005363 <-- client disconected
server: /small/async start
server: /small/timeout start                     <-- server processes request of disconnected client
```
