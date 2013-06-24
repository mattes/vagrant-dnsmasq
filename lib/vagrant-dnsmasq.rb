require "vagrant-dnsmasq/actions"

module Vagrant
  module Dnsmasq
    class Plugin < Vagrant.plugin("2")
      name "vagrant-dnsmasq"

      config "dnsmasq" do
        require "vagrant-dnsmasq/config"
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
