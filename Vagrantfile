Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.provision :shell, :path => "provision/setup.sh"
  config.vm.network :forwarded_port, host: 8888, guest: 80
end
