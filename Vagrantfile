dir = Dir.pwd

Vagrant.configure("2") do |config|

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 512]
  end

  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.hostname = "precise32"
  config.vm.network :private_network, ip: "10.10.10.10"

  config.vm.synced_folder "setup/database/", "/srv/database"

  config.vm.synced_folder "setup/config/", "/srv/config"
  
  config.vm.synced_folder "nginx-logs/", "/srv/logs"
  
  config.vm.synced_folder "www/", "/srv/www/", :owner => "www-data", :extra => 'dmode=775,fmode=774'

  config.vm.provision :shell, :path => File.join( "setup", "setup.sh" )

end
