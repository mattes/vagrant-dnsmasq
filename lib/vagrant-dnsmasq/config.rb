module Vagrant
  module Dnsmasq
    class Config < Vagrant.plugin("2", :config)
      
      attr_accessor :domain
      attr_accessor :ip
      attr_accessor :resolver
      attr_accessor :keep_resolver_on_destroy
      attr_accessor :dnsmasqconf
      attr_accessor :reload_command
      attr_accessor :disable

      def initialize
        @domain = UNSET_VALUE
        @ip = UNSET_VALUE
        @resolver = UNSET_VALUE
        @keep_resolver_on_destroy = UNSET_VALUE
        @dnsmasqconf = UNSET_VALUE
        @reload_command = UNSET_VALUE
        @disable = UNSET_VALUE
      end

      def finalize!

        if @domain == UNSET_VALUE 
          @domain = nil
        elsif !@domain.is_a?(Domain)
          @domain = Domain.new @domain;
        end
        
        @keep_resolver_on_destroy = false if @keep_resolver_on_destroy == UNSET_VALUE
        @resolver = '/etc/resolver' if @resolver == UNSET_VALUE
        @dnsmasqconf = "/etc/dnsmasq.conf" if @dnsmasqconf == UNSET_VALUE
        @reload_command = nil if @reload_command == UNSET_VALUE
        @disable = false if @disable == UNSET_VALUE

        # default way to obtain ip address
        if @ip == UNSET_VALUE
          @ip = proc do |guest_machine| 
            ips = nil
            guest_machine.communicate.sudo("hostname -I") do |type, data| 
              ips = data.scan /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/
            end
            ips
          end
        end

      end

      def enabled?
        not @disable and not @domain.nil?
      end

      def validate(machine)
        return unless enabled?

        errors = []

        # verify @disable
        if @disable != true and @disable != false then errors << 'invalid disable setting' end

        # verify domain
        begin @domain = Domain.new @domain; rescue => e; errors << e.message end

        # verify ip
        if @ip.is_a? Array
          @ip.map!{|ip| begin Ip.new(ip); rescue => e; errors << e.message end}

        elsif @ip.is_a? String
          begin @ip = Ip.new(@ip); rescue => e; errors << e.message end
          @ip = [@ip]

        elsif @ip.is_a? Proc
          # okay, there is nothing to verify at the moment
        else
          @ip = nil
        end        

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

    end
  end
end
