# frozen_string_literal: true

# Contains methods to encode any object into a string.
# Performs the functions of the typeHasher in the original JS library.
module Encode
  # By invoking Hash.new with a block, one handler can call others,
  # and a default case can be used.
  ENCODERS = Hash.new do |h, k|
    case k
    # Encode each element, then concatenate together.
    when :Array then lambda do |x, a|
      "array:#{x.length}:#{x.map { |y| perform_encode(y, a) }.reduce(:+)}"
    end
    # object:<length:<key>:<value>,<key>:<value>,<key>:<value>,
    when :Hash then lambda do |x, a|
      keys = (a[:unordered_objects] ? x.keys.sort : x.keys)
      "object:#{x.length}:#{keys.map { |i| "#{perform_encode(i, **a)}:#{perform_encode(x[i], **a)}," }.reduce(:+)}"
    end

    when :Integer then ->(x, _a) { "number:#{x}" }
    when :Float then ->(x, a) { h[:Integer].call(x, a) }

    when :String then ->(x, _a) { "string:#{x.length}:#{x}" }
    when :Symbol then ->(x, _a) { "symbol:#{x}" }

    when :Boolean then ->(x, _a) { "bool:#{x}" }
    when :TrueClass then ->(x, a) { h[:Boolean].call(x, a) }
    when :FalseClass then ->(x, a) { h[:Boolean].call(x, a) }

    when :NilClass then ->(_x, _a) { "Null" }
    when :URI then ->(x, _a) { "url:#{x}" }
    when :File then ->(x, _a) { "file:#{x}" }
    # Throw an error if an unknown algorithm is used.
    else raise UnknownAlgorithmError, k
    end
  end.freeze

  module_function

  def perform_encode(input, replacer: nil, unordered_objects: true)
    # If the user specified a custom replacer...
    unless replacer.nil?
      # See if it can parse this type.
      result = replacer(input)

      # If so, then use that result.
      return result unless result.nil?

      # Else, fall back to the default encoders.
    end

    # Encode the value and return it.
    encoder = input.class.to_s.to_sym

    # Pass all arguments, since perform_encode can be called recursively.
    ENCODERS[encoder].call(input, {
      replacer: replacer,
      unordered_objects: unordered_objects
    })
  end
end
