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

  def insert(domain, ip)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    delete(domain) if includes?(domain)

    puts "You may be asked for your password to insert #{@dirname}/#{domain.name}"
    system("sudo sh -c \"echo 'nameserver #{ip.v4}' >> #{@dirname}/#{domain.name}\"")
    Resolver::flush_cache!

  end

  def delete(domain)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    if includes? domain
      puts "You may be asked for your password to delete #{@dirname}/#{domain.name}"
      system("sudo rm -rf #{@dirname}/#{domain.name}")
      Resolver::flush_cache!
    end
  end

  def includes?(domain)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    File.exists? "#{@dirname}/#{domain.name}"
  end

end