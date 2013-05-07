# Posner

A pretty basic Vagrant box running the following:

* LEMP stack
    * Ubuntu 12.04 LTS 32-bit
    * nginx
    * MySQL
    * PHP
* WordPress

In addition, the following features are planned (Soon&trade;):
* [HTML5 Boilerplate](http://html5boilerplate.com/)
* [Roots Theme](http://rootstheme.com)

## Let's get started

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and
    [Vagrant](http://downloads.vagrantup.com/).
2. `git clone git://github.com/boaf/posner.git new-wp-project`
3. `cd new-wp-project`
4. _(optional)_ Modify `devhost` at the top of `Vagrantfile` for a custom hostname
5. `vagrant up`
6. Add `10.10.10.10 dev.local` to your `/etc/hosts` file (location may vary)
7. Visit `http://dev.local/` (or your custom `devhost`) in yo browser.

## Some things

Posner will set up an IP address of `10.10.10.10`. If you need to change this,
do so in the `Vagrantfile` and ensure you've got your hosts file set up with the
new IP as well.

The following sets of paths are for convenience:
* `setup/database/` .. maps to .. `/srv/database/`
* `setup/config/` » `/srv/config/`
* `nginx-logs/` » `/srv/logs/`
* `www/` » `/srv/www/`

For an example of how this might be useful

```bash
# Scenario: The vagrant is already online and you want to change something in
# nginx.conf without having to SSH into the vagrant and dig around.
# Solution: Enter the following in your vagrant's folder (wherever you cloned
# this repo)
$ vi setup/config/nginx.conf # Edit something, then save
$ vagrant reload # Vagrant will pull your modified nginx.conf for the server
```

### MySQL
* Within the Vagrant box
    * User: *root*
    * Password: *blank* (as in the word)
* Externally, without an SSH tunnel
    * User: *external*
    * Password: *external*
    * Host: *dev.local* (or your defined `devhost`)
* WP
    * DB: *wordpress*
    * User: *wp*
    * Password: *wp*
    * Admin User: *admin*
    * Admin Password: *password*

## When you're finished for the day

`vagrant halt` (bring it back up with `vagrant up`)

## Some other things

It's possible to garner a pretty large list of running VMs if you remove
directories without first running `vagrant destroy`, so it's a good idea to
sometimes run `vboxmanage list vms` or `vboxmanage list runningvms` to see where
you're at. Again, keep in mind that your VMs will not be removed until you run
`vagrant destroy` (in the vagrant working directory) or manually delete the VM
from VirtualBox (former method preferred).

## Thanks

Thanks to the folks at 10up, for providing
[Varying Vagrant Vagrants](https://github.com/10up/varying-vagrant-vagrants)
(most of which this repo is based on). No copyright infringement intended!
