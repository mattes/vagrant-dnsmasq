class Ip

  MATCH_IP4 = /^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9]{1,2})(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9]{1,2})){3}$/

  def initialize(ipv4)

    if ipv4.is_a? Ip
      ipv4 = ipv4.v4
    end

    raise ArgumentError, "IPv4 '#{ipv4}' must match #{MATCH_IP4}" unless Ip::ipv4_valid?(ipv4)

    @ipv4 = ipv4
  end

  def self.ipv4_valid?(ipv4)
    if not ipv4.blank? and Ip::MATCH_IP4.match(ipv4) then true else false end
  end

  def v4
    @ipv4
  end

  def to_s
    v4
  end

end