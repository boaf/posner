# Posner

A pretty basic Vagrant box running with the following:

* LEMP stack ([nginx](http://nginx.org/))
* [WordPress](http://wordpress.org/)
* [HTML5 Boilerplate](http://html5boilerplate.com/)
* [Roots Theme](http://www.rootstheme.com/)

## Let's get started

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://downloads.vagrantup.com).

2. `$ git clone https://boaf@bitbucket.org/boaf/posner.git my-sweetass-site && cd my-sweetass-site`

3. `$ vagrant up`

4. Add `10.10.10.10 dev.local` to your `/etc/hosts` file (location may vary)

5. Visit `http://dev.local/` in yo browser.

## When you're finished for the day

`$ vagrant halt` (bring it back up with `vagrant up`)

## Thanks

Thanks to the folks at 10up, for providing [Varying Vagrant Vagrants](https://github.com/10up/varying-vagrant-vagrants) (most of which this repo is based on). No copyright infringement intended!
