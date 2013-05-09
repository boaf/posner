# Posner

A pretty basic Vagrant box running the following:

* LEMP stack
    * Ubuntu 12.04 LTS 32-bit
    * nginx
    * MySQL
    * PHP
* WordPress
    * [Roots Theme](http://rootstheme.com)
    * [HTML5 Boilerplate](http://html5boilerplate.com/)

## Let's get started

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and
    [Vagrant](http://downloads.vagrantup.com/).
2. `git clone git://github.com/boaf/posner.git && cd posner`
3. `vagrant up`
4. Add `10.10.10.10 dev.local` to `/etc/hosts`
5. Visit `http://dev.local/` in yo browser to make sure everything works

To start developing a theme, Activate the Roots theme in Wordpress.

## Configuration

There isn't much, but these are available at the top of `Vagrantfile` for your
enjoyment.

<table>
    <tr>
        <th>Name</th><th>Default</th><th>?</th>
    </tr>
    <tr>
        <td>`dev_host`</td>
        <td>`dev.local`</td>
        <td>Local-accessible URL<br>Must be entered in `/etc/hosts`</td>
    </tr>
    <tr>
        <td>`dev_ip`</td>
        <td>`10.10.10.10`</td>
        <td>Local-accessible IP address</td>
    </tr>
    <tr>
        <td>`wp_theme_name`</td>
        <td>`roots`</td>
        <td>Theme dir name<br>i.e. `wp-content/themes/roots`</td>
    </tr>
</table>

In addition, Roots provides a number of configuration options. See
[Roots' documentation](https://github.com/retlehs/roots/blob/master/doc/TOC.md)
for more details.

## Some things

The following sets of paths are for convenience:
* `setup/database/` .. maps to .. `/srv/database/`
* `setup/config/` » `/srv/config/`
* `nginx-logs/` » `/srv/logs/`
* `www/` » `/srv/www/`

### MySQL
* Within the Vagrant box
    * User: *root*
    * Password: *blank* (as in the word)
* Externally, without an SSH tunnel
    * User: *external*
    * Password: *external*
    * Host: *dev.local* (or your defined `devhost`)
* WP
    * DB: *wp*
    * User: *wp*
    * Password: *wp*
    * Admin User: *wp*
    * Admin Password: *wp* _(yes, everything is "wp")_

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

## Final thoughts

The intended workflow with this setup is basically like so:

```bash
# $ = your local dev machine
# prod$ = production server

$ git clone git://github.com/boaf/posner.git
$ cd posner
$ rm -rf .git* # Kill all pieces of git
$ vagrant up
$ cd www/wp-content/themes/kickass-theme
$ vi index.php # Do work...

# Let's say at this point you're ready to go live
# Recalling that we're in www/wp-content/kickass-theme

$ git init
$ git add remote origin master git://your/repo/kickass-theme
$ git add .
$ git commit -m "lookit dis kickass theme, aw yisssss"
$ git push

prod$ cd /var/www/blog/wp-content/themes
prod$ git clone git://your/repo/kickass-theme

# BAM you're done

```
