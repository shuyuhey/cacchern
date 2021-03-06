# frozen_string_literal: true

module Cacchern
  class SortableMember
    include ActiveModel::Model

    attr_reader :key, :value

    define_model_callbacks :initialize
    before_initialize { throw(:abort) unless valid? }

    def initialize(key, value)
      @key = key
      @value = value
      run_callbacks :initialize
    end
  end
end
