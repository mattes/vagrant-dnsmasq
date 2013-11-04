require './lib/vagrant-dnsmasq/includes/Domain.class.rb'

describe Domain do

  it "should return normal domain" do
    Domain.new('foobar').name.should eq('foobar')
    Domain.new('.foobar').name.should eq('foobar')
    Domain.new('foo.bar').name.should eq('foo.bar')
    Domain.new('.foo.bar').name.should eq('foo.bar')
    Domain.new('foo8ar').name.should eq('foo8ar')
    Domain.new('.foo8ar').name.should eq('foo8ar')
    Domain.new('foo.8ar').name.should eq('foo.8ar')
    Domain.new('.foo.8ar').name.should eq('foo.8ar')
  end

  it "should return dotted domain" do
    Domain.new('foobar').dotted.should eq('.foobar')
    Domain.new('.foobar').dotted.should eq('.foobar')
    Domain.new('foo.bar').dotted.should eq('.foo.bar')
    Domain.new('.foo.bar').dotted.should eq('.foo.bar')
    Domain.new('foo8ar').dotted.should eq('.foo8ar')
    Domain.new('.foo8ar').dotted.should eq('.foo8ar')
    Domain.new('foo.8ar').dotted.should eq('.foo.8ar')
    Domain.new('.foo.8ar').dotted.should eq('.foo.8ar')
  end

  it "should return valid domain if domain is passed" do
    Domain.new(Domain.new('foobar')).name.should eq('foobar')
    Domain.new(Domain.new('.foobar')).name.should eq('foobar')
    Domain.new(Domain.new('foobar')).dotted.should eq('.foobar')
    Domain.new(Domain.new('.foobar')).dotted.should eq('.foobar')
    Domain.new(Domain.new('foo.bar')).name.should eq('foo.bar')
    Domain.new(Domain.new('.foo.bar')).name.should eq('foo.bar')
    Domain.new(Domain.new('foo.bar')).dotted.should eq('.foo.bar')
    Domain.new(Domain.new('.foo.bar')).dotted.should eq('.foo.bar')
    Domain.new(Domain.new('foo8ar')).name.should eq('foo8ar')
    Domain.new(Domain.new('.foo8ar')).name.should eq('foo8ar')
    Domain.new(Domain.new('foo8ar')).dotted.should eq('.foo8ar')
    Domain.new(Domain.new('.foo8ar')).dotted.should eq('.foo8ar')
    Domain.new(Domain.new('foo.8ar')).name.should eq('foo.8ar')
    Domain.new(Domain.new('.foo.8ar')).name.should eq('foo.8ar')
    Domain.new(Domain.new('foo.8ar')).dotted.should eq('.foo.8ar')
    Domain.new(Domain.new('.foo.8ar')).dotted.should eq('.foo.8ar')
  end

  it "should make the domain lowercase" do
    Domain.new('FOOBAR').name.should eq('foobar')
  end

  it "should fail for invalid domains" do
    expect {
      Domain.new('foo*')
    }.to raise_error ArgumentError

    expect {
      Domain.new('.')
    }.to raise_error ArgumentError

    expect {
      Domain.new('foo..bar')
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
    Domain::valid?('foo*').should eq(false)
    Domain::valid?('.').should eq(false)
    Domain::valid?('foo..bar').should eq(false)
    Domain::valid?('foo_').should eq(false)
    Domain::valid?('foo.').should eq(false)
    Domain::valid?('foo-').should eq(false)
    Domain::valid?('').should eq(false)
    Domain::valid?(nil).should eq(false)
  end

end