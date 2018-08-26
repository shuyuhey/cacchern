# frozen_string_literal: true

require_relative 'score_value'

class ScoreSortedSet < Cacchern::SortedSet
  def self.contain_class
    ScoreValue
  end
end
