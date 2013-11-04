class Domain

  MATCH = /^(\.?[a-z0-9]+)+$/

  def initialize(name)
    @name = nil

    if name.is_a? Domain
      name = name.dotted
    end

    raise ArgumentError, "no domain name given" if name.blank?

    # parse domain name ...
    name = name.to_s
    name = name[1..-1] if name.start_with? '.'
    name = name.downcase
    raise ArgumentError, "Domain '#{name}' must match #{MATCH}" unless Domain::valid?(name)
    @name = name # without leading .   
  end

  def self.valid?(name)
    if not name.blank? and Domain::MATCH.match(name.downcase) then true else false end
  end

  def dotted
    '.' + @name
  end

  def name
    @name
  end

  def to_s
    dotted
  end

end