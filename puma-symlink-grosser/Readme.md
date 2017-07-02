# Simulation of symlink deployment

Testcases for @grosser's patch

## USR2 - reload, but do not delete previous folder

### First of all error:

<details>

```
=== puma startup: 2017-07-02 18:26:03 +0000 ===
=== puma startup: 2017-07-02 18:26:03 +0000 ===
[31569] + Gemfile in context: /vagrant/ruby-server-experiment/puma-symlink-grosser/deploy_1/Gemfile
[31573] + Gemfile in context: /vagrant/ruby-server-experiment/puma-symlink-grosser/deploy_1/Gemfile
application is loaded 1 config.ru
test1
3.9.0
1.12.0
[31566] - Worker 0 (pid: 31569) booted, phase: 0
application is loaded 1 config.ru
test1
3.9.0
1.12.0
[31566] - Worker 1 (pid: 31573) booted, phase: 0
[31566] - Gracefully shutting down workers...
[31566] * Restarting...
before_restart
puma_config.rb:37:in `before_restart': uninitialized constant #<Class:#<Puma::DSL:0x0055883f37e188>>::Bundler (NameError)
  from /home/ubuntu/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/puma-3.9.0/lib/puma/launcher.rb:184:in `run'
  from /home/ubuntu/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/puma-3.9.0/lib/puma/cli.rb:77:in `run'
  from /home/ubuntu/.rbenv/versions/2.3.4/lib/ruby/gems/2.3.0/gems/puma-3.9.0/bin/puma-wild:31:in `<main>'
```
</details>


### After adding `require 'bundler/setup'`

<details>

```
./test_usr2.sh
Fetching gem metadata from https://rubygems.org/...............
Fetching version metadata from https://rubygems.org/..
Resolving dependencies...
Using puma 3.9.0
Using rack 2.0.2
Using multi_json 1.12.0
Using bundler 1.15.1
Bundle complete! 3 Gemfile dependencies, 4 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
puma_config.rb is loaded 1 puma_config.rb
3.9.0
test1
* Pruning Bundler environment
puma_config.rb is loaded 1 puma_config.rb
3.9.0
test1
* Pruning Bundler environment
puma_config.rb is loaded 1 puma_config.rb
3.9.0
test1
* Pruning Bundler environment
puma_config.rb is loaded 1 puma_config.rb
3.9.0
test1
* Pruning Bundler environment
puma_config.rb is loaded 1 puma_config.rb
3.9.0
test1
...
```
</details>

### After removing `prune_bundler`

- ok, new version of puma config
- ok, new code
- old version of env variable
- ok, new version of Puma
- ok, new version of gem

<details>

```
=== puma startup: 2017-07-02 18:33:27 +0000 ===
=== puma startup: 2017-07-02 18:33:27 +0000 ===
application is loaded 1 config.ru
test1
3.9.0
application is loaded 1 config.ru
test1
3.9.0
1.12.0
[32241] - Worker 0 (pid: 32245) booted, phase: 0
1.12.0
[32241] - Worker 1 (pid: 32249) booted, phase: 0
[32241] - Gracefully shutting down workers...
[32241] * Restarting...
before_restart
on_restart
puma_config.rb is loaded 2 puma_config.rb
3.9.1
[32241] Puma starting in cluster mode...
[32241] * Version 3.9.1 (ruby 2.3.4-p301), codename: Private Caller
[32241] * Min threads: 1, max threads: 1
[32241] * Environment: development
[32241] * Process workers: 2
[32241] * Phased restart available
[32241] * Inherited tcp://0.0.0.0:8080
[32241] * Daemonizing...
=== puma startup: 2017-07-02 18:33:36 +0000 ===
=== puma startup: 2017-07-02 18:33:36 +0000 ===
application is loaded 2 config.ru
test1
3.9.1
1.12.1
[32290] - Worker 0 (pid: 32293) booted, phase: 0
application is loaded 2 config.ru
test1
3.9.1
1.12.1
[32290] - Worker 1 (pid: 32297) booted, phase: 0
[32290] Early termination of worker
[32297] ! Detected parent died, dying
[32293] ! Detected parent died, dying
```
</details>


## USR2 - reload and delete old folder before

Works the same as first scenario

## Simplified patch

Original @grosser's patch

```ruby
require 'bundler/setup'
Puma::Runner.prepend(Module.new do
  def before_restart
    puts "before_restart\n"
    ENV.replace(Bundler.clean_env)
    super
  end
end)
```

Simplified patch (works the same)

```ruby
require 'bundler/setup'
# this will be triggered only for USR2
on_restart do
  puts "on_restart\n"
  ENV.replace(Bundler.clean_env)
end
```

## USR1

- old version of puma config
- ok, new code
- old version of env variable
- old version of Puma
- old version of gem https://github.com/puma/puma/pull/1315

<details>

```
=== puma startup: 2017-07-02 19:27:51 +0000 ===
=== puma startup: 2017-07-02 19:27:51 +0000 ===
application is loaded 1 config.ru
test1
3.9.0
1.12.0
application is loaded 1 config.ru
[781] - Worker 1 (pid: 789) booted, phase: 0
test1
3.9.0
1.12.0
[781] - Worker 0 (pid: 785) booted, phase: 0
[781] - Starting phased worker restart, phase: 1
[781] + Changing to /vagrant/ruby-server-experiment/puma-symlink-grosser/current
[781] - Stopping 785 for phased upgrade...
[781] - TERM sent to 785...
application is loaded 2 config.ru
test1
3.9.0
1.12.0
[781] - Worker 0 (pid: 827) booted, phase: 1
[781] - Stopping 789 for phased upgrade...
[781] - TERM sent to 789...
application is loaded 2 config.ru
test1
3.9.0
1.12.0
[781] - Worker 1 (pid: 837) booted, phase: 1
[781] Early termination of worker
[837] ! Detected parent died, dying
[827] ! Detected parent died, dying
```
</details>

