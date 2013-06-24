require "pathname"
require "vagrant-dnsmasq/version"

module Vagrant
  module Dnsmasq
    class Plugin < Vagrant.plugin("2")
      name "vagrant-dnsmasq"

      command "dnsmasq" do
        require "vagrant-dnsmasq/command"
        Command
      end

    end
  end
end
