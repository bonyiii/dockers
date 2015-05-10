#!/bin/sh
set -e

exec su -l user -c 'cd /home/myapp_user/myapp/current && bundle exec rackup -p 3000 -o 0.0.0.0'

# rvm is not function problem
#exec /sbin/setuser user /var/www/myapp
#exec chpst -u user /var/www/myapp
