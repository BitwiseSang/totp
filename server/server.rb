# frozen_string_literal: true

require 'webrick'

require_relative '../lib/totp'
require_relative 'helpers/helpers'

RAW_SECRET = '12345678901234567890'
BASE32_SECRET = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ'

PORT = 8080

uri = SERVER::URI.generate(BASE32_SECRET)
svg_data = SERVER::QRCODE.generate(uri)

server = WEBrick::HTTPServer.new(Port: PORT)
server.mount_proc '/' do |_req, res|
  res.content_type = 'text/html'
  res.body = SERVER::HTML.generate_body(svg_data)
end

server.mount_proc '/verify' do |req, res|
  user_code = req.query['code']
  is_valid = TOTP::Generator.verified?(RAW_SECRET, user_code)

  res.content_type = 'text/html'
  res.body = if is_valid
               SERVER::HTML.generate_valid(user_code)
             else
               SERVER::HTML.generate_invalid(user_code)
             end
end

# Shutdown on Ctrl + C
trap 'INT' do
  server.shutdown
end

puts '========================================'
puts " Server running at http://localhost:#{PORT}"
puts 'Press Ctrl + C to exit.'
puts '========================================'
server.start
