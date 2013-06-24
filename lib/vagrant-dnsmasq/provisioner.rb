module Vagrant
  module Dnsmasq
    class Provisioner < Vagrant.plugin("2", :provisioner)
      
      def provision
        puts "hello world"
      end
    end
  end
end
