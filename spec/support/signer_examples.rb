# frozen_string_literal: true

RSpec.shared_examples_for 'signer' do |expected_signature|
  let(:provided_signature) do
    HttpSignatures::SignatureParametersParser.new(message['signature']).parse.fetch('signature')
  end

  it 'returns expected signature' do
    context.signer.sign message
    expect(provided_signature).to eq(expected_signature)
  end
end
