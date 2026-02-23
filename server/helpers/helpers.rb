# frozen_string_literal: true

require_relative 'uri_string'
require_relative 'qrcode'
require_relative 'html'

module SERVER
  # URI generation constants
  USERNAME = 'RubyHacker'
  EMAIL = 'admin@localhost'
  ISSUER = 'RubyHacker'
  ALGORITHM = 'SHA1'
  DIGITS = 6
  INTERVAL = 30
end
