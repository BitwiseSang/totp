# frozen_string_literal: true

require 'pry'

module TOTP
  # This class defines the encryption method utitilized by TOTP
  class HMAC
    class << self
      def raw_digest(secret_key, message)
        # Convert input strings into an array of bytes for bitwise operations
        key_bytes = secret_key.bytes
        message_bytes = message.bytes

        block_sized_key = compute_block_sized_key(key_bytes)
        inner_padding = compute_inner_padding
        outer_padding = compute_outer_padding

        inner_key = xor(block_sized_key, inner_padding)
        outer_key = xor(block_sized_key, outer_padding)

        first_pass_result = first_pass(inner_key, message_bytes)
        second_pass(outer_key, first_pass_result)
      end

      def digest(secret_key, message)
        # Convert the array of bytes returned by raw digest into a binary string
        raw_digest(secret_key, message).pack('C*')
      end

      def hexdigest(secret_key, message)
        # Convert the binary string from digest into a hex string
        digest(secret_key, message).unpack1('H*')
      end

      private

      def first_pass(inner_key, message)
        hash(concatenate(inner_key, message))
      end

      def second_pass(outer_key, first_pass_result)
        hash(concatenate(outer_key, first_pass_result))
      end

      def hash(byte_array)
        # Convert byte_array into a string before hashing
        # After hashing, convert the hashed string back into an array.
        HASH_FUNCTION.call(byte_array.pack('C*')).bytes
      end

      def concatenate(first_byte_array, second_byte_array)
        [*first_byte_array, *second_byte_array]
      end

      def pad(array, pad_with)
        return array if array.length >= BLOCK_SIZE

        padding = Array.new(BLOCK_SIZE - array.length) { pad_with }
        array + padding
      end

      def compute_block_sized_key(key_bytes)
        if key_bytes.length > BLOCK_SIZE
          pad(hash(key_bytes), 0)
        elsif key_bytes.length < BLOCK_SIZE
          pad(key_bytes, 0)
        else
          key_bytes
        end
      end

      def xor(first_byte_array, second_byte_array)
        first_byte_array.map.with_index { |value, idx| value ^ second_byte_array[idx] }
      end

      # Block sized outer padding, consisting of repeated bytes value 0x5c (92
      # in decimal)
      def compute_outer_padding
        Array.new(BLOCK_SIZE) { 92 }
      end

      # Block sized inner padding, consisting of repeated bytes value 0x36 (54
      # in decimal)
      def compute_inner_padding
        Array.new(BLOCK_SIZE) { 54 }
      end
    end
  end
end
