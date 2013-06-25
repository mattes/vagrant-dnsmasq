# vagrant-dnsmasq [![Build Status](https://travis-ci.org/mattes/vagrant-dnsmasq.png?branch=master)](https://travis-ci.org/mattes/vagrant-dnsmasq)

A Dnsmasq Vagrant plugin that manages the dnsmasq.conf file and /etc/resolver directory on your host system.

## Prerequisites
 * Mac OS X Mountain Lion
 * [brew](http://mxcl.github.io/homebrew/)
 * [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) ```brew install dnsmasq```

## Installation
```
vagrant plugin install vagrant-dnsmasq
```

## Usage
in your Vagrantfile
```
# set domain ending (required)
# adding this line enables dnsmasq handling
config.dnsmasq.domain = '.dev'


# optional configuration ...

# this plugin runs 'hostname -I' on the guest machine to obtain
# the guest ip address. you could overwrite this behaviour.
# config.dnsmasq.ip = '192.168.59.100'

# config.dnsmasq.ip = proc do |guest_machine| 
#   guest_machine.communicate.sudo("command to obtain ip somehow") do |type, data| 
#     # return something like '192.168.59.100' or ['192.168.59.100', '192.168.59.103']
#     return data['ip']
#   end
# end

# this will prompt you during 'vagrant up' to choose an IP
# config.dnsmasq.ip = ['192.168.59.100', '192.168.59.103']

# overwrite default location for /etc/resolver directory
# config.dnsmasq.resolver = '/etc/resolver'

# overwrite default location for /usr/local/etc/dnsmasq.conf
# config.dnsmasq.dnsmasqconf = '/usr/local/etc/dnsmasq.conf'

# disable dnsmasq handling
# config.dnsmasq.disable = true
```

## Uninstall
```
vagrant plugin uninstall vagrant-dnsmasq
```

Verify ```/etc/resolver``` and ```$(brew --prefix)/etc/dnsmasq.conf```.


## Alternatives

__`/etc/resolver` approach__
* [vagrant-dns](https://github.com/BerlinVagrant/vagrant-dns) (using [rubydns](http://www.codeotaku.com/projects/rubydns/index.en))

__`/etc/hosts` approach__
* [vagrant-hostmaster](https://github.com/mosaicxm/vagrant-hostmaster)
* [vagrant-hostmanager](https://github.com/smdahlen/vagrant-hostmanager)
* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)