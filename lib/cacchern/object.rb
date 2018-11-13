# frozen_string_literal: true

module Cacchern
  class Object
    include ActiveModel::Model

    attr_reader :id
    attr_reader :key
    attr_reader :value

    define_model_callbacks :save
    before_save { throw(:abort) unless valid? }

    def initialize(id, value)
      @id = id
      @key = "#{self.class.name.underscore}:#{id}"
      @value = value
    end

    def save
      valid? ? create_or_update : false
    end

    def save!
      valid? ? create_or_update : raise_validation_error
    end

    def delete
      Redis.current.del(key)
    end

    class << self
      def key(id)
        "#{self.name.underscore}:#{id}"
      end

      def find(id)
        key = self.key(id)
        value = Redis.current.get(key)

        new(id, value) if value
      end
    end

    private

    def create_or_update
      Redis.current.set(key, value) == 'OK'
    end
  end
end
