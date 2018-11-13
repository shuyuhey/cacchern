# frozen_string_literal: true

class Token < Cacchern::Object
  validates :value, presence: true
end
