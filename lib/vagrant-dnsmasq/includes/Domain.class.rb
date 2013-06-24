class Domain

  MATCH = /^\.?[a-z]*$/

  def initialize(name)
    @name = nil

    if name.is_a? Domain
      @name = name.dotted
      return
    end

    raise ArgumentError, "no domain name given" unless name

    # parse domain name ...
    name = name.to_s
    name = name[1..-1] if name.start_with? '.'
    name = name.downcase
    raise ArgumentError, "Domain '#{name}' must match #{MATCH}" unless Domain::valid?(name)
    @name = name # without leading .   
  end

  def self.valid?(name)
    Domain::MATCH.match(name.downcase)
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