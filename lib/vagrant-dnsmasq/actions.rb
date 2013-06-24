module Vagrant
  module Action

    class Up
      def initialize(app, env)
        inc_path = Pathname.new(File.expand_path("../includes", __FILE__))
        require inc_path.join("Domain.class.rb")
        require inc_path.join("Ip.class.rb")
        require inc_path.join("Dnsmasq.class.rb")
        require inc_path.join("Resolver.class.rb")
        require inc_path.join("helper.rb")

        @app = app
        @machine = env[:machine]
        @ip = []
      end

      def call(env)
        if @machine.config.dnsmasq.enabled?
          
          # overwrite ip with value from config?
          @ip = @machine.config.dnsmasq.ip if @machine.config.dnsmasq.ip.count > 0
          
          
          # ... or try to fetch it from guest system
          if @ip.count === 0
            @machine.communicate.sudo("hostname -I") do |type, data| 
              @ip = data.scan /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/
            end
            @ip.map!{|ip| begin Ip.new(ip) rescue nil end}.compact!
          end

          # is there a ip?
          if @ip.count > 0

            # update dnsmasq.conf
            brew_prefix = `brew --prefix`
            brew_prefix.strip!
            dnsmasq_conf_file = brew_prefix + "/etc/dnsmasq.conf"

            dnsmasq = DnsmasqConf.new(dnsmasq_conf_file)
            @ip.each do |ip|
              dnsmasq.insert(@machine.config.dnsmasq.domain, ip)
            end
            
            # update /etc/resolver
            resolver = Resolver.new('/etc/resolver')
            @ip.each do |ip|
              resolver.insert(@machine.config.dnsmasq.domain, ip)
            end

            env[:ui].info "Added domain #{@machine.config.dnsmasq.domain} for IP #{@ip}"
            @app.call(env)
          end
        end
      end
    end
  

    class Destroy
      def initialize(app, env)
        inc_path = Pathname.new(File.expand_path("../includes", __FILE__))
        require inc_path.join("Domain.class.rb")
        require inc_path.join("Ip.class.rb")
        require inc_path.join("Dnsmasq.class.rb")
        require inc_path.join("Resolver.class.rb")
        require inc_path.join("helper.rb")

        @app = app
      end

      def call(env)
        # @todo delete from dnsmasq.conf and /etc/resolver
        @app.call(env)
      end
    end

  end
end