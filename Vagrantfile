VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if ENV["BF_ACCEPT"] == 'true'

    # allow specification of base box
    VM_BOX=ENV["VM_BOX"] || "bento/centos-7.1"
    config.vm.box = VM_BOX

    config.vm.provider "virtualbox" do |v, override|
      v.customize ["modifyvm", :id, "--cpus", 2]
      # base box hasn't enough memory for DB2
      v.customize ["modifyvm", :id, "--memory", 4096]
    end

    unless ENV["BES_PORTS"] == 'false'
      config.vm.network :forwarded_port, guest: 52311, host: 52311
      config.vm.network :forwarded_port, guest: 80, host: 9080
      config.vm.network :forwarded_port, guest: 8080, host: 8080
    end

    # put box on the Virtualbox private network when OHANA is set
    OHANA=ENV["OHANA"] || false
    if OHANA
      config.vm.network :private_network, type: "dhcp"
    end

    # optionally turn off vbguest, place inside this test to stop it throwing
    # error if vbguest gem is not installed
    if ENV["VBGUEST_AUTO"] == 'false'
      config.vbguest.auto_update = ENV["VBGUEST_AUTO"]
    end

    config.vm.provision "common" , type: "shell" do |c|
        c.path = "./scripts/vagrant-provision-common.sh"
    end

    # using provisioner names only works with vagrant provsion and
    # doesn't work with vagrant up.
    #https://github.com/mitchellh/vagrant/issues/5139
    # So control what type of bes server is built using environment.
    config.vm.provision "besserver", type: "shell" do |s|
      # default to evaluation edition
      if ENV["BES_CONFIG"] == 'remdb'
        s.path = "./scripts/vagrant-provision-remdb.sh"
      else
        s.path = "./scripts/vagrant-provision-svr.sh"
        ARGS = ENV["BES_VERSION"]
        s.args = ARGS
      end
    end
  end
end
