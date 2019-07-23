# frozen_string_literal: true

module HttpSignatures
  class SigningString
    REQUEST_TARGET = '(request-target)'

    def initialize(header_list:, message:)
      @header_list = header_list
      @message = message
    end

    def to_str
      @header_list.to_a.map do |header|
        format('%<header>s: %<value>s', header: header, value: header_value(header))
      end.join("\n")
    end

    def header_value(header)
      if header == REQUEST_TARGET
        request_target
      else
        @message.fetch(header) { raise HeaderNotInMessage, header }
      end
    end

    def request_target
      format('%<method>s %<path>s', method: @message.method.downcase, path: @message.path)
    end
  end

  class HeaderNotInMessage < StandardError
    def initialize(name)
      super("Header '#{name}' not in message")
    end
  end
end
