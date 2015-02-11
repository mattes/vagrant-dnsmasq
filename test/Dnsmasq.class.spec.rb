require './lib/vagrant-dnsmasq/includes/DnsmasqConf.class.rb'
require './lib/vagrant-dnsmasq/includes/Domain.class.rb'
require './lib/vagrant-dnsmasq/includes/Ip.class.rb'

random = (0...50).map{ ('a'..'z').to_a[rand(26)] }.join

describe "At first" do
  it "should fail if there is no conf file" do
  expect {
    DnsmasqConf.new("/tmp/some-non-existing-file-#{random}-h25hch345b3k5", nil)
  }.to raise_error IOError
  end
end


describe DnsmasqConf do
  before(:each) do
    system "touch /tmp/dnsmasq-conf-#{random}" 
    @dnsm = DnsmasqConf.new("/tmp/dnsmasq-conf-#{random}", nil)
    @domain = Domain.new('.foobar')
    @ip = Ip.new('10.10.10.10')
    @new_ip = Ip.new('10.10.10.11')
  end

  after(:each) do
    system("rm /tmp/dnsmasq-conf-#{random}") if File.exists? "/tmp/dnsmasq-conf-#{random}"
  end

  it "should insert a domain" do
    @dnsm.insert(@domain, @ip)
    @dnsm.includes?(@domain).should eq(true)
  end

  it "should update a domain" do 
    @dnsm.insert(@domain, @ip)
    @dnsm.update(@domain, @new_ip)
    domain_exists = begin 
      found = false
      File.open(@dnsm.filename, "r").each_line do |l|
        found = true if Regexp.new("address=/\.#{@domain.name}/#{@new_ip.v4}").match(l.strip)
      end
      found
    end
    domain_exists.should eq(true)
  end

  it "should return false if no domain is found" do
    @dnsm.includes?(Domain.new('.doesntexist')).should eq(false)
  end

  it "should delete a domain" do
    @dnsm.includes?(@domain).should eq(false)
    @dnsm.insert(@domain, @ip)
    @dnsm.includes?(@domain).should eq(true)
    @dnsm.delete(@domain) 
    @dnsm.includes?(@domain).should eq(false)
  end 

  it "#insert should raise if domain is nil" do
    expect {
      @dnsm.insert(nil, nil)
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