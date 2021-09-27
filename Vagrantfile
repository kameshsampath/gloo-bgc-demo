# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "#{ ENV['VAGRANT_BOX'] || 'fedora/34-cloud-base' }"

  config.vm.network "public_network",
     bridge: [
       "en0: Wi-Fi (Wireless)",
       "en7: Belkin USB-C LAN"
     ],
     use_dhcp_assigned_default_route: true
 
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.cpus = 2
    vb.memory = "4096"
    vb.customize [ “guestproperty”, “set”, :id, “/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold”, 10000 ]
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
    config.vbguest.no_remote = true
  end

  # delete default router
  config.vm.provision "shell",
  run: "always",
  inline: "ip route del default via 10.0.2.2 || true"

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.vault_password_file = '.password_file'
    ansible.tags = [ "base" ]
  end
  
end
