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

      private

      def compute_counter(unix_time, interval)
        ((unix_time - 0) / interval).floor
      end
    end
  end
end
