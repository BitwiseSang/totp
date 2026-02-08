# frozen_string_literal: true

module TOTP
  # HMAC-Based One-Time Password class which extends the HMAC class `./hmac.rb`
  class HOTP
    class << self
      def generate(secret_key, counter: 0, digest: Digest::SHA1.new, digits: 6)
        # Convert counter to a 64-bit big-endian counter before hashing
        big_endian_counter = [counter].pack('Q>')
        raw_digest = TOTP::HMAC.raw_digest(secret_key, big_endian_counter, digest: digest)
        binary_code = truncate(raw_digest)
        binary_code.modulo(10**digits)
      end

      private

      def truncate(raw_digest)
        offset = raw_digest.last & 0xf
        binary_string = raw_digest[offset, 4].pack('C*')
        #
        # NOTE: Longer but descriptive way of doing the above operation
        # binary_string = ((raw_digest[offset] & 0x7f) << 24) |
        #                 ((raw_digest[offset + 1] & 0xff) << 16) |
        #                 ((raw_digest[offset + 2] & 0xff) << 8) |
        #                 raw_digest[(offset + 3) & 0xff]
        binary_code = binary_string.unpack1('N')
        # Remove the sign from the binary code
        binary_code & 0x7fffffff
      end
    end
  end
end
