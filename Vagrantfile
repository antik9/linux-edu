# -*- mode: ruby -*-
# vim: set ft=ruby :
HOME = ENV['OTUS_VAGRANT_HOME']
EXTRA_VARS = {
    MASTER_IP: "10.10.0.1",
}

MACHINES = {
    "master": {
        :box_name => "centos/7",
        :net => [
            {
                ip: EXTRA_VARS[:MASTER_IP],
                adapter: 2,
            },
        ]
    },
}


Vagrant.configure("2") do |config|

    MACHINES.each do |boxname, boxconfig|

        config.vm.define boxname do |box|

            box.vm.box = boxconfig[:box_name]
            box.vm.box_version = boxconfig[:box_version]

            box.vm.host_name = boxname.to_s

            box.vm.network "forwarded_port", guest: 25, host: 2525, auto_correct: true
            box.vm.network "forwarded_port", guest: 110, host: 2110, auto_correct: true

            box.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", "256"]
            end

            box.vm.provision "shell", inline: <<-SHELL
                mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/auth* ~root/.ssh
                [ -e /tmp/id_rsa ] && mv /tmp/id_rsa ~root/.ssh
                echo "alias vim=vi" >> /etc/bashrc

                yum install -y postfix dovecot telnet policycoreutils-python

                useradd vmail -m -s /usr/sbin/nologin
                cp /vagrant/configs/main.cf /etc/postfix/
                cp /vagrant/configs/dovecot.conf /etc/dovecot
                /vagrant/configs/user_add.sh vagrant vagrant
                postmap /etc/postfix/virtual
                semodule -i /vagrant/configs/more_postfix.pp

                systemctl enable postfix dovecot
                systemctl start dovecot
                systemctl restart postfix
            SHELL

        end
    end
end
