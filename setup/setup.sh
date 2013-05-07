DEVHOSTNAME=$1
start_time=`date`

if [ -f /vagrant/setup/initial_provision_run ]
then
    printf "\nSkipping package installation, not initial boot...\n\n"
else
    # Add any custom package sources to help install more current software
    cat /srv/config/apt-source-append.list >> /etc/apt/sources.list

    # update all of the package references before installing anything
    printf "Running apt-get update....\n\n"
    apt-get update --force-yes -y

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

    printf "Install all apt-get packages...\n"
    apt-get install --force-yes -y ${apt_package_list[@]}

    # Clean up apt caches
    apt-get clean

    touch /vagrant/setup/initial_provision_run
fi

# SYMLINK HOST FILES
printf "\nLink Directories...\n"

# Configuration for nginx
ln -sf /srv/config/nginx.conf /etc/nginx/nginx.conf | echo "Linked nginx.conf to /etc/nginx/"

# Configuration for php5-fpm
ln -sf /srv/config/php5-fpm-config/www.conf /etc/php5/fpm/pool.d/www.conf | echo "Linked www.conf to /etc/php5/fpm/pool.d/"
ln -sf /srv/config/php5-fpm-config/php.ini /etc/php5/fpm/php.ini | echo "Linked php.ini to /etc/php5/fpm/"

# Configuration for mysql
cp /srv/config/mysql-config/my.cnf /etc/mysql/my.cnf | echo "Linked my.cnf to /etc/mysql/"

# Custom bash_profile for our vagrant user
ln -sf /srv/config/bash_profile /home/vagrant/.bash_profile | echo "Linked .bash_profile to vagrant user's home directory..."

# Custom bash_aliases included by vagrant user's .bashrc
ln -sf /srv/config/bash_aliases /home/vagrant/.bash_aliases | echo "Linked .bash_aliases to vagrant user's home directory..."

# Custom vim configuration via .vimrc
ln -sf /srv/config/vimrc /home/vagrant/.vimrc | echo "Linked vim configuration to home directory..."

# RESTART SERVICES
#
# Make sure the services we expect to be running are running.
printf "\nRestart services...\n"
printf "\nservice nginx restart\n"
service nginx restart
printf "\nservice php5-fpm restart\n"
service php5-fpm restart

# mysql gives us an error if we restart a non running service, which
# happens after a `vagrant halt`. Check to see if it's running before
# deciding whether to start or restart.
exists_mysql=`service mysql status`
if [ "mysql stop/waiting" == "$exists_mysql" ]
then
    printf "\nservice mysql start"
    service mysql start
else
    printf "\nservice mysql restart"
    service mysql restart
fi

# # IMPORT SQL
# #
# # Create the databases (unique to system) that will be imported with
# # the mysqldump files located in database/backups/
# if [ -f /srv/database/init-custom.sql ]
# then
#     mysql -u root -pblank < /srv/database/init-custom.sql | printf "\nInitial custom mysql scripting...\n"
# else
#     printf "\nNo custom mysql scripting found in database/init-custom.sql, skipping...\n"
# fi

# Setup mysql by importing an init file that creates necessary
# users and databases that our vagrant setup relies on.
mysql -u root -pblank < /srv/database/init.sql | echo "Initial mysql prep...."

# WP-CLI Install
if [ ! -d /srv/www/wp-cli ]
then
    printf "\nDownloading wp-cli.....http://wp-cli.org\n"
    git clone git://github.com/wp-cli/wp-cli.git /srv/www/wp-cli
    cd /srv/www/wp-cli
    curl -sS https://getcomposer.org/installer | php
    php composer.phar install
else
    printf "\nSkip wp-cli installation, already available\n"
fi
# Link wp to the /usr/local/bin directory
ln -sf /srv/www/wp-cli/bin/wp /usr/local/bin/wp

if [ ! -d /srv/www/wp-admin ]
then
    printf "Downloading WordPress.....http://wordpress.org\n"
    cd /srv/www
    curl -O http://wordpress.org/latest.tar.gz
    tar -xvf latest.tar.gz
    mv wordpress/* .
    rm -rf latest.tar.gz wordpress
    cp /srv/config/wordpress-config/wp-config-sample.php /srv/www
    printf "Configuring WordPress...\n"
    wp core config --dbname=wordpress --dbuser=wp --dbpass=wp --quiet
    wp core install --url=dev.local --quiet --title="WordPress Dev" --admin_name=admin --admin_email="admin@dev.local" --admin_password="password"
else
    printf "Skip WordPress installation, already available\n"
fi

# Your host IP is set in Vagrantfile, but it's nice to see the interfaces anyway.
# Enter domains space delimited
DOMAINS='dev.local'
if ! grep -q "$DOMAINS" /etc/hosts
then echo "127.0.0.1 $DOMAINS" >> /etc/hosts
fi

# Your host IP is set in Vagrantfile, but it's nice to see the interfaces anyway
ifconfig | grep "inet addr"
echo $start_time
date
echo All set!
echo
echo You can SQL in via the user \`external\`, no need to SSH tunnel.
echo
echo Also, please make sure you have added \`10.10.10.10 $DOMAINS\` to your /etc/hosts file:
