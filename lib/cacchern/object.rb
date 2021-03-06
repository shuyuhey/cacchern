# frozen_string_literal: true

module Cacchern
  class Object
    include ActiveModel::Model

    class << self
      def key(id)
        "#{name.underscore}:#{id}"
      end

      def find(id)
        key = self.key(id)
        value = Redis.current.get(key)

        new(id, value) if value
      end
    end

    attr_reader :id
    attr_reader :key
    attr_reader :value

    def initialize(id, value)
      @id = id
      @key = "#{self.class.name.underscore}:#{id}"
      @value = value
    end

    def save(options = {})
      expires_in = options[:expires_in]
      valid? ? create_or_update(expires_in) : false
    end

    def save!(options = {})
      save(options) || raise_validation_error
    end

    def delete
      Redis.current.del(key)
    end

    private

    def create_or_update(expires_in = nil)
      if expires_in
        Redis.current.setex(key, expires_in.to_i, value)
      else
        Redis.current.set(key, value) == 'OK'
      end
    end
  end
end
