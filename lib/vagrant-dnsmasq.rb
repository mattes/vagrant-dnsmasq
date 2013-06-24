require "vagrant-dnsmasq/version"

module Vagrant
  module Dnsmasq
    class Plugin < Vagrant.plugin("2")
      name "vagrant-dnsmasq"

      config "dnsmasq" do
        require_relative "vagrant-dnsmasq/config"
        Config
      end

      action_hook(:dnsmasq, :machine_action_up) do |hook|
        # hook.prepend(Action.update_all)
        puts "UP UP UP UP UP UP UP UP UP UP UP UPUP UP UP UP UP UP"
      end

      action_hook(:dnsmasq, :machine_action_destroy) do |hook|
        # hook.prepend(Action.update_all)
        puts "DESTROY DESTROY DESTROY DESTROY DESTROY DESTROY DESTROY "
      end

      command "dnsmasq" do
        require_relative "vagrant-dnsmasq/command"
        Command
      end

    end
  end
end
