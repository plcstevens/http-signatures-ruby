# frozen_string_literal: true

RSpec.shared_examples_for 'verifier' do
  it 'validates signature' do
    context.signer.sign message
    expect(context.verifier.valid?(message)).to eq(true)
  end

  it 'rejects if a signed header has changed' do
    context.signer.sign message
    message['Date'] = 'Thu, 12 Jan 2012 21:31:40 GMT'
    expect(context.verifier.valid?(message)).to eq(false)
  end
end
