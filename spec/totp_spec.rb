# frozen_string_literal: true

require 'rspec'
require_relative '../lib/totp'

# rubocop:disable Metrics/BlockLength

RSpec.describe TOTP::Generator do
  subject { described_class }

  describe '#generate' do
    # -------------------------------------------------------------------------
    # CONTEXT 1: SHA-256 (The Modern Standard)
    # RFC 6238 Appendix B - Test Vectors for SHA-256
    # Secret: 32 Bytes ("12345678901234567890123456789012")
    # -------------------------------------------------------------------------
    context 'when using default SHA-256' do
      let(:secret) { '12345678901234567890123456789012' }

      it 'generates the correct code for T=59s' do
        # Counter 1
        expect(subject.generate(secret, 59)).to eq(461_192)
      end

      it 'generates the correct code for T=1111111109s' do
        # Counter 37037036
        expect(subject.generate(secret, 1_111_111_109)).to eq(680_847)
      end

      it 'generates the correct code for T=1111111111s' do
        # Counter 37037037
        expect(subject.generate(secret, 1_111_111_111)).to eq(670_626)
      end

      it 'generates the correct code for T=1234567890s' do
        # Counter 41152263
        expect(subject.generate(secret, 1_234_567_890)).to eq(918_194)
      end

      it 'generates the correct code for T=2000000000s' do
        # Counter 66666666
        expect(subject.generate(secret, 2_000_000_000)).to eq(906_988)
      end
    end

    # -------------------------------------------------------------------------
    # CONTEXT 2: SHA-1 (The Legacy Standard)
    # RFC 6238 Appendix B - Test Vectors for SHA-1
    # Secret: 20 Bytes ("12345678901234567890")
    # -------------------------------------------------------------------------
    context 'when using legacy SHA-1' do
      let(:secret) { '12345678901234567890' }

      before do
        # Force the library to use SHA1 for this block
        stub_const('TOTP::HASH_FUNCTION', Digest::SHA1.method(:digest))
      end

      it 'generates the correct code for T=59s' do
        # Counter 1
        expect(subject.generate(secret, 59)).to eq(287_082)
      end

      it 'generates the correct code for T=1111111109s' do
        # Counter 37037036
        expect(subject.generate(secret, 1_111_111_109)).to eq(81_804) # NOTE: 081804 without leading zero
      end

      it 'generates the correct code for T=1111111111s' do
        # Counter 37037037
        expect(subject.generate(secret, 1_111_111_111)).to eq(50_471) # NOTE: 050471 without leading zero
      end

      it 'generates the correct code for T=1234567890s' do
        # Counter 41152263
        expect(subject.generate(secret, 1_234_567_890)).to eq(5_924) # NOTE: 005924 without leading zeros
      end

      it 'generates the correct code for T=2000000000s' do
        # Counter 66666666
        expect(subject.generate(secret, 2_000_000_000)).to eq(279_037)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
