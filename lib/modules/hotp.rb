# frozen_string_literal: true

module TOTP
  # HMAC-Based One-Time Password class which extends the HMAC class `./hmac.rb`
  class HOTP
    class << self
      def generate(secret_key, counter: 0)
        # Convert counter to a 64-bit big-endian counter before hashing
        big_endian_counter = [counter].pack('Q>')
        raw_digest = TOTP::HMAC.raw_digest(secret_key, big_endian_counter)
        truncate(raw_digest)
      end

      private

      def truncate(raw_digest)
        offset = [raw_digest[-1]].pack('C*').unpack1('h').to_i(16)
        binary = raw_digest[offset, 4].pack('C*').unpack1('N*') & 0x7fffffff
        binary.modulo(10**HOTP_VALUE_LENGTH)
      end
    end
  end
end
