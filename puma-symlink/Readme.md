# Simulation of symlink deployment

TODO:
 - [ ] example with process monitor
 - [ ] example with error in new deployment
 - [ ] example with vendored deployment

## USR1 - rolling reload

- probably ok, old version of puma config
- ok, new code
- old version of env variable https://github.com/puma/puma/issues/1351
- old version of Puma
- ok, new version of gem

<details>

```
=== puma startup: 2017-07-02 17:34:08 +0000 ===
=== puma startup: 2017-07-02 17:34:08 +0000 ===
[30467] + Gemfile in context: /vagrant/ruby-server-experiment/puma-symlink/deploy_1/Gemfile
[30471] + Gemfile in context: /vagrant/ruby-server-experiment/puma-symlink/deploy_1/Gemfile
application is loaded 1 config.ru
test1
3.9.0
application is loaded 1 config.ru
test1
3.9.0
1.12.0
[30463] - Worker 1 (pid: 30471) booted, phase: 0
1.12.0
[30463] - Worker 0 (pid: 30467) booted, phase: 0
[30463] - Starting phased worker restart, phase: 1
[30463] + Changing to /vagrant/ruby-server-experiment/puma-symlink/current
[30463] - Stopping 30467 for phased upgrade...
[30463] - TERM sent to 30467...
[30567] + Gemfile in context: /vagrant/ruby-server-experiment/puma-symlink/deploy_2/Gemfile
application is loaded 2 config.ru
test1
3.9.0
1.12.1
[30463] - Worker 0 (pid: 30567) booted, phase: 1
[30463] - Stopping 30471 for phased upgrade...
[30463] - TERM sent to 30471...
[30572] + Gemfile in context: /vagrant/ruby-server-experiment/puma-symlink/deploy_2/Gemfile
application is loaded 2 config.ru
test1
3.9.0
1.12.1
[30463] - Worker 1 (pid: 30572) booted, phase: 1
[30463] Early termination of worker
[30572] ! Detected parent died, dying
[30567] ! Detected parent died, dying
```
</details>

## USR2 - reload

- ok, new version of puma config
- ok, new code
- old version of env variable
- old version of Puma
- old version of gem https://github.com/puma/puma/pull/1315

<details>

```
=== puma startup: 2017-07-02 17:36:02 +0000 ===
=== puma startup: 2017-07-02 17:36:02 +0000 ===
[30694] + Gemfile in context: /vagrant/ruby-server-experiment/puma-symlink/deploy_1/Gemfile
[30697] + Gemfile in context: /vagrant/ruby-server-experiment/puma-symlink/deploy_1/Gemfile
application is loaded 1 config.ru
test1
3.9.0
1.12.0
[30690] - Worker 0 (pid: 30694) booted, phase: 0
application is loaded 1 config.ru
test1
3.9.0
1.12.0
[30690] - Worker 1 (pid: 30697) booted, phase: 0
[30690] - Gracefully shutting down workers...
[30690] * Restarting...
on_restart
puma_config.rb is loaded 2 puma_config.rb
3.9.0
[30690] Puma starting in cluster mode...
[30690] * Version 3.9.0 (ruby 2.3.4-p301), codename: Private Caller
[30690] * Min threads: 1, max threads: 1
[30690] * Environment: development
[30690] * Process workers: 2
[30690] * Phased restart available
[30690] * Inherited tcp://0.0.0.0:8080
[30690] * Daemonizing...
=== puma startup: 2017-07-02 17:36:12 +0000 ===
=== puma startup: 2017-07-02 17:36:12 +0000 ===
application is loaded 2 config.ru
test1
3.9.0
1.12.0
[30739] - Worker 0 (pid: 30742) booted, phase: 0
application is loaded 2 config.ru
test1
3.9.0
1.12.0
[30739] - Worker 1 (pid: 30746) booted, phase: 0
[30739] Early termination of worker
[30746] ! Detected parent died, dying
[30742] ! Detected parent died, dying
```
</details>

## USR2 - reload, but delete old folder before

reload fails
- https://github.com/puma/puma/pull/1315
- https://github.com/puma/puma/issues/1272
- https://github.com/puma/puma/pull/1295

<details>

```
=== puma startup: 2017-07-02 17:37:00 +0000 ===
=== puma startup: 2017-07-02 17:37:00 +0000 ===
[30818] + Gemfile in context: /vagrant/ruby-server-experiment/puma-symlink/deploy_1/Gemfile
[30822] + Gemfile in context: /vagrant/ruby-server-experiment/puma-symlink/deploy_1/Gemfile
application is loaded 1 config.ru
test1
3.9.0
1.12.0
application is loaded 1 config.ru
test1
[30815] - Worker 0 (pid: 30818) booted, phase: 0
3.9.0
1.12.0
[30815] - Worker 1 (pid: 30822) booted, phase: 0
[30815] - Gracefully shutting down workers...
[30815] * Restarting...
on_restart
puma_config.rb:21:in `pwd': No such file or directory - getcwd (Errno::ENOENT)
  from puma_config.rb:21:in `block in _load_from'
  from /home/ubuntu/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/puma-3.9.0/lib/puma/configuration.rb:271:in `block in run_hooks'
  from /home/ubuntu/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/puma-3.9.0/lib/puma/configuration.rb:271:in `each'
  from /home/ubuntu/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/puma-3.9.0/lib/puma/configuration.rb:271:in `run_hooks'
  from /home/ubuntu/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/puma-3.9.0/lib/puma/launcher.rb:212:in `restart!'
  from /home/ubuntu/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/puma-3.9.0/lib/puma/launcher.rb:185:in `run'
  from /home/ubuntu/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/puma-3.9.0/lib/puma/cli.rb:77:in `run'
  from /home/ubuntu/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/puma-3.9.0/bin/puma-wild:31:in `<main>'
```
</details>

## Other

There is also case for unclustered https://github.com/puma/puma/pull/1341

https://github.com/puma/puma/issues/1308



