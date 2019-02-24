# -*- mode: ruby -*-
# vim: set ft=ruby :
HOME = ENV['OTUS_VAGRANT_HOME']
EXTRA_VARS = {
    NFS_SERVER_IP: "10.10.0.1",
    NFS_CLIENT_IP: "10.10.0.2",
    KERBEROS_IP: "10.10.0.3",
    KERBEROS_FOLDER: "/opt/nfs_share",
    NFS_SERVER_FOLDER: "/opt/nfs_share",
    KERBEROS_HOST: "kbserver.example.com",
    CLIENT_HOST: "kbclient.example.com",
    VAGRANT_PASS: "CHMyxOEW1iIYFS4Q",
}


MACHINES = {
    "server": {
        :box_name => "centos/7",
        :net => [
            {
                virtualbox__intnet: "router-net",
                adapter: 2,
                ip: EXTRA_VARS[:NFS_SERVER_IP],
                netmask: "255.255.255.248",
            },
        ]
    },
    "client": {
        :box_name => "centos/7",
        :net => [
            {
                virtualbox__intnet: "router-net",
                adapter: 2,
                ip: EXTRA_VARS[:NFS_CLIENT_IP],
                netmask: "255.255.255.248",
            },
        ]
    },
    "kerberos": {
        :box_name => "centos/7",
        :net => [
            {
                virtualbox__intnet: "router-net",
                adapter: 2,
                ip: EXTRA_VARS[:KERBEROS_IP],
                netmask: "255.255.255.248",
            },
        ],
    },
}

Vagrant.configure("2") do |config|

    MACHINES.each do |boxname, boxconfig|

        config.vm.define boxname do |box|

            box.vm.box = boxconfig[:box_name]
            box.vm.box_version = boxconfig[:box_version]

            box.vm.host_name = boxname.to_s

            boxconfig[:net].each do |ipconf|
                box.vm.network "private_network", ipconf
            end

            box.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", "256"]
            end

            box.vm.provision "shell", inline: <<-SHELL
                mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/auth* ~root/.ssh
                echo "alias vim=vi" >> /etc/bashrc
            SHELL


            box.vm.provision "ansible" do |ansible|
                ansible.verbose = '-vv'
                ansible.playbook = "#{boxname.to_s}.yml"
                ansible.extra_vars = EXTRA_VARS
            end
        end
    end
end
