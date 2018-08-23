require 'redis_record/value'

module RedisRecord
  class SortedSet
    attr_reader :key

    def self.contain_class
      Value
    end

    def initialize(key)
      @key = "#{self.class.name.underscore}:#{key}"
    end

    def get(id)
      score = Redis.current.zscore @key, id
      return nil if score.nil?
      self.class.contain_class.new(id, score)
    end

    def order(direction = :asc)
      values = case direction
               when :asc
                 Redis.current.zrange @key, 0, -1, withscores: true
               when :desc
                 Redis.current.zrevrange @key, 0, -1, withscores: true
               else
                 Redis.current.zrange @key, 0, -1, withscores: true
               end
      values.map { |value| self.class.contain_class.new(value[0], value[1]) }
    end

    def add(value)
      return false unless value.instance_of?(self.class.contain_class)

      if value.valid?
        Redis.current.zadd @key, value.value, value.key
        true
      else
        false
      end
    end

    def add_all(values)
      values.each { |value| add(value) }
    end

    def remove(key)
      Redis.current.zrem @key, key
    end

    def remove_all
      Redis.current.del @key
    end
  end
end
