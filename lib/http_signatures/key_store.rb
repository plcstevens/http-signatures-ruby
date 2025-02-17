# frozen_string_literal: true

module HttpSignatures
  class KeyStore
    def initialize(key_hash)
      @keys = {}
      key_hash.each { |id, secret| self[id] = secret }
    end

    def fetch(id)
      @keys.fetch(id)
    end

    def only_key
      raise KeyError, "Expected 1 key, found #{@keys.size}" unless @keys.one?

      @keys.values.first
    end

    private

    def []=(id, secret)
      @keys[id] = Key.new(id: id, secret: secret)
    end
  end
end
