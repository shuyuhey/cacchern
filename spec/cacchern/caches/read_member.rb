# frozen_string_literal: true

class ReadMember < Cacchern::Member
  validates :value, presence: true, numericality: { only_integer: true }
end
