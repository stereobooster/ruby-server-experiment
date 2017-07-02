#!/bin/bash
rm -rf current
rm -rf deploy_1
rm -rf deploy_2

export TEST=test1
cp -r 1 deploy_1
cd deploy_1 && bundle
cd ..
ln -s deploy_1 current
cd current
# you want to use some kind of init script in production
# plus some kind of process monitor, like monit or similar
bundle exec puma -C puma_config.rb --daemon --pidfile ../puma.pid
cd ..
sleep 2

export TEST=test2
cp -r 2 deploy_2
cd deploy_2 && bundle
cd ..
rm -f current
ln -s deploy_2 current
rm -rf deploy_1
kill -USR1 `cat puma.pid`
sleep 10


kill -TERM `cat puma.pid`
rm -rf current
rm -rf deploy_1
rm -rf deploy_2
