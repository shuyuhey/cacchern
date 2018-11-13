# frozen_string_literal: true

class Counter < Cacchern::Object
  validates :value, presence: true, numericality: true
end
