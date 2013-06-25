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
          # env[:ui].info "Dnsmasq handler actived"

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
            resolver.insert(@machine.config.dnsmasq.domain, use_ip)

            env[:ui].info "Dnsmasq handler set IP '#{use_ip}'"

          else
            env[:ui].warn "Dnsmasq handler was not able to determine an IP address"
          end


          @app.call(env)



          # # overwrite ip with value from config?
          # @ip = @machine.config.dnsmasq.ip if @machine.config.dnsmasq.ip.count > 0
          # 
          # 
          # # ... or try to fetch it from guest system
          # if @ip.count === 0
          #   @machine.communicate.sudo("hostname -I") do |type, data| 
          #     @ip = data.scan /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/
          #   end
          #   @ip.map!{|ip| begin Ip.new(ip) rescue nil end}.compact!
          # end
# 
          # # is there a ip?
          # if @ip.count > 0
# 
          #   # update dnsmasq.conf
          #   dnsmasq = DnsmasqConf.new(@machine.config.dnsmasq.dnsmasqConf)
          #   @ip.each do |ip|
          #     dnsmasq.insert(@machine.config.dnsmasq.domain, ip)
          #   end
          #   
          #   # update /etc/resolver
          #   resolver = Resolver.new(@machine.config.dnsmasq.resolver)
          #   @ip.each do |ip|
          #     resolver.insert(@machine.config.dnsmasq.domain, ip)
          #   end
# 
          #   env[:ui].info "Added domain #{@machine.config.dnsmasq.domain} for IP #{@ip}"
          #   @app.call(env)
          # end
        end
      end
    end
  

    class Destroy
      def initialize(app, env)
        @app = app
      end

      def call(env)
        # @todo delete from dnsmasq.conf and /etc/resolver
        @app.call(env)
      end
    end

  end
end