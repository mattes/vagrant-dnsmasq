# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-dnsmasq/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-dnsmasq"
  spec.version       = Vagrant::Dnsmasq::VERSION
  spec.authors       = ["mattes"]
  spec.email         = ["matthias.kadenbach@gmail.com"]
  spec.description   = "A Dnsmasq Vagrant plugin that manages the dnsmasq.conf file and /etc/resolver directory on your host system."
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/mattes/vagrant-dnsmasq"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
