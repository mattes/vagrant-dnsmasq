require './lib/vagrant-dnsmasq/includes/Dnsmasq.class.rb'
require './lib/vagrant-dnsmasq/includes/Domain.class.rb'
require './lib/vagrant-dnsmasq/includes/Ip.class.rb'

random = (0...50).map{ ('a'..'z').to_a[rand(26)] }.join

describe "At first" do
  it "should fail if there is no conf file" do
  expect {
    Dnsmasq.new("/tmp/some-non-existing-file-#{random}-h25hch345b3k5")
  }.to raise_error IOError
  end
end


describe DnsmasqConf do
  before(:each) do
    System2.new("touch /tmp/dnsmasq-conf-#{random}").rife
    @dnsm = Dnsmasq.new("/tmp/dnsmasq-conf-#{random}")
    @domain = Domain.new('.foobar')
  end

  after(:each) do
    System2.new("rm /tmp/dnsmasq-conf-#{random}").rife if File.exists? "/tmp/dnsmasq-conf-#{random}"
  end

  it "should insert a domain" do
    @dnsm.insert(@domain)
    @dnsm.includes?(@domain).should eq(true)
  end

  it "should return false if no domain is found" do
    @dnsm.includes?(Domain.new('.doesntexist')).should eq(false)
  end

  it "should delete a domain" do
    @dnsm.includes?(@domain).should eq(false)
    @dnsm.insert(@domain)
    @dnsm.includes?(@domain).should eq(true)
    @dnsm.delete(@domain) 
    @dnsm.includes?(@domain).should eq(false)
  end 

  it "#insert should raise if domain is nil" do
    expect {
      @dnsm.insert(nil)
    }.to raise_error ArgumentError
  end

  it "#delete should raise if domain is nil" do
    expect {
      @dnsm.delete(nil)
    }.to raise_error ArgumentError
  end

  it "#includes? should raise if domain is nil" do
    expect {
      @dnsm.includes?(nil)
    }.to raise_error ArgumentError
  end

end