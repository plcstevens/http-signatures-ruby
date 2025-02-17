# frozen_string_literal: true

require 'net/http'

RSpec.describe HttpSignatures::SigningString do
  subject(:signing_string) do
    described_class.new(
      header_list: header_list,
      message: message
    )
  end

  let(:date) { 'Tue, 29 Jul 2014 14:17:02 -0700' }

  let(:header_list) do
    HttpSignatures::HeaderList.from_string('(request-target) date')
  end

  let(:message) do
    Net::HTTP::Get.new('/path?query=123', 'date' => date, 'x-herring' => 'red')
  end

  describe '#to_str' do
    it 'returns correct signing string' do
      expect(signing_string.to_str).to eq(
        "(request-target): get /path?query=123\n" \
        "date: #{date}"
      )
    end

    context 'when header not in message' do
      let(:header_list) { HttpSignatures::HeaderList.from_string('nope') }

      it 'raises HeaderNotInMessage' do
        expect do
          signing_string.to_str
        end.to raise_error(HttpSignatures::HeaderNotInMessage)
      end
    end
  end
end
