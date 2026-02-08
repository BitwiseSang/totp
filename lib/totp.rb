# frozen_string_literal: true

require 'digest'
require_relative 'modules/hmac'
require_relative 'modules/hotp'
require_relative 'modules/totp'

module TOTP
  DEFAULT_DIGEST = Digest::SHA1.new
  DEFAULT_DIGITS = 6
  DEFAULT_INTERVAL = 30
end
