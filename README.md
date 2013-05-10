# Posner

A pretty basic Vagrant box running the following:

* LEMP stack
    * Ubuntu 12.04 LTS 32-bit
    * nginx
    * MySQL
    * PHP
* WordPress
    * [Bones](https://github.com/eddiemachado/bones)
    * Debug Bar (w/ Debug Bar Console)


## Let's get started

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and
    [Vagrant](http://downloads.vagrantup.com/).
2. `git clone git://github.com/boaf/posner.git && cd posner`
3. `vagrant up`
4. Add `10.10.10.10 dev.local` to `/etc/hosts`
5. Visit `http://dev.local/` in yo browser to make sure everything works

## Configuration

There isn't much, but available within `Vagrantfile` are...

<table>
    <tr>
        <th>Name</th><th>Default</th><th>?</th>
    </tr>
    <tr>
        <td>dev_host</td>
        <td>dev.local</td>
        <td>Local-accessible URL<br>Must be entered in /etc/hosts</td>
    </tr>
    <tr>
        <td>dev_ip</td>
        <td>10.10.10.10</td>
        <td>Local-accessible IP address<br>Good Idea&trade; to change this and dev_host if running multiple Vagrants</td>
    </tr>
    <tr>
        <td>wp_theme_name</td>
        <td>wpdev</td>
        <td>Theme dir name<br>i.e. wp-content/themes/wpdev</td>
    </tr>
</table>

## Some things

The WordPress installation by default will be in **private mode**. That is to
say that the option `Discourage search engines from indexing this site` within
Settings › Reading is checked.

The following paths are linked between your local machine and the vagrant for
convenience:

<table>
    <tr><th>Local path</th><th>Vagrant path</th></tr>
    <tr><td>setup/database/</td><td>/srv/database/</td></tr>
    <tr><td>setup/config/</td><td>/srv/config/</td></tr>
    <tr><td>nginx-logs/</td><td>/srv/logs/</td></tr>
    <tr><td>www/</td><td>/srv/www/</td></tr>
</table>

### MySQL
* Within the Vagrant box
    * User: **root**
    * Password: **blank** (as in the word)
* Externally, without an SSH tunnel
    * User: **external**
    * Password: **external**
    * Host: **dev.local**
* WP
    * DB: **wp**
    * User: **wp**
    * Password: **wp**
    * Admin User: **wp**
    * Admin Password: **wp** _(yes, everything is "wp")_

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
$ git add remote origin master repo://to/your/kickass-theme
$ git add .
$ git commit -m "lookit dis kickass theme, aw yisssss"
$ git push

prod$ cd /var/www/blog/wp-content/themes
prod$ git clone repo://to/your/kickass-theme

# BAM you're done

```
