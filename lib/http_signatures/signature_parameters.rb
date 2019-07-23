# frozen_string_literal: true

require 'base64'

module HttpSignatures
  class SignatureParameters
    def initialize(key:, algorithm:, header_list:, signature:)
      @key = key
      @algorithm = algorithm
      @header_list = header_list
      @signature = signature
    end

    def to_str
      parameter_components.join(',')
    end

    private

    def parameter_components
      pc = []
      pc << format('keyId="%<id>s"', id: @key.id)
      pc << format('algorithm="%<name>s"', name: @algorithm.name)
      pc << format('headers="%<headers>s"', headers: @header_list.to_str)
      pc << format('signature="%<signature>s"', signature: signature_base64)
      pc
    end

    def signature_base64
      Base64.strict_encode64(@signature.to_str)
    end
  end
end
