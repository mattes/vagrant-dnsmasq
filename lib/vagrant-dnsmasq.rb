require "pathname"
require "vagrant-dnsmasq/version"

module Vagrant
  module Dnsmasq
    lib_path = Pathname.new(File.expand_path("../vagrant-dnsmasq", __FILE__))

    class Plugin < Vagrant.plugin("2")
      name "dnsmasq"

      command "dns" do
        require lib_path.join("command")
        Command
      end

    end
  end
end
