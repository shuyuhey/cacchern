module Cacchern
  class List
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

    def initialize(id, values)
      @id = id
      @key = "#{self.class.name.underscore}:#{id}"
      # @value = value
    end

  end
end