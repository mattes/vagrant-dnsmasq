require "helper.rb"

class Domain

  MATCH = "/^\.?[a-z]*$/"

  def initialize(name)
    @name = nil

    if name.is_a? Domain
      @name = name
      return
    end

    raise ArgumentError, "no domain name given" if name.blank?

    # parse domain name ...
    name = name.to_s
    name = name[1..-1] if name.start_with? '.'
    name = name.downcase
    raise ArgumentError, "Domain '#{name}' must match /^[a-z]*$/" unless /^[a-z]*$/.match(name)
    @name = name # without leading .   
  end

  def self.valid?(name)
    if name.blank? or not /^\.?[a-z]*$/.match(name.downcase)
      return false
    else
      return true
    end
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