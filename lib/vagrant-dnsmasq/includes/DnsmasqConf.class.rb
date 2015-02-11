class DnsmasqConf

  attr_reader :filename
  attr_reader :reload_command

  def initialize(filename, reload_command)
    raise ArgumentError, 'wrong filename' if filename.blank?
    raise IOError unless File.exists? filename
    @filename = filename
    @reload_command = reload_command
  end

  def reload
    if @reload_command
      begin
        # reload dnsmasq config if command specified
        puts "You might be asked for your password to restart the dnsmasq daemon."
        system @reload_command
      rescue => e
        # hmm ... i dont care
      end
    end
  end

  def insert(domain, ip)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain
    raise ArgumentError, 'invalid ip instance' unless ip.is_a? Ip

    File.open(@filename, 'a') { |file| file.write "\naddress=/#{domain.dotted}/#{ip.v4}" }
    reload
  end

  def update(domain, ip)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain
    raise ArgumentError, 'invalid ip instance' unless ip.is_a? Ip

    File.write(@filename, File.read(@filename).gsub(/(address=\/#{domain.dotted}\/).*/, "\\1#{ip.v4}"))
    reload
  end

  def delete(domain)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    delete_line_from_file(@filename, Regexp.new("address=/\.#{domain.name}"))
    reload
  end
  
  def includes?(domain)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    File.open(@filename, "r").each_line do |l|
      return true if Regexp.new("address=/\.#{domain.name}").match(l.strip)
    end
    return false
  end

end