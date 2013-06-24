module Vagrant
  module Action
    class Up
      def initialize(app, env)
        @app = app
        @machine = env[:machine]
      end

      def call(env)
        if @machine.config.dnsmasq.enabled?
          puts "UP UP UP"
          
          @machine.communicate.sudo("hostname -I") do |type, data| 

            ips = /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/.match(data)
            puts "---------"
            puts ips
            puts "---------"
          end

          @app.call(env)
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