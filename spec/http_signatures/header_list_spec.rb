# frozen_string_literal: true

RSpec.describe HttpSignatures::HeaderList do
  describe '.from_string' do
    it 'loads and normalizes header names' do
      allow(described_class).to receive(:new)

      described_class.from_string(
        '(request-target) Date Content-Type'
      )

      expect(described_class).to have_received(:new).with(
        ['(request-target)', 'Date', 'Content-Type']
      )
    end
  end

  describe '.new' do
    it 'normalizes header names (downcase)' do
      list = described_class.new(['(request-target)', 'Date', 'Content-Type'])
      expect(list.to_a).to eq(['(request-target)', 'date', 'content-type'])
    end

    %w[Authorization Signature].each do |header|
      it "raises IllegalHeader for #{header} header" do
        expect do
          described_class.new([header])
        end.to raise_error(HttpSignatures::HeaderList::IllegalHeader)
      end
    end
  end

  describe '#to_str' do
    it 'joins normalized header names with spaces' do
      list = described_class.new(['(request-target)', 'Date', 'Content-Type'])
      expect(list.to_str).to eq('(request-target) date content-type')
    end
  end
end
