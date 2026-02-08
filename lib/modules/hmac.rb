# frozen_string_literal: true

require 'digest'

module TOTP
  # This class defines the encryption method utitilized by TOTP
  class HMAC
    class << self
      def raw_digest(secret_key, message, digest: Digest::SHA1.new)
        # Convert input strings into an array of bytes for bitwise operations
        key_bytes = secret_key.bytes
        message_bytes = message.bytes

        block_size = digest.block_length

        block_sized_key = compute_block_sized_key(key_bytes, digest, block_size)
        inner_padding = compute_inner_padding(block_size)
        outer_padding = compute_outer_padding(block_size)

        inner_key = xor(block_sized_key, inner_padding)
        outer_key = xor(block_sized_key, outer_padding)

        first_pass_result = first_pass(inner_key, message_bytes, digest)
        second_pass(outer_key, first_pass_result, digest)
      end

      def digest(secret_key, message, digest: Digest::SHA1.new)
        # Convert the array of bytes returned by raw digest into a binary string
        raw_digest(secret_key, message, digest: digest).pack('C*')
      end

      def hexdigest(secret_key, message, digest: Digest::SHA1.new)
        # Convert the binary string from digest into a hex string
        digest(secret_key, message, digest: digest).unpack1('H*')
      end

      private

      def first_pass(inner_key, message, digest)
        hash(concatenate(inner_key, message), digest)
      end

      def second_pass(outer_key, first_pass_result, digest)
        hash(concatenate(outer_key, first_pass_result), digest)
      end

      def hash(byte_array, digest)
        # Convert byte_array into a string before hashing
        # After hashing, convert the hashed string back into an array.
        digest.reset
        digest.digest(byte_array.pack('C*')).bytes
      end

      def concatenate(first_byte_array, second_byte_array)
        [*first_byte_array, *second_byte_array]
      end

      def pad(array, pad_with, target_size)
        return array if array.length >= target_size

        padding = Array.new(target_size - array.length) { pad_with }
        array + padding
      end

      def compute_block_sized_key(key_bytes, digest, block_size)
        if key_bytes.length > block_size
          pad(hash(key_bytes, digest), 0, block_size)
        elsif key_bytes.length < block_size
          pad(key_bytes, 0, block_size)
        else
          key_bytes
        end
      end

      def xor(first_byte_array, second_byte_array)
        first_byte_array.map.with_index { |value, idx| value ^ second_byte_array[idx] }
      end

      # Block sized outer padding, consisting of repeated bytes value 0x5c (92
      # in decimal)
      def compute_outer_padding(block_size)
        Array.new(block_size) { 92 }
      end

      # Block sized inner padding, consisting of repeated bytes value 0x36 (54
      # in decimal)
      def compute_inner_padding(block_size)
        Array.new(block_size) { 54 }
      end
    end
  end
end
