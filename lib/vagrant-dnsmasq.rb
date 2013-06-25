module Vagrant
  module Dnsmasq
    class Plugin < Vagrant.plugin("2")
      name "vagrant-dnsmasq"
      desc "A Dnsmasq Vagrant plugin that manages the dnsmasq.conf file and /etc/resolver directory on your host system."

      lib_path = Pathname.new(File.expand_path("../vagrant-dnsmasq", __FILE__))
      require lib_path.join("actions")

      inc_path = Pathname.new(File.expand_path("../vagrant-dnsmasq/includes", __FILE__))
      require inc_path.join("Domain.class.rb")
      require inc_path.join("Ip.class.rb")
      require inc_path.join("DnsmasqConf.class.rb")
      require inc_path.join("Resolver.class.rb")
      require inc_path.join("helper.rb")

      config "dnsmasq" do
        require lib_path.join("config")
        Config
      end

      action_hook(:dnsmasq, :machine_action_up) do |hook|
        hook.append(Vagrant::Action::Up)
      end

      action_hook(:dnsmasq, :machine_action_destroy) do |hook|
        hook.append(Vagrant::Action::Destroy)
      end

    end
  end

end