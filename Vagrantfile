VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if ENV["BF_ACCEPT"] == 'true'
    config.vm.box = "chef/centos-7.1"
    config.vm.network "forwarded_port", guest: 80, host: 4000

    config.vbguest.auto_update = false

    config.vm.provision "shell" do |s|
      s.path = "scripts/vagrant-provision.sh"
      ARGS = ENV["DOCKER_EMAIL"] + ' ' + ENV["DOCKER_USERNAME"] \
        + ' ' + ENV["DOCKER_PASSWORD"]
      s.args = ARGS
    end
  end
end
