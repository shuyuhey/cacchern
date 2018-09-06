# frozen_string_literal: true

require 'cacchern/member'

module Cacchern
  class Set
    attr_reader :key

    class << self
      def contain_class(klass)
        @value_class = klass
      end

      def value_class
        @value_class || Member
      end
    end

    def initialize(key)
      @key = "#{self.class.name.underscore}:#{key}"
    end

    def all
      values = Redis.current.smembers @key
      values.map { |value| self.class.value_class.new(value) }
    end

    def add(value)
      return false unless value.instance_of?(self.class.value_class)

      if value.valid?
        Redis.current.sadd @key, value.value
        true
      else
        false
      end
    end
  end
end
