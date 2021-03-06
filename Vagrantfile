dev_host = 'dev.local'
dev_ip = '10.10.10.10'
wp_theme_name = 'wpdev'

dir = File.expand_path(File.dirname(__FILE__))

Dir.chdir(dir) do
    Vagrant.configure('2') do |config|

        config.vm.provider :virtualbox do |v|
            v.customize ['modifyvm', :id, '--memory', 512]
        end

        config.vm.box = 'precise32'
        config.vm.box_url = 'http://files.vagrantup.com/precise32.box'

        config.vm.hostname = 'precise32'
        config.vm.network :private_network, ip: dev_ip

        config.vm.synced_folder 'setup/database/', '/srv/database'

        config.vm.synced_folder 'setup/config/', '/srv/config'

        if ! FileTest::directory?('nginx-logs')
            Dir::mkdir('nginx-logs')
        end
        config.vm.synced_folder 'nginx-logs/', '/srv/logs'

        if ! FileTest::directory?('www')
            Dir::mkdir('www')
        end
        config.vm.synced_folder 'www/', '/srv/www/',
            :owner => 'www-data',
            :extra => 'dmode=775,fmode=774'

        config.vm.provision :shell,
            :path => 'setup/setup.sh',
            :args => [dev_host, dev_ip, wp_theme_name].join(' ')

    end
end
