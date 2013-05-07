# Posner

A pretty basic Vagrant box running the following:

* LEMP stack
  * Ubuntu 12.04 LTS 32-bit
  * nginx
  * MySQL
  * PHP
* WordPress

In addition, the following features are planned (Soon&trade;):
* [HTML5 Boilerplate][http://html5boilerplate.com/]
* [Roots Theme][http://rootstheme.com]

## Let's get started

1. Install [VirtualBox][https://www.virtualbox.org/wiki/Downloads] and [Vagrant][http://downloads.vagrantup.com/].
2. `git clone git://github.com/boaf/posner.git new-wp-project && cd new-wp-project`
3. (optional) Modify `devhost` at the top of `Vagrantfile` for a custom hostname
4. `vagrant up`
5. Add `10.10.10.10 dev.local` to your `/etc/hosts` file (location may vary)
6. Visit `http://dev.local/` (or your custom `devhost`, if specified) in yo browser.

## When you're finished for the day

`vagrant halt` (bring it back up with `vagrant up`)

## Some other things

It's possible to garner a pretty large list of running VMs if you remove directories without first running `vagrant destroy`, so it's a good idea to sometimes run `vboxmanage list vms` or `vboxmanage list runningvms` to see where you're at. Again, keep in mind that your VMs will not be removed until you run `vagrant destroy` (in the vagrant working directory) or manually delete the VM from VirtualBox (former method preferred).

## Thanks

Thanks to the folks at 10up, for providing [Varying Vagrant Vagrants][https://github.com/10up/varying-vagrant/vagrants] (most of which this repo is based on). No copyright infringement intended!
