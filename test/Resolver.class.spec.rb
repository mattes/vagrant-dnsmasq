require './lib/vagrant-dnsmasq/includes/Resolver.class.rb'
require './lib/vagrant-dnsmasq/includes/Domain.class.rb'
require './lib/vagrant-dnsmasq/includes/Ip.class.rb'

random = (0...50).map{ ('a'..'z').to_a[rand(26)] }.join

describe "At first" do
  it "should fail if there is no dir" do
  expect {
    Resolver.new("/tmp/some-non-existing-dir-#{random}-j2335n3kjfs3ap")
  }.to raise_error IOError
  end
end

describe Resolver do
  before(:each) do
    System2.new("mkdir -p /tmp/resolver-dir-#{random}").rife
    @res = Resolver.new("/tmp/resolver-dir-#{random}")
    @domain = Domain.new('.foobar')
  end

  after(:each) do
    System2.new("rm -R /tmp/resolver-dir-#{random}").rife if File.exists? "/tmp/resolver-dir-#{random}"
  end

  it "should insert a domain" do
    @res.insert(@domain)
    @res.includes?(@domain).should eq(true)
  end

  it "should return false if no domain is found" do
    @res.includes?(Domain.new('.doesntexist')).should eq(false)
  end

  it "should delete a domain" do
    @res.includes?(@domain).should eq(false)
    @res.insert(@domain)
    @res.includes?(@domain).should eq(true)
    @res.delete(@domain) 
    @res.includes?(@domain).should eq(false)
  end 

  it "#insert should raise if domain is nil" do
    expect {
      @res.insert(nil)
    }.to raise_error ArgumentError
  end

  it "#delete should raise if domain is nil" do
    expect {
      @res.delete(nil)
    }.to raise_error ArgumentError
  end

  it "#includes? should raise if domain is nil" do
    expect {
      @res.includes?(nil)
    }.to raise_error ArgumentError
  end

end