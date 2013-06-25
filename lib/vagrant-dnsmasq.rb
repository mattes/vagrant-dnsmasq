module Vagrant
  module Dnsmasq
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end

    I18n.load_path << File.expand_path('locales/en.yml', source_root)
    I18n.reload!

    class Plugin < Vagrant.plugin("2")
      name "vagrant-dnsmasq"

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