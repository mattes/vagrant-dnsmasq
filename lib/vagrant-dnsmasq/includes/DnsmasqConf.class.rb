class DnsmasqConf

  attr_reader :filename

  def initialize(filename)
    raise ArgumentError, 'wrong filename' if filename.blank?
    raise IOError unless File.exists? filename
    @filename = filename
  end

  def self.flush_cache!
    begin
      # restart dnsmasq (if installed with homebrew)

      puts "You might be asked for your password to restart the dnsmasq daemon."
      system "sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist"
      system "sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist"

      # @todo: call proc or try other fancy things to reload dnsmasq

    rescue => e
      # hmm ... i dont care
    end
  end

  def insert(domain, ip)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain
    raise ArgumentError, 'invalid ip instance' unless ip.is_a? Ip

    unless includes?(domain)
      File.open(@filename, 'a') { |file|
        file.write "\naddress=/#{domain.dotted}/#{ip.v4}"
      }
      DnsmasqConf::flush_cache!
    end
  end

  def includes?(domain)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    File.open(@filename, "r").each_line do |l|
      return true if Regexp.new("address=/\.#{domain.name}").match(l.strip)
    end
    return false
  end

  def delete(domain)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    delete_line_from_file(@filename, Regexp.new("address=/\.#{domain.name}"))
    DnsmasqConf::flush_cache!
  end


end