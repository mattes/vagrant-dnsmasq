module Vagrant
  module Action

    class Up
      def initialize(app, env)
        @app = app
        @machine = env[:machine]
        @ips = nil
      end

      def call(env)
        if @machine.config.dnsmasq.enabled?
          env[:ui].info "Dnsmasq handler actived"

          @ip = @machine.config.dnsmasq.ip

          # is a proc?
          if @ip.is_a? Proc
            ips = @ip.call(@machine)
            ips = [ips] unless ips.is_a? Array
            ips.map!{|ip| begin Ip.new(ip) rescue nil end}.compact! # dismiss invalid ips
            @ip = ips
          end
          
          if @ip.is_a?(Array) && @ip.count > 0
            # @ip is an array with domain instances ...

            if @ip.count > 1
              # prompt: choose ip
              ask = true
              while(ask)
                env[:ui].info "Dnsmasq handler asks: Which IP would you like to use?"
                i = 0
                @ip.each do |ip|
                  i += 1
                  env[:ui].info "(#{i}) #{ip.v4}"
                end
                env[:ui].info "Please type number [1-#{i}]: "
                answer = $stdin.gets.strip.to_i - 1
                use_ip = @ip.at(answer)
                ask = false unless use_ip.nil? 
              end

            else
              use_ip = @ip[0]
            end

            # use ip to update dnsmasq.conf and /etc/resolver

            # update dnsmasq.conf
            dnsmasq = DnsmasqConf.new(@machine.config.dnsmasq.dnsmasqconf)
            dnsmasq.insert(@machine.config.dnsmasq.domain, use_ip)
            
            # update /etc/resolver
            resolver = Resolver.new(@machine.config.dnsmasq.resolver, true) # true for sudo
            resolver.insert(@machine.config.dnsmasq.domain, Ip.new('127.0.0.1'))

            env[:ui].success "Dnsmasq handler set IP '#{use_ip}' for domain '#{@machine.config.dnsmasq.domain.dotted}'"

          else
            env[:ui].warn "Dnsmasq handler was not able to determine an IP address"
          end

          @app.call(env)
        end
      end
    end
  

    class Destroy
      def initialize(app, env)
        @app = app
        @machine = env[:machine]
      end

      def call(env)
        if @machine.config.dnsmasq.enabled?

          # remove records from dnsmasq.conf and /etc/resolver

          # update dnsmasq.conf
          dnsmasq = DnsmasqConf.new(@machine.config.dnsmasq.dnsmasqconf)
          dnsmasq.delete(@machine.config.dnsmasq.domain)

          # update /etc/resolver
          resolver = Resolver.new(@machine.config.dnsmasq.resolver, true) # true for sudo
          resolver.delete(@machine.config.dnsmasq.domain)

          env[:ui].success "Dnsmasq handler removed domain '#{@machine.config.dnsmasq.domain}'"

          @app.call(env)
        end
      end
    end

  end
end