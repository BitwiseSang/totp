require_relative 'lib/totp'

TOTP::HMAC.new('super-secret-key', 'message')
