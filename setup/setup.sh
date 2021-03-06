DEV_HOST=$1
DEV_IP=$2
WP_THEME_NAME=$3

start_time=`date`

if [ -f /vagrant/setup/initial_provision_run ]
then
    printf "\nSkipping package installation, not initial boot...\n\n"
else
    # Add any custom package sources to help install more current software
    cat /srv/config/apt-source-append.list >> /etc/apt/sources.list

    # update all of the package references before installing anything
    printf "Updating apt-get\n\n"
    apt-get update --force-yes -y > /dev/null

    # MYSQL
    #
    # We need to set the selections to automatically fill the password prompt
    # for mysql while it is being installed. The password in the following two
    # lines *is* actually set to the word 'blank' for the root user.
    echo mysql-server mysql-server/root_password password blank | debconf-set-selections
    echo mysql-server mysql-server/root_password_again password blank | debconf-set-selections

    # PACKAGE INSTALLATION
    #
    # Build a bash array to pass all of the packages we want to install to
    # a single apt-get command. This avoids having to do all the leg work
    # each time a package is set to install. It also allows us to easily comment
    # out or add single packages.
    apt_package_list=(
        php5-fpm
        php5-cli

        php5-common
        php5-dev

        php5-mysql
        php-pear

        nginx

        mysql-server

        curl
        git-core
        vim
        sendmail

        dos2unix
    )

    echo "Install apt-get packages needed for Posner..."
    apt-get install --force-yes -y ${apt_package_list[@]} > /dev/null

    # Clean up apt caches
    apt-get clean

    touch /vagrant/setup/initial_provision_run
fi

# Configuration for nginx
ln -sf /srv/config/nginx.conf /etc/nginx/nginx.conf | echo "Linked nginx.conf to /etc/nginx/"

# Configuration for php5-fpm
ln -sf /srv/config/php5-fpm-config/www.conf /etc/php5/fpm/pool.d/www.conf | echo "Linked www.conf to /etc/php5/fpm/pool.d/"
ln -sf /srv/config/php5-fpm-config/php.ini /etc/php5/fpm/php.ini | echo "Linked php.ini to /etc/php5/fpm/"

# Configuration for mysql
cp /srv/config/my.cnf /etc/mysql/my.cnf | echo "Copied my.cnf to /etc/mysql/"

# Custom bash_profile for our vagrant user
ln -sf /srv/config/bash_profile /home/vagrant/.bash_profile | echo "Linked .bash_profile to vagrant user's home directory..."

# Custom bash_aliases included by vagrant user's .bashrc
ln -sf /srv/config/bash_aliases /home/vagrant/.bash_aliases | echo "Linked .bash_aliases to vagrant user's home directory..."

# Custom vim configuration via .vimrc
ln -sf /srv/config/vimrc /home/vagrant/.vimrc | echo "Linked vim configuration to home directory..."

# RESTART SERVICES
#
# Make sure the services we expect to be running are running.
printf "\nRestarting services\n"
service nginx restart
service php5-fpm restart

# mysql gives us an error if we restart a non running service, which
# happens after a `vagrant halt`. Check to see if it's running before
# deciding whether to start or restart.
exists_mysql=`service mysql status`
if [ "mysql stop/waiting" == "$exists_mysql" ]
then
    service mysql start
else
    service mysql restart
fi

# Setup mysql by importing an init file that creates necessary
# users and databases that our vagrant setup relies on.
echo "Initializing MySQL"
mysql -u root -pblank < /srv/database/init.sql

# WP-CLI Install
if [ ! -d /srv/www/wp-cli ]
then
    echo "Installing wp-cli"
    git clone git://github.com/wp-cli/wp-cli.git /srv/www/wp-cli > /dev/null
    cd /srv/www/wp-cli
    curl -sS https://getcomposer.org/installer | php > /dev/null
    php composer.phar install > /dev/null
fi
# Link wp to the /usr/local/bin directory
ln -sf /srv/www/wp-cli/bin/wp /usr/local/bin/wp

if [ ! -d /srv/www/wp-admin ]
then
    echo "Installing Wordpress"
    cd /srv/www
    curl -sS http://wordpress.org/latest.tar.gz | tar zx
    mv wordpress/* ./
    rm -rf wordpress
    cp /srv/config/wp-config-sample.php /srv/www
    wp core config --dbname=wp --dbuser=wp --dbpass=wp --quiet
    wp core install --url="$DEV_HOST" --quiet --title="WordPress Dev" --admin_name=wp --admin_email="admin@$DEV_HOST" --admin_password="wp"
    mysql -uroot -pblank < /srv/database/wp_pub_fix.sql

    echo "Installing Debug Bar"
    wp plugin install debug-bar --activate > /dev/null

    echo "Installing Debug Bar Console"
    wp plugin install debug-bar-console --activate > /dev/null

    echo "Installing Bones"
    git clone git://github.com/eddiemachado/bones.git /srv/www/wp-content/themes/$WP_THEME_NAME > /dev/null
    wp theme activate $WP_THEME_NAME > /dev/null
fi

# Your host IP is set in Vagrantfile, but it's nice to see the interfaces anyway.
# Enter domains space delimited
DOMAINS="$DEV_HOST"
if ! grep -q "$DOMAINS" /etc/hosts
then echo "127.0.0.1 $DOMAINS" >> /etc/hosts
fi

# Your host IP is set in Vagrantfile, but it's nice to see the interfaces anyway
ifconfig | grep "inet addr"
echo $start_time
date
printf "\nAll done!\n"
printf "Be sure to add \`$DEV_IP $DEV_HOST\` to your /etc/hosts\n\n"
