require 'rubygems'
require 'bundler/setup'
Bundler::GemHelper.install_tasks

task :default do
  system 'rake -T'
end

desc "run tests"
task :test do
  system 'rspec test/*.spec.rb'
end

desc "tag this version and rake release"
task :publish do
  lib = File.expand_path('../lib', __FILE__)
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
  require 'vagrant-dnsmasq/version'

  puts "VERSION: #{Vagrant::Dnsmasq::VERSION}"

  system "git add ."
  system "git commit -a"
  system "git push"

  system "git tag -a v#{Vagrant::Dnsmasq::VERSION}"
  system "git push origin v#{Vagrant::Dnsmasq::VERSION}"

  system 'rake release'
end