module Vagrant
  module Dnsmasq
    class Config < Vagrant.plugin("2", :config)
      
      attr_accessor :domain
      attr_accessor :ip
      attr_accessor :resolver
      attr_accessor :dnsmasqconf
      attr_accessor :disable

      def initialize
        @domain = UNSET_VALUE
        @ip = UNSET_VALUE
        @resolver = UNSET_VALUE
        @dnsmasqconf = UNSET_VALUE
        @disable = UNSET_VALUE
      end

      def finalize!
        brew_prefix = `brew --prefix`
        brew_prefix.strip!

        @domain = nil if @domain == UNSET_VALUE
        @ip = nil if @ip == UNSET_VALUE
        @resolver = '/etc/resolvers' if @resolver == UNSET_VALUE
        @dnsmasqconf = brew_prefix + "/etc/dnsmasq.conf" if @dnsmasqconf == UNSET_VALUE
        @disable = false if @disable == UNSET_VALUE

        # make it a Domain instance
        begin
          @domain = Domain.new @domain 
        rescue=>e
          raise Vagrant::Errors::VagrantError, e.message
        end
        
        # make it an Ip instance
        puts @ip.class
        @ip = [@ip] unless @ip.is_a? Array
        @ip.map!{|ip| begin Ip.new(ip) rescue=>e raise Vagrant::Errors::VagrantError, e.message end}.compact!
      end

      def validate(machine)
        errors = []

        # verify domain
        begin
          @domain = Domain.new @domain 
        rescue=>e
          errors << e.message
        end

        # verify ip
        @ip.map{|ip| begin Ip.new(ip) rescue=>e errors << e.message end}

        # verify resolver
        if @resolver
          errors << "directory '#{@resolver}' does not exist" unless Dir.exists? @resolver
        end

        # verify dnsmasqconf
        if @dnsmasqconf
         errors << "file '#{@dnsmasqconf}' does not exist" unless File.exists? @dnsmasqconf
        end 

        return { 'Dnsmasq configuration' => errors }
      end

      def enabled?
        not @disable and not @domain.nil?
      end

    end
  end
end
