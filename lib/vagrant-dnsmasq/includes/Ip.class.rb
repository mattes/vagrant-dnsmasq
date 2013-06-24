class Ip

  MATCH_IP4 = /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/

  def initialize(ipv4)

    raise ArgumentError, "IPv4 '#{ipv4}' must match #{MATCH_IP4}" unless Ip::ipv4_valid?(ipv4)

    @ipv4 = ipv4
  end

  def self.ipv4_valid?(ipv4)
    Ip::MATCH_IP4.match(ipv4)
  end

  def v4
    @ipv4
  end

  def to_s
    v4
  end

end