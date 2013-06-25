require './lib/vagrant-dnsmasq/includes/Ip.class.rb'

describe Ip do

  it "should return ipv4" do
    Ip.new('10.10.10.10').v4.should eq('10.10.10.10')
  end

  it "should return ipv4 if ip is passed" do
    Ip.new(Ip.new('10.10.10.10')).v4.should eq('10.10.10.10')
  end

  it "should fail for invalid ips" do
    expect {
      Ip.new('10.10.10')
    }.to raise_error ArgumentError

    expect {
      Ip.new('300.0.0.1')
    }.to raise_error ArgumentError

    expect {
      Ip.new('10-10-10-10')
    }.to raise_error ArgumentError

    expect {
      Ip.new('')
    }.to raise_error ArgumentError

    expect {
      Ip.new(nil)
    }.to raise_error ArgumentError
  end

  it "#valid? should fail for invalid ips" do
    Ip::ipv4_valid?('10.10.10').should eq(false)
    Ip::ipv4_valid?('300.0.0.1').should eq(false)
    Ip::ipv4_valid?('10-10-10-10').should eq(false)
    Ip::ipv4_valid?('').should eq(false)
    Ip::ipv4_valid?(nil).should eq(false)
  end

end