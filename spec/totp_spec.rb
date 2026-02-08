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
        expect(subject.generate(secret, digits: 8, digest: Digest::SHA256.new)).to eq(46_119_246)
      end

      it 'generates the correct code for T=1111111109s' do
        # Counter 37037036
        allow(Time).to receive(:now).and_return(Time.at(1_111_111_109))
        expect(subject.generate(secret, digits: 8, digest: Digest::SHA256.new)).to eq(68_084_774)
      end

      it 'generates the correct code for T=1111111111s' do
        # Counter 37037037
        allow(Time).to receive(:now).and_return(Time.at(1_111_111_111))
        expect(subject.generate(secret, digits: 8, digest: Digest::SHA256.new)).to eq(67_062_674)
      end

      it 'generates the correct code for T=1234567890s' do
        # Counter 41152263
        allow(Time).to receive(:now).and_return(Time.at(1_234_567_890))
        expect(subject.generate(secret, digits: 8, digest: Digest::SHA256.new)).to eq(91_819_424)
      end

      it 'generates the correct code for T=2000000000s' do
        # Counter 66666666
        allow(Time).to receive(:now).and_return(Time.at(2_000_000_000))
        expect(subject.generate(secret, digits: 8, digest: Digest::SHA256.new)).to eq(90_698_825)
      end

      it 'generates the correct code for T=20000000000s' do
        # Counter 666666666
        allow(Time).to receive(:now).and_return(Time.at(20_000_000_000))
        expect(subject.generate(secret, digits: 8, digest: Digest::SHA256.new)).to eq(77_737_706)
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
        expect(subject.generate(secret, digits: 8)).to eq(94_287_082)
      end

      it 'generates the correct code for T=1111111109s' do
        # Counter 37037036
        allow(Time).to receive(:now).and_return(Time.at(1_111_111_109))
        expect(subject.generate(secret, digits: 8)).to eq(7_081_804)
      end

      it 'generates the correct code for T=1111111111s' do
        # Counter 37037037
        allow(Time).to receive(:now).and_return(Time.at(1_111_111_111))
        expect(subject.generate(secret, digits: 8)).to eq(14_050_471)
      end

      it 'generates the correct code for T=1234567890s' do
        # Counter 41152263
        allow(Time).to receive(:now).and_return(Time.at(1_234_567_890))
        expect(subject.generate(secret, digits: 8)).to eq(89_005_924)
      end

      it 'generates the correct code for T=2000000000s' do
        # Counter 66666666
        allow(Time).to receive(:now).and_return(Time.at(2_000_000_000))
        expect(subject.generate(secret, digits: 8)).to eq(69_279_037)
      end

      it 'generates the correct code for T=20000000000s' do
        # Counter 666666666
        allow(Time).to receive(:now).and_return(Time.at(20_000_000_000))
        expect(subject.generate(secret, digits: 8)).to eq(65_353_130)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
