# frozen_string_literal: true

require 'digest'
require_relative 'modules/hmac'
require_relative 'modules/hotp'

module TOTP
  BLOCK_SIZE = 64
  HASH_FUNCTION = Digest::SHA256.method(:digest)
  HOTP_VALUE_LENGTH = 6
end
