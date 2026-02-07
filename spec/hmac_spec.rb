# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rspec'
require 'openssl'

require_relative '../lib/totp'

RSpec.describe TOTP::HMAC do
  let(:key) { 'super-secret-key' }
  let(:message) { 'The quick brown fox jumps over the lazy dog.' }

  let(:expected_signature) { OpenSSL::HMAC.hexdigest('SHA256', key, message) }

  subject { described_class.hexdigest(key, message) }

  describe 'code' do
    it 'generates the correct HMAC-SHA256 hex string' do
      expect(subject).to eq(expected_signature)
    end

    context 'when the key is shorter than the block size (64 bytes)' do
      let(:key) { 'short-key' }

      it 'correctly pads the key and generates the hash' do
        control = OpenSSL::HMAC.hexdigest('SHA256', key, message)
        expect(subject).to eq(control)
      end
    end

    context 'when the key is longer than the block size (64 bytes)' do
      let(:key) { 'a' * 100 }

      it 'correctly pads the key and generates the hash' do
        control = OpenSSL::HMAC.hexdigest('SHA256', key, message)
        expect(subject).to eq(control)
      end
    end

    context 'with an empty string' do
      let(:key) { '' }
      it 'correctly pads an empty string and generates correct hash' do
        control = OpenSSL::HMAC.hexdigest('SHA256', key, message)
        expect(subject).to eq(control)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
