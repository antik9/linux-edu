# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['OTUS_VAGRANT_HOME']


MACHINES = {
    :webserver => {
        :box_name => "centos/7",
        :box_version => "1809.01",
        :ip_addr => '192.168.11.101',
    },
    :logserver => {
        :box_name => "centos/7",
        :box_version => "1809.01",
        :ip_addr => '192.168.11.102',
    },
}

Vagrant.configure("2") do |config|

    config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
    config.vm.network "forwarded_port", guest: 5601, host: 5601, auto_correct: true

    MACHINES.each do |boxname, boxconfig|

        config.vm.define boxname do |box|

            box.vm.box = boxconfig[:box_name]
            box.vm.host_name = boxname.to_s

            box.vm.network "private_network", ip: boxconfig[:ip_addr]

            box.vm.provider :virtualbox do |vb|
                # vb.cpus = (boxname.to_s.match(/^log/)) ? 2 : 1;
                # vb.memory = (boxname.to_s.match(/^log/)) ? 2048 : 256;
                vb.cpus = 1
                vb.memory = 256
            end

            box.vm.provision "shell", inline: <<-SHELL
                mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/auth* ~root/.ssh
            SHELL

            config.vm.provision "ansible" do |ansible|
                ansible.verbose = '-vv'
                ansible.playbook = "#{boxname.to_s}.yml"
            end

        end
    end
end
