# frozen_string_literal: true

# Contains methods to encode any object into a string
class Encode
  # Open an eigenclass, allowing for creation of private class methods.
  class << self
    def parse_array(input); end

    def parse_hash(input)
      # Hashes are called objects in JavaScript.
      "object:#{input.keys.length}:"
    end

    def parse_boolean(input)
      # Output the boolean value.
      # bool:<value>
      "bool:#{input ? 'true' : 'false'}"
    end

    def parse_symbol(input)
      # NOTE: There is no equivalent to 'symbol' in JavaScript.
      # Since in Ruby, it's counted as an immutable string,
      # we'll just represent it as a string.
      parse_string(input.to_s)
    end

    def parse_number(input)
      # Output the number.
      # number:<value>
      "number:#{input}"
    end

    def parse_string(input)
      # Output the string.
      # string:<length>:<value>
      "string:#{input.length}:#{input}"
    end

    def parse_value(input)
      # Encode based on type.
      case input
      when String
        parse_string(input)
      when Numeric
        # Number
        parse_number(input)
      when TrueClass, FalseClass
        # Boolean
        parse_boolean(input)
      end
    end
  end

  def self.parse(input, replacer = nil)
    # If the user specified a custom replacer...
    unless replacer.nil?
      # See if it can parse this type.
      result = replacer(input)

      # If so, then use that result.
      return result unless result.nil?

      # Else, fall back to the default encoders.
    end

    parse_value(input)
  end
end
