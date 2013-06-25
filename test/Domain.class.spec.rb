require './lib/vagrant-dnsmasq/includes/Domain.class.rb'

describe Domain do

  it "should return normal domain" do
    Domain.new('foobar').name.should eq('foobar')
    Domain.new('.foobar').name.should eq('foobar')
  end

  it "should return dotted domain" do
    Domain.new('foobar').dotted.should eq('.foobar')
    Domain.new('.foobar').dotted.should eq('.foobar')
  end

  it "should make the domain lowercase" do
    Domain.new('FOOBAR').name.should eq('foobar')
  end

  it "should fail for invalid domains" do
    expect {
      Domain.new('foo1')
    }.to raise_error ArgumentError

    expect {
      Domain.new('foo_')
    }.to raise_error ArgumentError

    expect {
      Domain.new('foo.')
    }.to raise_error ArgumentError

    expect {
      Domain.new('foo-')
    }.to raise_error ArgumentError

    expect {
      Domain.new('')
    }.to raise_error ArgumentError

    expect {
      Domain.new(nil)
    }.to raise_error ArgumentError
  end

  it "#valid? should fail for invalid domains" do
    Domain::valid?('foo1').should eq(false)
    Domain::valid?('foo_').should eq(false)
    Domain::valid?('foo.').should eq(false)
    Domain::valid?('foo-').should eq(false)
    Domain::valid?('').should eq(false)
    Domain::valid?(nil).should eq(false)
  end

end