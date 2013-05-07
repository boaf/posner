# Posner

A pretty basic Vagrant box running the following:

* LEMP stack ([nginx][1])
* [WordPress][2]
* [HTML5 Boilerplate][3]
* [Roots Theme][4]

## Let's get started

1. Install [VirtualBox][5] and [Vagrant][6].

2. `$ git clone https://boaf@bitbucket.org/boaf/posner.git my-sweetass-site`

3. `$ cd my-sweetass-site`
    a. OPTIONAL: Modify `devhost` at the top of `Vagrantfile` for custom hostname

4. `$ vagrant up`

5. Add `10.10.10.10 dev.local` to your `/etc/hosts` file (location may vary)

6. Visit `http://dev.local/` (or your custom `devhost`, if specified) in yo browser.

## When you're finished for the day

`$ vagrant halt` (bring it back up with `vagrant up`)

## Thanks

Thanks to the folks at 10up, for providing [Varying Vagrant Vagrants][7] (most of which this repo is based on). No copyright infringement intended!

[1]: http://nginx.org/ "nginx"
[2]: http://wordpress.org/ "WordPress"
[3]: http://html5boilerplate.com/ "HTML5 Boilerplate"
[4]: http://rootstheme.com/ "Roots WordPress Theme"
[5]: https://www.virtualbox.org/wiki/Downloads "VirtualBox"
[6]: http://downloads.vagrantup.com "Vagrant"
[7]: https://github.com/10up/varying-vagrant-vagrants "Varying Vagrant Vagrants"
