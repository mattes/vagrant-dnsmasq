refresh:
	rake build && vagrant plugin uninstall vagrant-dnsmasq && vagrant plugin install pkg/vagrant-dnsmasq-0.0.*.gem

test-and-destroy:
	make refresh && make up-and-destroy

test:
	make refresh && make up

up:
	cd test && vagrant up

debug-up:
	cd test && VAGRANT_LOG=INFO vagrant up

destroy:
	cd test && vagrant destroy -f

reload:
	cd test && vagrant reload

up-and-destroy:
	make up; make destroy


.PHONY: refresh up debug-up destroy reload up-and-destroy test-and-destroy test