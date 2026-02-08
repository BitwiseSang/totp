# frozen_string_literal: true

require 'rspec'
require 'digest'
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
        allow(Time).to receive(:now).and_return(Time.at(59))
        expect(subject.generate(secret, digest: Digest::SHA256.new)).to eq(461_192)
      end

      it 'generates the correct code for T=1111111109s' do
        # Counter 37037036
        allow(Time).to receive(:now).and_return(Time.at(1_111_111_109))
        expect(subject.generate(secret, digest: Digest::SHA256.new)).to eq(680_847)
      end

      it 'generates the correct code for T=1111111111s' do
        # Counter 37037037
        allow(Time).to receive(:now).and_return(Time.at(1_111_111_111))
        expect(subject.generate(secret, digest: Digest::SHA256.new)).to eq(670_626)
      end

      it 'generates the correct code for T=1234567890s' do
        # Counter 41152263
        allow(Time).to receive(:now).and_return(Time.at(1_234_567_890))
        expect(subject.generate(secret, digest: Digest::SHA256.new)).to eq(918_194)
      end

      it 'generates the correct code for T=2000000000s' do
        # Counter 66666666
        allow(Time).to receive(:now).and_return(Time.at(2_000_000_000))
        expect(subject.generate(secret, digest: Digest::SHA256.new)).to eq(906_988)
      end
    end

    # -------------------------------------------------------------------------
    # CONTEXT 2: SHA-1 (The Legacy Standard)
    # RFC 6238 Appendix B - Test Vectors for SHA-1
    # Secret: 20 Bytes ("12345678901234567890")
    # -------------------------------------------------------------------------
    context 'when using legacy SHA-1' do
      let(:secret) { '12345678901234567890' }

      it 'generates the correct code for T=59s' do
        # Counter 1
        allow(Time).to receive(:now).and_return(Time.at(59))
        expect(subject.generate(secret, digest: Digest::SHA1.new)).to eq(287_082)
      end

      it 'generates the correct code for T=1111111109s' do
        # Counter 37037036
        allow(Time).to receive(:now).and_return(Time.at(1_111_111_109))
        expect(subject.generate(secret, digest: Digest::SHA1.new)).to eq(81_804)
      end

      it 'generates the correct code for T=1111111111s' do
        # Counter 37037037
        allow(Time).to receive(:now).and_return(Time.at(1_111_111_111))
        expect(subject.generate(secret, digest: Digest::SHA1.new)).to eq(50_471)
      end

      it 'generates the correct code for T=1234567890s' do
        # Counter 41152263
        allow(Time).to receive(:now).and_return(Time.at(1_234_567_890))
        expect(subject.generate(secret, digest: Digest::SHA1.new)).to eq(5_924)
      end

      it 'generates the correct code for T=2000000000s' do
        # Counter 66666666
        allow(Time).to receive(:now).and_return(Time.at(2_000_000_000))
        expect(subject.generate(secret, digest: Digest::SHA1.new)).to eq(279_037)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
