require "helper.rb"

class Resolver

  attr_reader :dirname

  def initialize(dirname)
    raise ArgumentError, 'wrong dirname' if dirname.blank?
    raise IOError unless Dir.exists? dirname
    @dirname = dirname
  end

  def self.flush_cache!
    system 'sudo dscacheutil -flushcache'
  end

  def list
    Dir["#{@dirname}/*"].map{|dir| '.' + File.basename(dir)}
  end

  def insert(domain, sudo = false)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    unless includes?(domain)
      info("You may be asked for your password to insert #{@dirname}/#{domain.name}") if sudo
      System2.new("#{'sudo' if sudo} sh -c \"echo 'nameserver 127.0.0.1' >> #{@dirname}/#{domain.name}\"").rife
      Resolver::flush_cache!
    end
  end

  def delete(domain, sudo = false)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    if includes? domain
      info("You may be asked for your password to delete #{@dirname}/#{domain.name}") if sudo
      System2.new("#{'sudo' if sudo} rm #{@dirname}/#{domain.name}").rife
      Resolver::flush_cache!
    end
  end

  def includes?(domain)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain
    
    File.exists? "#{@dirname}/#{domain.name}"
  end

end