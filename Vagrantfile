$script = <<-SCRIPT

echo "cd /vagrant" >> /home/vagrant/.profile
echo "All good!!"
SCRIPT

Vagrant.configure("2") do |config|

    # hyperv (Windows 10 Pro)  and   VirtualBox (Windows 10 Home)
    # Ubuntu 64 bit
    config.vm.box = "bento/ubuntu-16.04"

    config.ssh.username = 'vagrant'
    config.ssh.password = 'vagrant'
    config.ssh.insert_key = 'true'

    # Ports foward
    # For SSH
    # config.vm.network "forwarded_port", guest: 2222, host: 2222
    # For playground
    config.vm.network "forwarded_port", guest: 8080, host: 8080
    # For REST Server
    config.vm.network "forwarded_port", guest: 3000, host: 3000
    # For Docker Deamon
    config.vm.network "forwarded_port", guest: 2375, host: 2375
    # For Orderer Container
    config.vm.network "forwarded_port", guest: 7050, host: 7050

    # For Peer Container
    config.vm.network "forwarded_port", guest: 7051, host: 7051
    # For Peer Container
    config.vm.network "forwarded_port", guest: 7052, host: 7052
    # For Peer Container
    config.vm.network "forwarded_port", guest: 7053, host: 7053
    # For Peer Container
    config.vm.network "forwarded_port", guest: 7054, host: 7054
    # For Peer Container
    config.vm.network "forwarded_port", guest: 7055, host: 7055
    # For Peer Container
    config.vm.network "forwarded_port", guest: 7056, host: 7056
    # For Peer Container
    config.vm.network "forwarded_port", guest: 7057, host: 7057
    # For Peer Container
    config.vm.network "forwarded_port", guest: 7058, host: 7058
    # For Peer Container
    config.vm.network "forwarded_port", guest: 7059, host: 7059
    # For Peer Container
    config.vm.network "forwarded_port", guest: 7060, host: 7060
    # For Peer Container
    config.vm.network "forwarded_port", guest: 7061, host: 7061
    # For Peer Container
    config.vm.network "forwarded_port", guest: 7062, host: 7062

    # For Peer Container
    config.vm.network "forwarded_port", guest: 8051, host: 8051
    # For Peer Container
    config.vm.network "forwarded_port", guest: 8052, host: 8052
    # For Peer Container
    config.vm.network "forwarded_port", guest: 8053, host: 8053
    # For Peer Container
    config.vm.network "forwarded_port", guest: 8054, host: 8054
    # For Peer Container
    config.vm.network "forwarded_port", guest: 8055, host: 8055
    # For Peer Container
    config.vm.network "forwarded_port", guest: 8056, host: 8056
    # For Peer Container
    config.vm.network "forwarded_port", guest: 8057, host: 8057
    # For Peer Container
    config.vm.network "forwarded_port", guest: 8058, host: 8058
    # For Peer Container
    config.vm.network "forwarded_port", guest: 8059, host: 8059
    # For Peer Container
    config.vm.network "forwarded_port", guest: 8060, host: 8060
    # For Peer Container
    config.vm.network "forwarded_port", guest: 8061, host: 8061
    # For Peer Container
    config.vm.network "forwarded_port", guest: 8062, host: 8062

    #Microservice Endpoint 1
    config.vm.network "forwarded_port", guest: 4500, host: 4500
    #Microservice Endpoint 2
    config.vm.network "forwarded_port", guest: 2397, host: 2397
    #Microservice Endpoint 3
    config.vm.network "forwarded_port", guest: 65023, host: 65023
    #Microservice Endpoint 4
    config.vm.network "forwarded_port", guest: 11053, host: 11053

    # For Redis Cluster
    config.vm.network "forwarded_port", guest: 11454, host: 11454

    # For CA Container
    config.vm.network "forwarded_port", guest: 7085, host: 7085
    
    # For CouchDB Container
    config.vm.network "forwarded_port", guest: 5984, host: 5984

    # Zookeeper
    config.vm.network "forwarded_port", guest: 2181, host: 2181

    # For Kafka Broker
    config.vm.network "forwarded_port", guest: 9092, host: 9092

    # For Kafka Manager
    config.vm.network "forwarded_port", guest: 9000, host: 9000

    # This gets executed for both vm1 & vm2
    # config.vm.provision "shell", inline:  "echo 'All good'"
    config.vm.provision "shell", inline:  $script
  
    # To use a diffrent Hypervisor create a section config.vm.provider
    # And comment out the following section
    # Configuration for Virtual Box
    config.vm.provider :virtualbox do |vb|
      # Change the memory here if needed - 2 Gb memory on Virtual Box VM
      # vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "1"]
      vb.customize ["modifyvm", :id, "--memory", "8192", "--cpus", "4"]
      # Change this only if you need destop for Ubuntu - you will need more memory
      vb.gui = false
      # In case you have DNS issues
      # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    # Configuration for Windows Hyperv
    config.vm.provider :hyperv do |hv|
      # Change the memory here if needed - 2 Gb memory on Virtual Box VM
      # hv.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "1"]
      hv.customize ["modifyvm", :id, "--memory", "8192", "--cpus", "4"]
      # Change this only if you need destop for Ubuntu - you will need more memory
      hv.gui = false
      # In case you have DNS issues
      # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end