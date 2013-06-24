require 'rubygems'
require 'bundler/setup'
Bundler::GemHelper.install_tasks

task :default do
  system 'rake -T'
end

task :build2 do
 system "echo 'rake build && vagrant plugin uninstall vagrant-dnsmasq && vagrant plugin install pkg/vagrant-dnsmasq-0.0.*.gem && vagrant dnsmasq' > /tmp/vagrant-dnsmasq-build2"
 puts "run 'source /tmp/vagrant-dnsmasq-build2'"
end