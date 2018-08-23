require 'redis_record/sorted_set'

module RedisRecord
  class IncrementableSortedSet < RedisRecord::SortedSet

    def increment(value)
      return false unless value.instance_of?(self.class.contain_class)

      if value.valid?
        Redis.current.zincrby @key, value.value, value.key
        true
      else
        false
      end
    end

    def increment_all(values)
      values.each { |value| increment(value) }
    end
  end
end
