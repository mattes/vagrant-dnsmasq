module Vagrant
  module Dnsmasq
    class Config < Vagrant.plugin("2", :config)
      
      attr_accessor :enable
      attr_accessor :domain
      attr_accessor :ip

      alias_method :enabled?, :enable

      def initialize
        @enable = UNSET_VALUE
        @domain = UNSET_VALUE
        @ip = UNSET_VALUE
      end

      def finalize!
        @enable = false if @enable == UNSET_VALUE
        @domain = nil if @domain == UNSET_VALUE
        @ip = nil if @ip == UNSET_VALUE
      end

    end
  end
end
