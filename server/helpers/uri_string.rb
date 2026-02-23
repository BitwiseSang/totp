# frozen_string_literal: true

module SERVER
  # This class is responsible for generating the key uri
  class URI
    class << self
      def generate(base_32_secret)
        "otpauth://totp/#{USERNAME}:#{EMAIL}?" \
          "secret=#{base_32_secret}&issuer=#{ISSUER}&algorithm=#{ALGORITHM}&digits=#{DIGITS}&period=#{INTERVAL}"
      end
    end
  end
end
