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
# dnsmasq ...

# enable dnsmasq?
# set to false or delete line to disable dnsmasq handling
config.dnsmasq.enable = true

# set domain ending
config.dnsmasq.domain = '.dev'

# this plugin runs 'hostname -I' on the guest machine to obtain
# the guest ip address. you could overwrite the ip here. optional.
# config.dnsmasq.ip = '192.168.59.100'
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