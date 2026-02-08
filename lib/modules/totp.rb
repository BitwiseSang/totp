# frozen_string_literal: true

require 'digest'

module TOTP
  # Time-based one-time password class
  class Generator
    class << self
      def generate(secret, interval: DEFAULT_INTERVAL, digest: DEFAULT_DIGEST, digits: DEFAULT_DIGITS)
        counter = compute_counter(Time.now.to_i, interval)
        TOTP::HOTP.generate(secret, counter: counter, digest: digest, digits: digits)
      end

      def verified?(secret, code, interval: DEFAULT_INTERVAL, digest: DEFAULT_DIGEST, digits: DEFAULT_DIGITS)
        counter = compute_counter(Time.now.to_s)

        (-drift..drift).any? do |_iteration|
          generated_code = generate(secret, counter + 1, interval: interval, digest: digest, digits: digits)
          secure_compare(generated_code, code.to_s)
        end
      end

      private

      def secure_compare(first_code, second_code)
        return unless first_code.bytesize == second_code.bytesize

        result = 0
        first_code.bytes.zip(second_code.bytes) { |x, y| result |= (x ^ y) }
        result.zero?
      end

      def compute_counter(unix_time, interval)
        ((unix_time - 0) / interval).floor
      end
    end
  end
end
