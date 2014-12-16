# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"




Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  #monitoring
  config.vm.define "monitoring" do |monitoring|
    monitoring.vm.provider "virtualbox" do |v|
      v.name = "monitoring"
    end
    monitoring.vm.box = "TODO create box"

  
    #influxdb
    monitoring.vm.network "forwarded_port", :guest => 8083, :host => 8083
    monitoring.vm.network "forwarded_port", :guest => 8090, :host => 8090
    monitoring.vm.network "forwarded_port", :guest => 8099, :host => 8099
    monitoring.vm.network "forwarded_port", :guest => 8086, :host => 8086

    
    #graphite
    monitoring.vm.network "forwarded_port", :guest => 2003, :host => 2003
    
    #statd
    monitoring.vm.network "forwarded_port", :guest => 8125, :host => 8125 , protocol: "udp"

    #grafana
    monitoring.vm.network "forwarded_port", :guest => 8080, :host => 8080
    monitoring.vm.synced_folder "box/", "/tmp/monitoring"


    monitoring.vm.provision "shell", path: "box/monitoring.sh"
  

  end
end
