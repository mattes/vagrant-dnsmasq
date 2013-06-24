require "helper.rb"
require "Domain.class.rb"

class Dnsmasq

  attr_reader :filename

  def initialize(filename)
    raise ArgumentError, 'wrong filename' if filename.blank?
    raise IOError unless File.exists? filename
    @filename = filename
  end

  def list
    domains = []
    File.open(@filename, "r").each_line do |l|
      match = /^address=\/(.*)\/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/.match(l.strip.chomp)
      domains.push(Domain.new(match[1])) if match
    end    
    return domains
  end

  def insert(domain, ip)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    delete(domain) # remove duplicates

    File.open(@filename, 'a') { |file|
      file.write "\naddress=/#{domain.dotted}/#{ip}"
    }
  end

  def includes?(domain)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    File.open(@filename, "r").each_line do |l|
      return true if(l.strip.gsub(/ /, '') == "address=/#{domain.dotted}/127.0.0.1")
    end
    return false
  end

  def delete(domain)
    raise ArgumentError, 'invalid domain instance' unless domain.is_a? Domain

    delete_line_from_file(@filename, "address=/#{domain.dotted}/127.0.0.1")
  end


end