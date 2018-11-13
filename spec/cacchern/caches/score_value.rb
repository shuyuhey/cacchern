# frozen_string_literal: true

class ScoreValue < Cacchern::SortableMember
  validates :key, presence: true, numericality: { only_integer: true }
  validates :value, presence: true, numericality: true
end
