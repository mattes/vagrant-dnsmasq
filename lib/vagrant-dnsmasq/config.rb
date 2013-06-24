module Vagrant
  module Dnsmasq
    class Config < Vagrant.plugin("2", :config)
      
      attr_accessor :enable
      attr_accessor :domain
      attr_accessor :ip

      alias_method :enabled?, :enable

      def initialize
        inc_path = Pathname.new(File.expand_path("../includes", __FILE__))
        require inc_path.join("Domain.class.rb")
        require inc_path.join("Ip.class.rb")

        @enable = UNSET_VALUE
        @domain = UNSET_VALUE
        @ip = UNSET_VALUE
      end

      def finalize!
        @enable = false if @enable == UNSET_VALUE
        @domain = nil if @domain == UNSET_VALUE
        @ip = nil if @ip == UNSET_VALUE

        # make it a Domain instance
        @domain = Domain.new @domain 
        
        # make it an Ip instance
        @ip = [@ip] unless @ip.kind_of? Array
        @ip.map!{|ip| Ip.new(ip) }

      end

    end
  end
end
