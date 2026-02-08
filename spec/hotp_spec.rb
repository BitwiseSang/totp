# frozen_string_literal: true

require 'rspec'
require 'digest'
require_relative '../lib/totp'

# rubocop:disable Metrics/BlockLength
RSpec.describe TOTP::HOTP do
  let(:secret) { '12345678901234567890' }

  subject { described_class.method(:generate) }
  describe '#generate' do
    # This test utilizes the test values provided in RFC4226 page 32
    it 'it generates the correct code for counter' do
      expect(subject.call(secret, counter: 0, digest: Digest::SHA1.new)).to eq('755224')
    end

    it 'generates the correct code for counter 1' do
      expect(subject.call(secret, counter: 1, digest: Digest::SHA1.new)).to eq('287082')
    end

    it 'generates the correct code for counter 2' do
      expect(subject.call(secret, counter: 2, digest: Digest::SHA1.new)).to eq('359152')
    end

    it 'generates the correct code for counter 3' do
      expect(subject.call(secret, counter: 3, digest: Digest::SHA1.new)).to eq('969429')
    end

    it 'generates the correct code for counter 4' do
      expect(subject.call(secret, counter: 4, digest: Digest::SHA1.new)).to eq('338314')
    end

    it 'generates the correct code for counter 5' do
      expect(subject.call(secret, counter: 5, digest: Digest::SHA1.new)).to eq('254676')
    end

    it 'generates the correct code for counter 6' do
      expect(subject.call(secret, counter: 6, digest: Digest::SHA1.new)).to eq('287922')
    end

    it 'generates the correct code for counter 7' do
      expect(subject.call(secret, counter: 7, digest: Digest::SHA1.new)).to eq('162583')
    end

    it 'generates the correct code for counter 8' do
      expect(subject.call(secret, counter: 8, digest: Digest::SHA1.new)).to eq('399871')
    end

    it 'generates the correct code for counter 9' do
      expect(subject.call(secret, counter: 9, digest: Digest::SHA1.new)).to eq('520489')
    end
  end
end
# rubocop:enable Metrics/BlockLength
