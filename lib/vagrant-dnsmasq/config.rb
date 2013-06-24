module Vagrant
  module Dnsmasq
    class Config < Vagrant.plugin("2", :config)
      
      attr_accessor :domain
      attr_accessor :ip

      def initialize
        @domain = UNSET_VALUE
        @ip = UNSET_VALUE
      end

      def finalize!
        @domain = nil if @domain == UNSET_VALUE
        @ip = nil if @ip == UNSET_VALUE
      end

    end
  end
end
