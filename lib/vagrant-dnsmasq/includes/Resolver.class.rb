class Resolver

  attr_reader :dirname

  def initialize(dirname, sudo = false)
    raise ArgumentError, 'wrong dirname' if dirname.blank?
    raise IOError unless Dir.exists? dirname
    @dirname = dirname
    @sudo = sudo
  end

  def self.flush_cache!
    system 'sudo dscacheutil -flushcache' if @sudo
  end

  def list
    Dir["#{@dirname}/*"].map{|dir| '.' + File.basename(dir)}
  end

  def insert(domain, ip)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain
    raise ArgumentError, 'invalid ip instance' unless ip.is_a? Ip

    unless includes?(domain, ip)
      delete(domain) 

      puts "You may be asked for your password to insert #{@dirname}/#{domain.name} (ip: #{ip})" if @sudo
      system("#{'sudo' if @sudo} sh -c \"echo 'nameserver #{ip.v4}' >> #{@dirname}/#{domain.name}\"")
      Resolver::flush_cache!
    end
  end

  def delete(domain)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    if includes? domain
      puts "You may be asked for your password to delete #{@dirname}/#{domain.name}" if @sudo
      system("#{'sudo' if @sudo} rm -rf #{@dirname}/#{domain.name}")
      Resolver::flush_cache!
    end
  end

  def includes?(domain, with_ip = nil)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    unless with_ip.nil?
      raise ArgumentError, 'invalid ip instance' unless with_ip.is_a? Ip
      File.exists?("#{@dirname}/#{domain.name}") && IO.read("#{@dirname}/#{domain.name}").strip == "nameserver #{with_ip.v4}"
    else
      File.exists? "#{@dirname}/#{domain.name}"
    end
  end

end