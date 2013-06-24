require "includes/helper.rb"
require "includes/Domain.class.rb"

module Vagrant
  module Action
    class Up
      def initialize(app, env)
        @app = app
        @machine = env[:machine]
      end

      def call(env)
        if @machine.config.dnsmasq.enabled?
          ip = []
          
          # overwrite ip with value from config?
          if @machine.config.dnsmasq.ip
            ip = [@machine.config.dnsmasq.ip] unless @machine.config.dnsmasq.ip.kind_of? Array
          end
          
          # ... or try to fetch it from guest system
          if ip.count === 0
            @machine.communicate.sudo("hostname -I") do |type, data| 
              ip = data.scan /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/
            end
          end

          # is there a ip?
          if ip && ip.count > 0

            # update dnsmasq.conf
            brew_prefix = `brew --prefix`
            brew_prefix.strip!
            dnsmasq_conf_file = brew_prefix + "/etc/dnsmasq.conf"

            ip.each do |_ip|
              delete_line_from_file(dnsmasq_conf_file, "address=/#{@machine.config.dnsmasq.domain.dotted}/#{_ip}")
            end
            
            File.open(@filename, 'a') { |file|
              ip.each do |_ip|
                file.write "\naddress=/#{@machine.config.dnsmasq.domain.dotted}/#{_ip}"
              end
            }

            # update /etc/resolver

            env[:ui].info "Added domain #{@machine.config.dnsmasq.domain} for IP #{ip}"
            @app.call(env)
          end
        end
      end
    end
  

    class Destroy
      def initialize(app, env)
        @app = app
      end

      def call(env)
        puts "DESTROY DESTROY DESTROY"
        @app.call(env)
      end
    end

  end
end