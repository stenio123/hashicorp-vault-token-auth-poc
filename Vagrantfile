# Hashicorp Vault + Client VM
#
# Both rely on shell scripts in respective folders for provisioning.
#
# NOTE: Make sure you have the centos/7 base box installed...
# vagrant box add centos/7

Vagrant.configure("2") do |config|
  [
    ["vault", "192.168.0.50", "HashicorpVault/install-vault.sh"],
    ["client", "192.168.0.51", "ClientVM/install-clientvm.sh"]
  ].each do |name, ip, script|
    config.vm.define name do |vault|
      vault.vm.box = "centos/7"
      vault.vm.hostname = "#{name}.centos.box"
      vault.vm.network "private_network", ip: ip
      vault.vm.provider :virtualbox do |vb|
        vb.memory = 256
      end
      vault.vm.provision "shell" do |s|
        s.path = script
      end
    end
  end
end
