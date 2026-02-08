# frozen_string_literal: true

module TOTP
  # Time-based one-time password class
  class Generator
    class << self
      def generate(secret, unix_time)
        counter = computer_counter(unix_time)
        TOTP::HOTP.generate(secret, counter: counter)
      end

      private

      def computer_counter(unix_time)
        (unix_time - 0) / TX
      end
    end
  end
end
