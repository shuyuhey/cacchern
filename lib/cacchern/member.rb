module Cacchern
  class Member
    include ActiveModel::Model

    attr_reader :value

    define_model_callbacks :initialize
    before_initialize { throw(:abort) unless valid? }

    def initialize(value)
      @value = value
      run_callbacks :initialize
    end
  end
end