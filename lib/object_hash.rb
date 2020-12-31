# frozen_string_literal: true

require_relative "object_hash/version"

require_relative "object_hash/encode"
require_relative "object_hash/cryptohash"

# Contains functions which encode the input into a standardized format,
# then cryptographically hash it.
module ObjectHash
  # Looks like self assignment but isn't.
  Encode = Encode
  CryptoHash = CryptoHash

  module_function

  # Encode the input into a standardized format,
  # then cryptographically hash it.
  # @param input: Any object that should be encoded.
  # @param algorithm: Either a string naming the algorithm to use, or a Digest object that can hash the string.
  #   To preview the output of encoding, use "none".
  def hash(input, algorithm = "sha1", replacer = nil, unordered_objects = true)
    CryptoHash.perform_cryptohash(Encode.perform_encode(input, **{
      replacer: replacer,
      unordered_objects: unordered_objects
    }), algorithm)
  end
end
