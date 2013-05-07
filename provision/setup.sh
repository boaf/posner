#!/usr/bin/env bash

echo "set nocompatible" > /home/vagrant/.vimrc
chown vagrant:vagrant /home/vagrant/.vimrc

apt-get update
apt-get install -y php5-cli php5-common php5-suhosin php5-fpm php5-cgi nginx

DEBIAN_FRONTEND=noninteractive aptitude install -q -y mysql-server

mysql -uroot -e "UPDATE mysql.user SET password=PASSWORD('password') WHERE user='root'; FLUSH PRIVILEGES;"
echo "MySQL Password set to 'password'."

if [ ! -d /vagrant/nginx-logs ]; then
    mkdir /vagrant/nginx-logs;
fi

cp -f /vagrant/setup/nginx.conf /etc/nginx/nginx.conf

/etc/init.d/nginx start
