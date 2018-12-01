# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['OTUS_VAGRANT_HOME']


MACHINES = {
    :otuslinux11ansible => {
        :box_name => "centos/7",
        :box_version => "1804.02",
        :ip_addr => '192.168.11.101',
  },
}

Vagrant.configure("2") do |config|

    MACHINES.each do |boxname, boxconfig|

        config.vm.define boxname do |box|

            box.vm.box = boxconfig[:box_name]
            box.vm.box_version = boxconfig[:box_version]

            box.vm.host_name = boxname.to_s

            box.vm.network "private_network", ip: boxconfig[:ip_addr]

            box.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id,
                              "--memory", "200"]
                vb.customize ["storagectl", :id,
                              "--name", "SATA",
                              "--add", "sata" ]
                vb.name = boxname.to_s

            end

            box.vm.provision "shell", inline: <<-SHELL
                mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/auth* ~root/.ssh
            SHELL

            config.vm.provision "ansible" do |ansible|
                ansible.playbook = "playbook.yml"
            end

        end
    end
end
