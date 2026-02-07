require 'pry'

module TOTP
  class HMAC
    attr_reader :code

    def initialize(secret_key, message)
      @message = message.bytes
      @secret_key = secret_key.bytes
      @block_size = BLOCK_SIZE
      @block_sized_key = compute_block_sized_key
      binding.pry
      @opad = compute_opad
      @ipad = compute_ipad
    end

    def code
      HASH_FUNCTION.call(concatenate(inner_key, outer_key)).pack('C*')
    end

    private

    def concatenate(a, b)
      a << b
    end

    def pad(message)
      (@block_size - message.length).times do
        message << 0
      end
    end

    def compute_block_sized_key(secret_key = @secret_key)
      if secret_key.length > @block_size
        pad(HASH_FUNCTION.call(@secret_key.pack('C*')).bytes)
      elsif secret_key.length < @block_size
        pad(@secret_key)
      else
        @secret_key
      end
    end

    def xor(a, _b)
      a.map.with_index { |value, idx| value ^ b[idx] }
    end

    # Block sized outer padding, consisting of repeated bytes value 0x5c (92
    # in decimal)
    def compute_opad
      pad([92])
    end

    # Block sized inner padding, consisting of repeated bytes value 0x36 (54
    # in decimal)
    def compute_ipad
      pad([54])
    end

    # The first pass produces the inner key
    def inner_key
      HASH_FUNCTION.call(concatenate(xor(@ipad, @block_sized_key), @message))
    end

    def outer_key
      xor(@opad, @block_sized_key)
    end
  end
end
