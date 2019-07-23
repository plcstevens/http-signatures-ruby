# frozen_string_literal: true

require 'net/http'

RSpec.describe HttpSignatures::Signer do
  subject(:signer) do
    described_class.new(key: key, algorithm: algorithm, header_list: header_list)
  end

  let(:example_date) { 'Mon, 28 Jul 2014 15:39:13 -0700' }

  let(:key) { HttpSignatures::Key.new(id: 'pda', secret: 'sh') }
  let(:algorithm) { HttpSignatures::Algorithm::Hmac.new('sha256') }
  let(:header_list) { HttpSignatures::HeaderList.new(%w[date content-type]) }

  let(:message) do
    Net::HTTP::Get.new(
      '/path?query=123',
      'Date' => example_date,
      'Content-Type' => 'text/plain',
      'Content-Length' => '123'
    )
  end

  let(:authorization_structure_pattern) do
    %r{
      \A
      Signature
      \s
      keyId="[\w-]+",
      algorithm="[\w-]+",
      (?:headers=".*",)?
      signature="[a-zA-Z0-9/+=]+"
      \z
    }x
  end

  let(:signature_structure_pattern) do
    %r{
      \A
      keyId="[\w-]+",
      algorithm="[\w-]+",
      (?:headers=".*",)?
      signature="[a-zA-Z0-9/+=]+"
      \z
    }x
  end

  describe '#sign' do
    it 'passes correct signing string to algorithm' do
      allow(algorithm).to receive(:sign).and_return('static')

      signer.sign(message)

      expect(algorithm).to have_received(:sign).with(
        'sh', ["date: #{example_date}", 'content-type: text/plain'].join("\n")
      ).at_least(:once)
    end
    it 'returns reference to the mutated input' do
      expect(signer.sign(message)).to eq(message)
    end
  end

  context 'when you have already signed' do
    before { signer.sign(message) }

    it 'has valid Authorization header structure' do
      expect(message['Authorization']).to match(authorization_structure_pattern)
    end
    it 'has valid Signature header structure' do
      expect(message['Signature']).to match(signature_structure_pattern)
    end
    it 'matches expected Authorization header' do
      expect(message['Authorization']).to eq(
        'Signature keyId="pda",algorithm="hmac-sha256",' \
          'headers="date content-type",signature="0ZoJq6cxYZRXe+TN85whSuQgJsam1tRyIal7ni+RMXA="'
      )
    end
    it 'matches expected Signature header' do
      expect(message['Signature']).to eq(
        'keyId="pda",algorithm="hmac-sha256",' \
          'headers="date content-type",signature="0ZoJq6cxYZRXe+TN85whSuQgJsam1tRyIal7ni+RMXA="'
      )
    end
  end
end
