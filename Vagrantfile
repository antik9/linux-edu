# -*- mode: ruby -*-
# vim: set ft=ruby :
HOME = ENV['OTUS_VAGRANT_HOME']
FORWARD_PORT = 8080

MACHINES = {
    "nginx": {
        :box_name => "centos/7",
        :ip_addr => '10.10.0.1',
    },
}

Vagrant.configure("2") do |config|

    MACHINES.each do |boxname, boxconfig|

        config.vm.define boxname do |box|

            box.vm.box = boxconfig[:box_name]
            box.vm.box_version = boxconfig[:box_version]

            box.vm.host_name = boxname.to_s

            box.vm.network "private_network", ip: boxconfig[:ip_addr]
            box.vm.network "forwarded_port", guest: 80, host: FORWARD_PORT, auto_correct: true

            box.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", "256"]
            end

            box.vm.provision "shell", inline: <<-SHELL
                mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/auth* ~root/.ssh
                echo "alias vim=vi" >> /etc/bashrc
            SHELL

            config.vm.provision "ansible" do |ansible|
                ansible.playbook = "playbook.yml"
                ansible.extra_vars = {
                    "FORWARD_PORT": FORWARD_PORT,
                }
            end

        end
    end
end
