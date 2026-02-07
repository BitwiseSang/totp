require 'digest'
require_relative 'modules/hmac'

module TOTP
  BLOCK_SIZE = 64
  HASH_FUNCTION = Digest::SHA256.method(:digest)
end
