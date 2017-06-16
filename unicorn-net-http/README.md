# Expereiment

```
bundle exec ruby test.rb
client: /small/async
client: /small/async
server: /small/async start
client: /small/timeout
client: Net::ReadTimeout ellapsed: 1.009617
server: /small/async start
server: /small/timeout start <-- theoretically server should not process the request because client dropped
server: /small/timeout start
```

In similar example with Webrick - Net::HTTP dropes connection. I have a suspicion that unicorn has a bug

## So far `check_client_connection` is untestable on Mac OS

```
git clone git@github.com:defunkt/unicorn.git
cd unicorn
brew install ragel
make
ruby test/unit/test_ccc.rb
Loaded suite test/unit/test_ccc
Started
server got 102 requests with 100 CCC aborted
Exception `Test::Unit::AssertionFailedError' at test-unit-3.2.3/lib/test/unit/assertions.rb:55 - <102> expected to be
<
<100>.
F
=====================================================================================================================================================================================
Failure:
  <102> expected to be
  <
  <100>.
test_ccc_tcpi(TestCccTCPI)
test/unit/test_ccc.rb:79:in `test_ccc_tcpi'
     76:     assert status.success?
     77:     reqs = rd.read.to_i
     78:     warn "server got #{reqs} requests with #{nr} CCC aborted\n" if $DEBUG
  => 79:     assert_operator reqs, :<, nr
     80:     assert_operator reqs, :>=, 2, 'first 2 requests got through, at least'
     81:   ensure
     82:     return if start_pid != $$
=====================================================================================================================================================================================


Finished in 0.144537 seconds.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1 tests, 7 assertions, 1 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
0% passed
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
6.92 tests/s, 48.43 assertions/s
```